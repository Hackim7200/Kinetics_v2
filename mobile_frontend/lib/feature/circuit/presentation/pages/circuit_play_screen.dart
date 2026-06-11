import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/feature/circuit/domain/entities/circuit.dart';
import 'package:mobile_frontend/feature/circuit/state/circuit_play_notifier.dart';
import 'package:mobile_frontend/feature/circuit/state/circuit_play_state.dart';

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

class _CircuitPlayScreenState extends ConsumerState<CircuitPlayScreen> {
  late final _provider = circuitPlayProvider(widget.circuit);

  void _onPlayStateChanged(CircuitPlayState? previous, CircuitPlayState next) {
    if (previous == null) {
      if (!next.loading &&
          next.stationNames.isNotEmpty &&
          next.preStartCountdownSec <= 0 &&
          next.phase == CircuitPlayPhase.work) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          HapticFeedback.mediumImpact();
        });
      }
      return;
    }

    if (!previous.finished && next.finished) {
      HapticFeedback.heavyImpact();
      return;
    }

    final enteredWorkFromCountdown = previous.phase == CircuitPlayPhase.preStart &&
        next.phase == CircuitPlayPhase.work;
    final enteredWorkFromRest = previous.phase == CircuitPlayPhase.roundRest &&
        next.phase == CircuitPlayPhase.work;
    if (enteredWorkFromCountdown || enteredWorkFromRest) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        HapticFeedback.mediumImpact();
      });
    }
  }

  Color _countdownDigitColor(CircuitPlayState playState, ColorScheme colorScheme) {
    switch (playState.phase) {
      case CircuitPlayPhase.roundRest:
        return Colors.amber.shade200;
      case CircuitPlayPhase.preStart:
        return Colors.lightGreen.shade300;
      case CircuitPlayPhase.work:
        return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final playState = ref.watch(_provider);

    ref.listen(_provider, _onPlayStateChanged);

    return Scaffold(
      appBar: KineticAppBar(
        title: 'CIRCUIT',
        showBackButton: true,
      ),
      body: _buildBody(context, playState, colorScheme),
    );
  }

  Widget _buildBody(
    BuildContext context,
    CircuitPlayState playState,
    ColorScheme colorScheme,
  ) {
    if (playState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (playState.loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            playState.loadError!,
            style: GoogleFonts.inter(color: colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (playState.stationNames.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Add exercises to this circuit before playing.',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final notifier = ref.read(_provider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.circuit.title.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              color: colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            playState.currentStationDisplayName.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              height: 1.1,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                playState.progressRoundLine,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: colorScheme.tertiary,
                ),
              ),
              if (playState.phase != CircuitPlayPhase.roundRest) ...[
                const SizedBox(height: 2),
                Text(
                  playState.progressExerciseLine,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: colorScheme.tertiary,
                  ),
                ),
              ],
            ],
          ),
          const Spacer(),
          if (playState.finished) ...[
            Text(
              'CIRCUIT COMPLETE',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).maybePop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(color: colorScheme.primary, width: 2),
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
              '${playState.secondsLeft}',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 96,
                fontWeight: FontWeight.w900,
                letterSpacing: -4,
                color: _countdownDigitColor(playState, colorScheme),
                height: 1,
              ),
            ),
            Text(
              playState.timerPhaseLabel,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 3,
                color: colorScheme.outline,
              ),
            ),
          ],
          const Spacer(),
          if (!playState.finished)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.tonal(
                  onPressed: notifier.skipStation,
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primaryContainer,
                    foregroundColor: colorScheme.onPrimaryContainer,
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
                  onPressed: notifier.toggleRun,
                  child: Icon(
                    playState.running ? Icons.pause : Icons.play_arrow,
                    size: 28,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
