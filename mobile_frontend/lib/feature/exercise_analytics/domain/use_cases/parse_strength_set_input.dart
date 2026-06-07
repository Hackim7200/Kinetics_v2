import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/use_cases/training_load.dart';

/// Parsed weight/reps field values for a strength set row.
class StrengthSetParseResult {
  final Set updated;
  final String weightFieldText;
  final String repsFieldText;

  const StrengthSetParseResult({
    required this.updated,
    required this.weightFieldText,
    required this.repsFieldText,
  });

  bool didChangeFrom(Set previous) {
    return updated.weight != previous.weight ||
        updated.reps != previous.reps ||
        updated.isLogged != previous.isLogged ||
        updated.trainingLoad != previous.trainingLoad;
  }
}

/// Pure parsing and validation for strength set weight/reps inputs.
abstract final class StrengthSetInput {
  static String weightFieldText(double? weight) {
    if (weight == null) return '';
    if (weight == weight.roundToDouble()) return weight.toInt().toString();
    return weight.toStringAsFixed(1);
  }

  static String repsFieldText(int? reps) {
    return reps != null ? '$reps' : '';
  }

  static StrengthSetParseResult parse({
    required Set current,
    required String weightText,
    required String repsText,
  }) {
    final trimmedWeight = weightText.trim();
    final trimmedReps = repsText.trim();

    double? weight;
    var displayWeight = trimmedWeight;
    if (trimmedWeight.isEmpty) {
      weight = null;
    } else {
      final parsed = double.tryParse(trimmedWeight);
      if (parsed == null || parsed <= 0 || parsed > 999.5) {
        displayWeight = weightFieldText(current.weight);
        weight = current.weight;
      } else {
        weight = parsed;
      }
    }

    int? reps;
    var displayReps = trimmedReps;
    if (trimmedReps.isEmpty) {
      reps = null;
    } else {
      final parsed = int.tryParse(trimmedReps);
      if (parsed == null ||
          parsed < TrainingTargetInput.minReps ||
          parsed > TrainingTargetInput.maxReps) {
        displayReps = repsFieldText(current.reps);
        reps = current.reps;
      } else {
        reps = parsed;
      }
    }

    final load = trainingLoadForSet(weight: weight, reps: reps);
    final updated = current.copyWith(
      weight: weight,
      reps: reps,
      trainingLoad: load,
    );

    return StrengthSetParseResult(
      updated: updated,
      weightFieldText: displayWeight,
      repsFieldText: displayReps,
    );
  }
}
