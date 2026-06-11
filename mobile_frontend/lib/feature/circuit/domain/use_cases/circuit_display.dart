import 'package:mobile_frontend/feature/circuit/domain/entities/circuit.dart';
import 'package:mobile_frontend/feature/circuit/domain/entities/circuit_exercise.dart';

/// Display helpers and derived metrics for circuit UI.
abstract final class CircuitDisplay {
  static Map<String, int> exerciseCountsByCircuitId(
    List<CircuitExercise> circuitExercises,
  ) {
    final map = <String, int>{};
    for (final circuitExercise in circuitExercises) {
      map.update(
        circuitExercise.circuitId,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    return map;
  }

  static String stationSubtitle(int? stationSeconds) {
    final seconds = stationSeconds;
    if (seconds == null) return '—';
    return '$seconds SEC';
  }

  static String orderLabel(Circuit circuit) {
    return circuit.isRandomised ? 'RANDOM' : 'LIST';
  }

  static String orderListSubtitle(Circuit circuit) {
    return circuit.isRandomised ? 'RANDOM' : 'SEQUENTIAL';
  }

  static String countdownLabel(int? countdownSeconds) {
    if (countdownSeconds == null) return '—';
    if (countdownSeconds == 0) return 'OFF';
    return '$countdownSeconds SEC';
  }

  static String secondsLabel(int? seconds) {
    if (seconds == null) return '—';
    return '$seconds SEC';
  }
}
