import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/circuit/data/circuit_exercise_service.dart';

/// Runs a circuit: same station duration per exercise; [Circuit.rounds] defaults to 1 if unset.
/// Get-ready countdown uses [Circuit.preStartCountdownSeconds] (default 10s
/// when unset; 0 skips). Rest between rounds uses [Circuit.restBetweenRoundsSeconds]
/// (default 30s when unset).
class CircuitPlayScreen extends ConsumerStatefulWidget {
  final Circuit circuit;

  const CircuitPlayScreen({super.key, required this.circuit});

  @override
  ConsumerState<CircuitPlayScreen> createState() => _CircuitPlayScreenState();
}

enum _CircuitPhase { preStart, work, roundRest }

class _CircuitPlayScreenState extends ConsumerState<CircuitPlayScreen> {
  late final CircuitExerciseService _circuitExerciseService;
  late final AudioPlayer _beepPlayer;
  List<String> _stationNames = [];
  bool _loading = true;
  String? _loadError;

  int _roundIndex = 0;
  int _stationIndex = 0;
  int _secondsLeft = 0;
  bool _running = false;
  bool _finished = false;
  Timer? _timer;
  _CircuitPhase _phase = _CircuitPhase.work;

  /// After the last station of a round, [roundRest] runs before this round index starts.
  int _pendingRoundAfterRest = 0;

  int get _stationSec =>
      widget.circuit.stationDurationSeconds?.clamp(1, 3600) ?? 30;

  /// 0 = skip countdown and start the first station immediately.
  int get _preStartCountdownSec {
    final v = widget.circuit.preStartCountdownSeconds;
    if (v == null) return 10;
    return v.clamp(0, 300);
  }

  int get _restBetweenRoundsSec =>
      widget.circuit.restBetweenRoundsSeconds?.clamp(1, 3600) ?? 30;

  int get _totalRounds => (widget.circuit.rounds ?? 1).clamp(1, 999);

  Future<void> _playBeep({bool long = false}) async {
    final path = long ? 'sounds/beep_long.wav' : 'sounds/beep.wav';
    try {
      await _beepPlayer.stop();
      await _beepPlayer.play(AssetSource(path));
    } catch (_) {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  /// Three long beeps when the full circuit is done.
  ///
  /// Uses fixed delays instead of [onPlayerComplete], which is unreliable with
  /// [stop]/asset playback on some Android/iOS builds (often only one beep is heard).
  Future<void> _playTripleLongBeeps() async {
    // assets/sounds/beep_long.wav is 0.55s; pad for decoder/device variance.
    const toneHold = Duration(milliseconds: 620);
    const gapBetween = Duration(milliseconds: 240);
    try {
      for (var i = 0; i < 3; i++) {
        if (!mounted) return;
        await _beepPlayer.stop();
        await Future<void>.delayed(const Duration(milliseconds: 60));
        await _beepPlayer.play(AssetSource('sounds/beep_long.wav'));
        await Future<void>.delayed(toneHold);
        if (i < 2) await Future<void>.delayed(gapBetween);
      }
    } catch (_) {
      for (var i = 0; i < 3; i++) {
        if (!mounted) return;
        SystemSound.play(SystemSoundType.alert);
        await Future<void>.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  void _startPeriodicTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  @override
  void initState() {
    super.initState();
    _circuitExerciseService = CircuitExerciseService(ref.read(appDatabaseProvider));
    _beepPlayer = AudioPlayer();
    unawaited(_beepPlayer.setReleaseMode(ReleaseMode.stop));
    _loadStations();
  }

  @override
  void dispose() {
    _timer?.cancel();
    unawaited(_beepPlayer.dispose());
    super.dispose();
  }

  Future<void> _loadStations() async {
    try {
      final links = await _circuitExerciseService.linksForCircuit(widget.circuit.id);
      final map = await _circuitExerciseService.exerciseMapForIds(
        links.map((l) => l.exerciseId).toSet(),
      );
      final names = links
          .map((l) => map[l.exerciseId]?.name.trim() ?? 'Exercise')
          .where((n) => n.isNotEmpty)
          .toList();
      final playOrder = List<String>.from(names);
      if (widget.circuit.randomizeStationOrder == true && playOrder.length > 1) {
        playOrder.shuffle(Random());
      }
      if (!mounted) return;
      final preStart = _preStartCountdownSec;
      setState(() {
        _stationNames = playOrder;
        _loading = false;
        _roundIndex = 0;
        _stationIndex = 0;
        _running = playOrder.isNotEmpty;
        if (preStart <= 0) {
          _phase = _CircuitPhase.work;
          _secondsLeft = _stationSec;
        } else {
          _phase = _CircuitPhase.preStart;
          _secondsLeft = preStart;
        }
      });
      if (playOrder.isNotEmpty) {
        _startPeriodicTimer();
        if (preStart <= 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            HapticFeedback.mediumImpact();
            unawaited(_playBeep(long: true));
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = '$e';
        _loading = false;
      });
    }
  }

  void _tick(Timer t) {
    if (!_running || _finished) return;
    if (_secondsLeft > 1) {
      setState(() => _secondsLeft--);
      return;
    }
    _onSegmentComplete();
  }

  void _onSegmentComplete() {
    switch (_phase) {
      case _CircuitPhase.preStart:
        _enterFirstWorkSegment();
        break;
      case _CircuitPhase.roundRest:
        _finishRoundRest();
        break;
      case _CircuitPhase.work:
        _advanceFromWorkStation();
        break;
    }
  }

  void _enterFirstWorkSegment() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      HapticFeedback.mediumImpact();
    });
    unawaited(_playBeep(long: true));
    setState(() {
      _phase = _CircuitPhase.work;
      _roundIndex = 0;
      _stationIndex = 0;
      _secondsLeft = _stationSec;
    });
  }

  void _finishRoundRest() {
    unawaited(_playBeep(long: true));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      HapticFeedback.mediumImpact();
    });
    setState(() {
      _phase = _CircuitPhase.work;
      _roundIndex = _pendingRoundAfterRest;
      _stationIndex = 0;
      _secondsLeft = _stationSec;
    });
  }

