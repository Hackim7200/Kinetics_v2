import 'package:mobile_frontend/feature/circuit/domain/entities/circuit.dart';

/// Pure validation for create/edit circuit forms.
abstract final class ValidateCircuitForm {
  static String? titleError(String? raw) {
    if ((raw ?? '').trim().isEmpty) return 'Circuit name is required.';
    return null;
  }

  static String? roundsError(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return 'Rounds is required: enter a positive number.';
    }
    final value = int.tryParse(trimmed);
    if (value == null || value < 1) {
      return 'Rounds is required: enter a positive number.';
    }
    return null;
  }

  static String? stationDurationError(String raw, {bool includeSameForEveryHint = false}) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return includeSameForEveryHint
          ? 'Exercise duration is required: enter seconds between 1 and 3600 (same for every exercise).'
          : 'Exercise duration is required: enter seconds between 1 and 3600.';
    }
    final value = int.tryParse(trimmed);
    if (value == null || value < 1 || value > 3600) {
      return includeSameForEveryHint
          ? 'Exercise duration is required: enter seconds between 1 and 3600 (same for every exercise).'
          : 'Exercise duration is required: enter seconds between 1 and 3600.';
    }
    return null;
  }

  static String? countdownError(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return 'Starting countdown: enter 0–300 seconds (0 = skip, starts work immediately).';
    }
    final value = int.tryParse(trimmed);
    if (value == null || value < 0 || value > 300) {
      return 'Starting countdown: enter 0–300 seconds (0 = skip, starts work immediately).';
    }
    return null;
  }

  static String? restError(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return 'Rest between rounds is required: enter seconds between 1 and 3600.';
    }
    final value = int.tryParse(trimmed);
    if (value == null || value < 1 || value > 3600) {
      return 'Rest between rounds is required: enter seconds between 1 and 3600.';
    }
    return null;
  }

  static String? firstError({
    required String title,
    required String roundsRaw,
    required String stationDurationRaw,
    required String countdownRaw,
    required String restRaw,
    bool includeSameForEveryHint = false,
  }) {
    return titleError(title) ??
        roundsError(roundsRaw) ??
        stationDurationError(
          stationDurationRaw,
          includeSameForEveryHint: includeSameForEveryHint,
        ) ??
        countdownError(countdownRaw) ??
        restError(restRaw);
  }

  static Circuit buildCircuit({
    required String id,
    required String title,
    required bool randomizeStationOrder,
    required String roundsRaw,
    required String stationDurationRaw,
    required String countdownRaw,
    required String restRaw,
  }) {
    return Circuit(
      id: id,
      title: title.trim(),
      order: Circuit.orderFromRandomized(randomizeStationOrder),
      rounds: int.parse(roundsRaw.trim()),
      stationDuration: int.parse(stationDurationRaw.trim()),
      countdown: int.parse(countdownRaw.trim()),
      rest: int.parse(restRaw.trim()),
    );
  }
}
