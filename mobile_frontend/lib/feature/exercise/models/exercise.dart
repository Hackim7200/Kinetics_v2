import 'package:mobile_frontend/common/utils/timer_routine_target.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/workout_log.dart';

enum ExerciseType { strength, timer }

class Exercise {
  final String id;
  final String name;
  final ExerciseType type;
  final int sets;
  final int reps;
  final double weight;
  final Duration? duration;
  final double? progressPercent;
  final String? progressLabel;
  final List<WorkoutLog> logs;
  /// RoutineExercise id when opened from a routine; used to load prior session notes.
  final String? routineExerciseId;

  /// [TimerRoutineTarget.increase] or [TimerRoutineTarget.decrease] when from a routine link.
  final String? timerTarget;

  const Exercise({
    required this.id,
    required this.name,
    required this.type,
    this.sets = 0,
    this.reps = 0,
    this.weight = 0,
    this.duration,
    this.progressPercent,
    this.progressLabel,
    this.logs = const [],
    this.routineExerciseId,
    this.timerTarget,
  });

  bool get isStrength => type == ExerciseType.strength;
  bool get isTimer => type == ExerciseType.timer;

  String get summaryText {
    if (isStrength) {
      return '$sets Sets | $reps Reps';
    }
    final dir = TimerRoutineTarget.label(timerTarget);
    if (sets > 0) {
      return '$sets Sets | Timer · $dir';
    }
    return '— Sets | Timer · $dir';
  }
}
