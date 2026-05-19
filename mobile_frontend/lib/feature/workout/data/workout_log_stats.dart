import 'package:mobile_frontend/database/database.dart';

/// Derived metrics from persisted [WorkoutLog] rows (Drift).
abstract final class WorkoutLogStats {
  static double? trainingLoadChangePercentVsPrevious(
    double currentTotal,
    double? previousTotal,
  ) {
    if (previousTotal == null || previousTotal <= 0) return null;
    return ((currentTotal - previousTotal) / previousTotal) * 100.0;
  }

  /// Strength volume change for the most recent session with data vs the prior one.
  static double? trainingLoadChangePercentForLatestSession(
    String routineExerciseId,
    List<WorkoutLog> allLogs,
  ) {
    final ordered = allLogs
        .where((l) => l.routineExerciseId == routineExerciseId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    for (var i = 0; i < ordered.length; i++) {
      final log = ordered[i];
      final saved = log.trainingLoadChangePercent;
      if (saved != null) return saved;

      if (i + 1 < ordered.length) {
        final cur = log.totalTrainingLoad;
        final prev = ordered[i + 1].totalTrainingLoad;
        if (cur != null && prev != null && prev > 0) {
          return trainingLoadChangePercentVsPrevious(cur, prev);
        }
      }
    }
    return null;
  }
}
