import 'package:mobile_frontend/database/database.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/workout_log.dart'
    as session;

/// Derived metrics from persisted [WorkoutLog] and [SetEntry] rows (Drift).
abstract final class WorkoutLogStats {
  static Future<double> _sessionTotal(
    WorkoutLog log,
    Future<List<session.SetEntry>> Function(String logId) loadSets,
  ) async {
    final stored = log.totalTrainingLoad;
    if (stored != null) return stored;
    final sets = await loadSets(log.id);
    return session.aggregateMetricForWorkoutLogSets(sets);
  }

  static double? trainingLoadChangePercentVsPrevious(
    double currentTotal,
    double? previousTotal,
  ) {
    if (previousTotal == null || previousTotal <= 0) return null;
    return ((currentTotal - previousTotal) / previousTotal) * 100.0;
  }

  /// Strength volume change for the most recent session with data vs the prior one.
  static Future<double?> trainingLoadChangePercentForLatestSession(
    String routineExerciseId,
    List<WorkoutLog> allLogs,
    Future<List<session.SetEntry>> Function(String logId) loadSets,
  ) async {
    final ordered = allLogs
        .where((l) => l.exerciseId == routineExerciseId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    for (var i = 0; i < ordered.length; i++) {
      final log = ordered[i];
      final cur = await _sessionTotal(log, loadSets);
      if (cur <= 0) continue;

      if (i + 1 < ordered.length) {
        final prev = await _sessionTotal(ordered[i + 1], loadSets);
        if (prev > 0) {
          return trainingLoadChangePercentVsPrevious(cur, prev);
        }
      }
    }
    return null;
  }
}
