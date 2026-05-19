import 'package:mobile_frontend/common/utils/training_target_input.dart';

class _Unset {
  const _Unset();
}

/// Distinguishes “omit field” from “set to null” in [SetEntry.copyWith].
const _unset = _Unset();

/// `weight * reps` when both are in the same valid ranges as the session grid; otherwise null.
double? trainingLoadForStrengthSet(double? weight, int? reps) {
  if (weight == null || weight <= 0 || weight > 999.5) return null;
  if (reps == null ||
      reps < TrainingTargetInput.minReps ||
      reps > TrainingTargetInput.maxReps) {
    return null;
  }
  return weight * reps;
}

/// Sum of per-set training load (stored or derived from weight × reps).
double totalTrainingLoadForSets(Iterable<SetEntry> sets) {
  var total = 0.0;
  for (final s in sets) {
    final load = s.trainingLoad ?? trainingLoadForStrengthSet(s.weight, s.reps);
    if (load != null) {
      total += load;
    }
  }
  return total;
}

/// Longest single hold in a session (timer sets only); null if none logged.
int? maxDurationSecondsInSession(Iterable<SetEntry> sets) {
  int? best;
  for (final s in sets) {
    final d = s.durationSeconds;
    if (d != null && d > 0 && (best == null || d > best)) best = d;
  }
  return best;
}

/// Sum of logged hold durations for timer sets (seconds).
int totalDurationSecondsForSets(Iterable<SetEntry> sets) {
  var t = 0;
  for (final s in sets) {
    final d = s.durationSeconds;
    if (d != null && d > 0) t += d;
  }
  return t;
}

/// Value stored on [WorkoutLog.totalTrainingLoad]: strength Σ load, else timer Σ seconds.
double aggregateMetricForWorkoutLogSets(List<SetEntry> sets) {
  final hasTimerData = sets.any(
    (s) => s.durationSeconds != null && s.durationSeconds! > 0,
  );
  if (hasTimerData) {
    return totalDurationSecondsForSets(sets).toDouble();
  }
  return totalTrainingLoadForSets(sets);
}

class SetEntry {
  final int setNumber;
  final double? weight;
  final int? reps;
  final bool isCompleted;

  /// weight × reps for this set when complete; mirrored in Drift [trainingLoad].
  final double? trainingLoad;

  /// Logged hold duration for timer exercises; mirrored in Drift [durationSeconds].
  final int? durationSeconds;

  /// Drift row id for [SetEntry] when persisted; null for new rows.
  final String? datastoreId;

  const SetEntry({
    required this.setNumber,
    this.weight,
    this.reps,
    this.isCompleted = false,
    this.trainingLoad,
    this.durationSeconds,
    this.datastoreId,
  });

  SetEntry copyWith({
    int? setNumber,
    Object? weight = _unset,
    Object? reps = _unset,
    bool? isCompleted,
    Object? trainingLoad = _unset,
    Object? durationSeconds = _unset,
    Object? datastoreId = _unset,
  }) {
    return SetEntry(
      setNumber: setNumber ?? this.setNumber,
      weight: identical(weight, _unset) ? this.weight : weight as double?,
      reps: identical(reps, _unset) ? this.reps : reps as int?,
      isCompleted: isCompleted ?? this.isCompleted,
      trainingLoad: identical(trainingLoad, _unset)
          ? this.trainingLoad
          : trainingLoad as double?,
      durationSeconds: identical(durationSeconds, _unset)
          ? this.durationSeconds
          : durationSeconds as int?,
      datastoreId: identical(datastoreId, _unset)
          ? this.datastoreId
          : datastoreId as String?,
    );
  }
}

class TimerEntry {
  final Duration duration;
  final DateTime date;

  const TimerEntry({required this.duration, required this.date});

  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class WorkoutLog {
  final String id;
  final String exerciseId;
  final DateTime date;
  final List<SetEntry> sets;
  final List<TimerEntry> timerEntries;
  final double? estimatedOneRepMax;

  /// Persisted Σ training load on Drift [WorkoutLog.totalTrainingLoad] when the session is finished.
  final double? totalTrainingLoad;

  /// Persisted vs previous session; see [WorkoutLog.trainingLoadChangePercent] in schema.
  final double? trainingLoadChangePercent;

  const WorkoutLog({
    required this.id,
    required this.exerciseId,
    required this.date,
    this.sets = const [],
    this.timerEntries = const [],
    this.estimatedOneRepMax,
    this.totalTrainingLoad,
    this.trainingLoadChangePercent,
  });

  static List<WorkoutLog> get dummyBenchLogs => [
    WorkoutLog(
      id: 'wl1',
      exerciseId: 'e1',
      date: DateTime(2023, 10, 24),
      sets: const [
        SetEntry(setNumber: 1, weight: 100, reps: 8, isCompleted: true),
        SetEntry(setNumber: 2, weight: 100, reps: 8, isCompleted: false),
        SetEntry(setNumber: 3),
        SetEntry(setNumber: 4),
      ],
      estimatedOneRepMax: 112.5,
    ),
  ];

  static List<WorkoutLog> get dummyDipsLogs => [
    WorkoutLog(
      id: 'wl2',
      exerciseId: 'e2',
      date: DateTime(2023, 10, 24),
      sets: const [
        SetEntry(setNumber: 1, weight: 20, reps: 12, isCompleted: true),
        SetEntry(setNumber: 2, weight: 20, reps: 10, isCompleted: true),
        SetEntry(setNumber: 3, weight: 20, reps: 9, isCompleted: true),
      ],
      estimatedOneRepMax: 28.0,
    ),
  ];

  static List<WorkoutLog> get dummyShoulderLogs => [
    WorkoutLog(
      id: 'wl3',
      exerciseId: 'e3',
      date: DateTime(2023, 10, 24),
      sets: const [
        SetEntry(setNumber: 1, weight: 60, reps: 6, isCompleted: true),
        SetEntry(setNumber: 2, weight: 60, reps: 5, isCompleted: true),
      ],
      estimatedOneRepMax: 70.0,
    ),
  ];

  static List<WorkoutLog> get dummyTimerLogs => [
    WorkoutLog(
      id: 'wl4',
      exerciseId: 'e6',
      date: DateTime(2023, 10, 24),
      timerEntries: [
        TimerEntry(
          duration: const Duration(minutes: 1, seconds: 42),
          date: DateTime(2023, 10, 24),
        ),
        TimerEntry(
          duration: const Duration(minutes: 2, seconds: 0),
          date: DateTime(2023, 10, 22),
        ),
        TimerEntry(
          duration: const Duration(minutes: 1, seconds: 55),
          date: DateTime(2023, 10, 20),
        ),
      ],
    ),
  ];
}
