import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/use_cases/validate_strength_set.dart';

/// Snapshot of the active strength logging session.
///
/// The widget holds one instance as `_state`. Getters derive UI rules (which row
/// is editable, button label, etc.) from the stored fields.
class StrengthSessionState {
  /// Rows shown in the set-entry table.
  final List<Set> sets;

  /// Persisted workout log id for today; null when exercise is not from a routine.
  final String? workoutId;

  /// False while loading from DB — disables the primary button.
  final bool sessionReady;

  /// True after the user taps FINISH WORKOUT — locks the table.
  final bool workoutFinished;

  /// True while ADD SET is in flight — prevents double-tap.
  final bool addingSet;

  /// Configured set count for this exercise (e.g. 3).
  final int maxSets;

  const StrengthSessionState({
    required this.sets,
    required this.maxSets,
    this.workoutId,
    this.sessionReady = true,
    this.workoutFinished = false,
    this.addingSet = false,
  });

  /// One blank row (set 1), ready for the user to type weight/reps.
  factory StrengthSessionState.initial(int maxSets) {
    return StrengthSessionState(
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
        first.weight == null &&
        first.reps == null;
  }

  /// True when the last row has valid weight and reps (can ADD SET or FINISH).
  bool get lastRowComplete =>
      sets.isNotEmpty && strengthSetHasValues(sets.last);

  /// True when more set rows can still be added before hitting [maxSets].
  bool get canAddAnotherSet => sets.length < maxSets;

  /// Index of the editable row, or null when the session is finished.
  ///
  /// Only the last row is editable; earlier rows are read-only after ADD SET.
  int? get editableRowIndex {
    if (workoutFinished || sets.isEmpty) return null;
    return sets.length - 1;
  }

  /// Whether the ADD SET / FINISH WORKOUT button should be tappable.
  bool get primaryButtonEnabled =>
      sessionReady && lastRowComplete && !addingSet;

  /// Button text: ADD SET while slots remain, otherwise FINISH WORKOUT.
  String get primaryButtonLabel =>
      canAddAnotherSet ? 'ADD SET' : 'FINISH WORKOUT';

  /// Returns a copy with selected fields replaced; omitted fields stay unchanged.
  StrengthSessionState copyWith({
    List<Set>? sets,
    Object? workoutId = _unset,
    bool? sessionReady,
    bool? workoutFinished,
    bool? addingSet,
  }) {
    return StrengthSessionState(
      sets: sets ?? this.sets,
      maxSets: maxSets,
      workoutId: identical(workoutId, _unset)
          ? this.workoutId
          : workoutId as String?,
      sessionReady: sessionReady ?? this.sessionReady,
      workoutFinished: workoutFinished ?? this.workoutFinished,
      addingSet: addingSet ?? this.addingSet,
    );
  }
}

class _Unset {
  const _Unset();
}

const _unset = _Unset();
