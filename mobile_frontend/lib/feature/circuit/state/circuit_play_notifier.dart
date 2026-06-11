import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:mobile_frontend/feature/circuit/data/repositories/circuit_exercise_repository.dart';
import 'package:mobile_frontend/feature/circuit/domain/entities/circuit.dart';
import 'package:mobile_frontend/feature/circuit/state/circuit_play_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'circuit_play_notifier.g.dart';

/// Owns circuit play session: station load, countdown timer, and audio cues.
@riverpod
class CircuitPlayNotifier extends _$CircuitPlayNotifier {
  late final AudioPlayer _beepPlayer;
  Timer? _timer;

  @override
  CircuitPlayState build(Circuit circuit) {
    _beepPlayer = AudioPlayer();
    unawaited(_beepPlayer.setReleaseMode(ReleaseMode.stop));
    ref.onDispose(() {
      _timer?.cancel();
      unawaited(_beepPlayer.dispose());
    });
    Future.microtask(_loadStations);
    return CircuitPlayState.initial(circuit);
  }

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
      for (var index = 0; index < 3; index++) {
        if (!ref.mounted) return;
        await _beepPlayer.stop();
        await Future<void>.delayed(const Duration(milliseconds: 60));
        await _beepPlayer.play(AssetSource('sounds/beep_long.wav'));
        await Future<void>.delayed(toneHold);
        if (index < 2) await Future<void>.delayed(gapBetween);
      }
    } catch (_) {
      for (var index = 0; index < 3; index++) {
        if (!ref.mounted) return;
        SystemSound.play(SystemSoundType.alert);
        await Future<void>.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  void _startPeriodicTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  Future<void> _loadStations() async {
    try {
      final circuitExercises = await ref
          .read(circuitExerciseRepositoryProvider)
          .circuitExercisesForCircuit(state.circuit.id);
      final names = circuitExercises
          .map((circuitExercise) => circuitExercise.title.trim())
          .where((name) => name.isNotEmpty)
          .toList();
      final playOrder = List<String>.from(names);
      if (state.circuit.isRandomised && playOrder.length > 1) {
        playOrder.shuffle(Random());
      }
      if (!ref.mounted) return;
      final preStart = state.preStartCountdownSec;
      state = state.copyWith(
        stationNames: playOrder,
        loading: false,
        roundIndex: 0,
        stationIndex: 0,
        running: playOrder.isNotEmpty,
        phase: preStart <= 0 ? CircuitPlayPhase.work : CircuitPlayPhase.preStart,
        secondsLeft: preStart <= 0 ? state.stationSec : preStart,
      );
      if (playOrder.isNotEmpty) {
        _startPeriodicTimer();
        if (preStart <= 0) {
          unawaited(_playBeep(long: true));
        }
      }
    } catch (error) {
      if (!ref.mounted) return;
      state = state.copyWith(
        loadError: '$error',
        loading: false,
      );
    }
  }

  void _tick(Timer timer) {
    if (!state.running || state.finished) return;
    if (state.secondsLeft > 1) {
      state = state.copyWith(secondsLeft: state.secondsLeft - 1);
      return;
    }
    _onSegmentComplete();
  }

  void _onSegmentComplete() {
    switch (state.phase) {
      case CircuitPlayPhase.preStart:
        _enterFirstWorkSegment();
        break;
      case CircuitPlayPhase.roundRest:
        _finishRoundRest();
        break;
      case CircuitPlayPhase.work:
        _advanceFromWorkStation();
        break;
    }
  }

  void _enterFirstWorkSegment() {
    unawaited(_playBeep(long: true));
    state = state.copyWith(
      phase: CircuitPlayPhase.work,
      roundIndex: 0,
      stationIndex: 0,
      secondsLeft: state.stationSec,
    );
  }

  void _finishRoundRest() {
    unawaited(_playBeep(long: true));
    state = state.copyWith(
      phase: CircuitPlayPhase.work,
      roundIndex: state.pendingRoundAfterRest,
      stationIndex: 0,
      secondsLeft: state.stationSec,
    );
  }

  void _advanceFromWorkStation() {
    final stationCount = state.stationNames.length;
    if (stationCount == 0) return;

    var nextStation = state.stationIndex + 1;
    var nextRound = state.roundIndex;
    if (nextStation >= stationCount) {
      nextStation = 0;
      nextRound++;
      if (nextRound >= state.totalRounds) {
        _timer?.cancel();
        unawaited(_playTripleLongBeeps());
        state = state.copyWith(
          finished: true,
          running: false,
          secondsLeft: 0,
        );
        return;
      }
      unawaited(_playBeep());
      state = state.copyWith(
        phase: CircuitPlayPhase.roundRest,
        secondsLeft: state.restBetweenRoundsSec,
        pendingRoundAfterRest: nextRound,
      );
      return;
    }

    unawaited(_playBeep());
    state = state.copyWith(
      stationIndex: nextStation,
      secondsLeft: state.stationSec,
    );
  }

  void toggleRun() {
    if (state.finished || state.stationNames.isEmpty) return;
    if (state.running) {
      _timer?.cancel();
      state = state.copyWith(running: false);
      return;
    }
    state = state.copyWith(running: true);
    _startPeriodicTimer();
  }

  void skipStation() {
    if (state.finished || state.stationNames.isEmpty) return;
    _onSegmentComplete();
  }
}