  void _advanceFromWorkStation() {
    final n = _stationNames.length;
    if (n == 0) return;

    var nextStation = _stationIndex + 1;
    var nextRound = _roundIndex;
    if (nextStation >= n) {
      nextStation = 0;
      nextRound++;
      if (nextRound >= _totalRounds) {
        _timer?.cancel();
        HapticFeedback.heavyImpact();
        unawaited(_playTripleLongBeeps());
        setState(() {
          _finished = true;
          _running = false;
          _secondsLeft = 0;
        });
        return;
      }
      unawaited(_playBeep());
      setState(() {
        _phase = _CircuitPhase.roundRest;
        _secondsLeft = _restBetweenRoundsSec;
        _pendingRoundAfterRest = nextRound;
      });
      return;
    }

    unawaited(_playBeep());
    setState(() {
      _stationIndex = nextStation;
      _secondsLeft = _stationSec;
    });
  }

  void _toggleRun() {
    if (_finished || _stationNames.isEmpty) return;
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
      return;
    }
    setState(() => _running = true);
    _startPeriodicTimer();
  }

  void _skipStation() {
    if (_finished || _stationNames.isEmpty) return;
    _onSegmentComplete();
  }

  String get _timerPhaseLabel {
    switch (_phase) {
      case _CircuitPhase.preStart:
        return 'GET READY';
      case _CircuitPhase.roundRest:
      case _CircuitPhase.work:
        return 'SECONDS';
    }
  }

  String get _progressRoundLine {
    if (_phase == _CircuitPhase.roundRest) {
      return 'Start round ${_pendingRoundAfterRest + 1} after break';
    }
    return 'Round ${_roundIndex + 1} of $_totalRounds';
  }

  String get _progressExerciseLine =>
      'Exercises ${_stationIndex + 1} of ${_stationNames.length}';

  Color _countdownDigitColor(ColorScheme cs) {
    switch (_phase) {
      case _CircuitPhase.roundRest:
        return Colors.amber.shade200;
      case _CircuitPhase.preStart:
        return Colors.lightGreen.shade300;
      case _CircuitPhase.work:
        return cs.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final name = _stationNames.isEmpty
        ? '—'
        : _phase == _CircuitPhase.roundRest
            ? 'Break'
            : _stationNames[_stationIndex.clamp(0, _stationNames.length - 1)];

    return Scaffold(
      appBar: KineticAppBar(
        title: 'CIRCUIT',
        showBackButton: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _loadError != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      _loadError!,
                      style: GoogleFonts.inter(color: cs.error),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : _stationNames.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Add exercises to this circuit before playing.',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: cs.outline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.circuit.name.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                              color: cs.outline,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            name.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                              height: 1.1,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _progressRoundLine,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: cs.tertiary,
                                ),
                              ),
                              if (_phase != _CircuitPhase.roundRest) ...[
                                const SizedBox(height: 2),
                                Text(
                                  _progressExerciseLine,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: cs.tertiary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const Spacer(),
                          if (_finished) ...[
                            Text(
                              'CIRCUIT COMPLETE',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2,
                                color: cs.primary,
                              ),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  foregroundColor: cs.primary,
                                  side: BorderSide(
                                    color: cs.primary,
                                    width: 2,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                child: Text(
                                  'EXIT',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 3,
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            Text(
                              '$_secondsLeft',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 96,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -4,
                                color: _countdownDigitColor(cs),
                                height: 1,
                              ),
                            ),
                            Text(
                              _timerPhaseLabel,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 3,
                                color: cs.outline,
                              ),
                            ),
                          ],
                          const Spacer(),
                          if (!_finished)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FilledButton.tonal(
                                  onPressed: _skipStation,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: cs.primaryContainer,
                                    foregroundColor: cs.onPrimaryContainer,
                                  ),
                                  child: Text(
                                    'SKIP',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                FilledButton(
                                  onPressed: _toggleRun,
                                  child: Icon(
                                    _running ? Icons.pause : Icons.play_arrow,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
    );
  }
}
