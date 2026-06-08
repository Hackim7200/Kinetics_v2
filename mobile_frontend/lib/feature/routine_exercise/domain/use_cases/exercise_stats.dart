import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/utils/timer_routine_target.dart';
import 'package:mobile_frontend/feature/routine_exercise/domain/entities/exercise_session_log.dart';
import 'package:mobile_frontend/feature/routine_exercise/domain/entities/routine_exercise.dart';

/// Display helpers and derived metrics for routine exercise UI.
abstract final class ExerciseStats {
  static String subtitleLine(RoutineExercise routineExercise, int designIndex) {
    final sets = routineExercise.targetSets;
    final reps = routineExercise.targetReps?.trim();

    if (routineExercise.isTimer) {
      final direction = TimerRoutineTarget.label(routineExercise.timerTarget);
      if (sets != null) {
        return '$sets Sets | Timer · $direction';
      }
      return '— Sets | Timer · $direction';
    }

    if (sets != null && reps != null && reps.isNotEmpty) {
      return '$sets Sets | $reps Reps';
    }
    if (sets != null) {
      return '$sets Sets | —';
    }
    switch (designIndex % 3) {
      case 0:
        return '4 Sets | 8 Reps';
      case 1:
        return '3 Sets | 12 Reps';
      default:
        return '3 Sets | 6 Reps';
    }
  }

  static ExerciseProgressStyle progressFromDeltaPercent(
    double deltaPercent,
    Color outlineColor,
  ) {
    const green = Color(0xFF2E7D32);
    const amber = Color(0xFFF59E0B);
    const gray = Color(0xFF6B7280);

    String magnitudeString(double value) {
      final absolute = value.abs();
      if ((absolute - absolute.round()).abs() < 1e-9) {
        return absolute.round().toString();
      }
      return absolute.toStringAsFixed(1);
    }

    if (deltaPercent < 0) {
      return ExerciseProgressStyle(
        dotColor: gray,
        valueColor: gray,
        valueLabel: '-${magnitudeString(deltaPercent)}%',
        caption: 'VS LAST SESSION',
        captionColor: gray,
      );
    }

    if (deltaPercent == 0) {
      return ExerciseProgressStyle(
        dotColor: amber,
        valueColor: amber,
        valueLabel: 'Stable',
        caption: 'VS LAST SESSION',
        captionColor: outlineColor,
      );
    }

    return ExerciseProgressStyle(
      dotColor: green,
      valueColor: green,
      valueLabel: '+${magnitudeString(deltaPercent)}%',
      caption: 'VS LAST SESSION',
      captionColor: outlineColor,
    );
  }
}

abstract final class RoutineExerciseMetrics {
  static Map<String, int> exerciseCountsByRoutineId(
    List<RoutineExercise> routineExercises,
  ) {
    final map = <String, int>{};
    for (final routineExercise in routineExercises) {
      map.update(
        routineExercise.routineId,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    return map;
  }

  static Map<String, DateTime> lastPerformedByRoutineId({
    required List<RoutineExercise> routineExercises,
    required List<ExerciseSessionLog> logs,
  }) {
    if (routineExercises.isEmpty || logs.isEmpty) return {};

    final routineExerciseIdToRoutineId = {
      for (final routineExercise in routineExercises)
        routineExercise.id: routineExercise.routineId,
    };
    final best = <String, DateTime>{};
    for (final log in logs) {
      final routineId = routineExerciseIdToRoutineId[log.routineExerciseId];
      if (routineId == null) continue;
      final at = log.date.toUtc();
      best.update(
        routineId,
        (previous) => at.isAfter(previous) ? at : previous,
        ifAbsent: () => at,
      );
    }
    return best;
  }
}

class ExerciseProgressStyle {
  final Color dotColor;
  final Color valueColor;
  final String valueLabel;
  final String caption;
  final Color captionColor;

  const ExerciseProgressStyle({
    required this.dotColor,
    required this.valueColor,
    required this.valueLabel,
    required this.caption,
    required this.captionColor,
  });
}
