import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/use_cases/training_load.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/use_cases/validate_timer_set.dart';

/// Snapshot of the active timer (hold) logging session.
///
/// The widget holds one instance as `_state`. Getters derive UI rules (button
/// label, personal best for the stopwatch sheet, etc.) from the stored fields.
class TimerSessionState {
  /// Rows shown in the set-entry table (each holds a logged duration).
  final List<Set> sets;

  /// Persisted workout log id for today; null when exercise is not from a routine.
  final String? workoutId;

  /// False while loading from DB — disables the primary button.
  final bool sessionReady;

  /// True after the user taps FINISH WORKOUT — locks the table.
  final bool workoutFinished;

  /// True while the stopwatch sheet is open or a set is being saved.
  final bool addingSet;

  /// Configured set count for this exercise (e.g. 3).
  final int maxSets;

  /// Best hold in seconds from the last 30 days (from DB); shown on stopwatch sheet.
  final int? maxHoldSecondsLast30Days;

  const TimerSessionState({
    required this.sets,
    required this.maxSets,
    this.workoutId,
    this.sessionReady = true,
    this.workoutFinished = false,
    this.addingSet = false,
    this.maxHoldSecondsLast30Days,
  });

  /// One blank row (set 1), ready for the user to log a duration.
  factory TimerSessionState.initial(int maxSets) {
    return TimerSessionState(
      maxSets: maxSets,
      sets: [const Set(setNumber: 1)],
    );
  }

  /// True when the table still has only the default empty first row.
  ///
  /// Used on load so saved sets replace the blank row but not in-progress edits.
  bool get hasPristineFirstRow {
    if (sets.length != 1) return false;
    final first = sets.single;
    return first.setNumber == 1 &&
        first.id == null &&
        first.timeElapsed == null;
  }

  /// True when every set slot 1..maxSets has a logged duration.
  bool get sessionComplete => timerSessionLooksComplete(sets, maxSets);

  /// True when the last row has no duration yet — user should tap LOG SET.
  bool get lastRowNeedsDuration =>
      sets.isNotEmpty && !timerSetHasDuration(sets.last);

  /// Personal best for the stopwatch sheet: max of last 30 days and today's sets.
  Duration? get personalBestDuration {
    int? bestSeconds = maxHoldSecondsLast30Days;
    final todayMax = maxTimeElapsedInSession(sets);
    if (todayMax != null &&
        todayMax > 0 &&
        (bestSeconds == null || todayMax > bestSeconds)) {
      bestSeconds = todayMax;
    }
    if (bestSeconds == null || bestSeconds < 1) return null;
    return Duration(seconds: bestSeconds);
  }

  /// Whether the LOG SET / FINISH WORKOUT button should be tappable.
  bool get primaryButtonEnabled {
    if (!sessionReady || workoutFinished || addingSet) return false;
    if (sessionComplete) return true;
    return lastRowNeedsDuration;
  }

  /// Button text: LOG SET while sets remain, otherwise FINISH WORKOUT.
  String get primaryButtonLabel =>
      sessionComplete ? 'FINISH WORKOUT' : 'LOG SET';

  /// Returns a copy with selected fields replaced; omitted fields stay unchanged.
  TimerSessionState copyWith({
    List<Set>? sets,
    Object? workoutId = _unset,
    bool? sessionReady,
    bool? workoutFinished,
    bool? addingSet,
    Object? maxHoldSecondsLast30Days = _unset,
  }) {
    return TimerSessionState(
      sets: sets ?? this.sets,
      maxSets: maxSets,
      workoutId: identical(workoutId, _unset)
          ? this.workoutId
          : workoutId as String?,
      sessionReady: sessionReady ?? this.sessionReady,
      workoutFinished: workoutFinished ?? this.workoutFinished,
      addingSet: addingSet ?? this.addingSet,
      maxHoldSecondsLast30Days: identical(maxHoldSecondsLast30Days, _unset)
          ? this.maxHoldSecondsLast30Days
          : maxHoldSecondsLast30Days as int?,
    );
  }
}

class _Unset {
  const _Unset();
}

const _unset = _Unset();
