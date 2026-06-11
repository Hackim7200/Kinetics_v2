import 'package:mobile_frontend/feature/circuit/domain/entities/circuit.dart';

enum CircuitPlayPhase { preStart, work, roundRest }

/// Snapshot of an active circuit play session (countdown, stations, rounds).
class CircuitPlayState {
  final Circuit circuit;
  final bool loading;
  final String? loadError;
  final List<String> stationNames;
  final int roundIndex;
  final int stationIndex;
  final int secondsLeft;
  final bool running;
  final bool finished;
  final CircuitPlayPhase phase;

  /// After the last station of a round, [roundRest] runs before this round index starts.
  final int pendingRoundAfterRest;

  const CircuitPlayState({
    required this.circuit,
    this.loading = true,
    this.loadError,
    this.stationNames = const [],
    this.roundIndex = 0,
    this.stationIndex = 0,
    this.secondsLeft = 0,
    this.running = false,
    this.finished = false,
    this.phase = CircuitPlayPhase.work,
    this.pendingRoundAfterRest = 0,
  });

  factory CircuitPlayState.initial(Circuit circuit) {
    return CircuitPlayState(circuit: circuit);
  }

  int get stationSec => circuit.stationDuration?.clamp(1, 3600) ?? 30;

  /// 0 = skip countdown and start the first station immediately.
  int get preStartCountdownSec {
    final value = circuit.countdown;
    if (value == null) return 10;
    return value.clamp(0, 300);
  }

  int get restBetweenRoundsSec => circuit.rest?.clamp(1, 3600) ?? 30;

  int get totalRounds => (circuit.rounds ?? 1).clamp(1, 999);

  String get timerPhaseLabel {
    switch (phase) {
      case CircuitPlayPhase.preStart:
        return 'GET READY';
      case CircuitPlayPhase.roundRest:
      case CircuitPlayPhase.work:
        return 'SECONDS';
    }
  }

  String get progressRoundLine {
    if (phase == CircuitPlayPhase.roundRest) {
      return 'Start round ${pendingRoundAfterRest + 1} after break';
    }
    return 'Round ${roundIndex + 1} of $totalRounds';
  }

  String get progressExerciseLine =>
      'Exercises ${stationIndex + 1} of ${stationNames.length}';

  String get currentStationDisplayName {
    if (stationNames.isEmpty) return '—';
    if (phase == CircuitPlayPhase.roundRest) return 'Break';
    final index = stationIndex.clamp(0, stationNames.length - 1);
    return stationNames[index];
  }

  CircuitPlayState copyWith({
    Circuit? circuit,
    bool? loading,
    Object? loadError = _unset,
    List<String>? stationNames,
    int? roundIndex,
    int? stationIndex,
    int? secondsLeft,
    bool? running,
    bool? finished,
    CircuitPlayPhase? phase,
    int? pendingRoundAfterRest,
  }) {
    return CircuitPlayState(
      circuit: circuit ?? this.circuit,
      loading: loading ?? this.loading,
      loadError: identical(loadError, _unset)
          ? this.loadError
          : loadError as String?,
      stationNames: stationNames ?? this.stationNames,
      roundIndex: roundIndex ?? this.roundIndex,
      stationIndex: stationIndex ?? this.stationIndex,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      running: running ?? this.running,
      finished: finished ?? this.finished,
      phase: phase ?? this.phase,
      pendingRoundAfterRest:
          pendingRoundAfterRest ?? this.pendingRoundAfterRest,
    );
  }
}

class _Unset {
  const _Unset();
}

const _unset = _Unset();
