import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/exercise/models/exercise.dart';
import 'package:mobile_frontend/feature/exercise_analytics/data/workout_service.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/set_entry_editable_row.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/set_entry_primary_action_button.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/set_entry_read_only_row.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/set_entry_table_header.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/set_entry_table_layout.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/strength_set_validation.dart';

/// Strength session: log sets with weight and reps, then finish the workout.
///
/// Only the latest row is editable; earlier rows lock after **ADD SET**.
class SetEntryTableWeight extends ConsumerStatefulWidget {
  final Exercise exercise;
  final void Function(List<Set> sets)? onSetsChanged;
  final VoidCallback? onWorkoutFinished;

  const SetEntryTableWeight({
    super.key,
    required this.exercise,
    this.onSetsChanged,
    this.onWorkoutFinished,
  });

  @override
  ConsumerState<SetEntryTableWeight> createState() =>
      _SetEntryTableWeightState();
}

class _SetEntryTableWeightState extends ConsumerState<SetEntryTableWeight> {
  final GlobalKey<SetEntryEditableRowState> _editableRowKey = GlobalKey();

  late List<Set> _sets;
  bool _workoutFinished = false;
  bool _sessionReady = true;
  bool _addingSet = false;
  String? _workoutId;
  late final WorkoutService _sessionSetsService;

  int get _maxSets =>
      TrainingTargetInput.clampConfiguredSets(widget.exercise.sets);

  int? get _editableRowIndex {
    if (_workoutFinished || _sets.isEmpty) return null;
    return _sets.length - 1;
  }

  bool get _lastRowComplete =>
      _sets.isNotEmpty && strengthSetHasValues(_sets.last);

  bool get _canAddAnotherSet => _sets.length < _maxSets;

  @override
  void initState() {
    super.initState();
    _sessionSetsService = WorkoutService(ref.read(appDatabaseProvider));
    _sets = [const Set(setNumber: 1)];
    _notifySetsChanged();
    final linkId = widget.exercise.routineExerciseId;
    if (linkId != null) {
      _sessionReady = false;
      _loadPersistedSession(linkId);
    }
  }

  void _notifySetsChanged() => widget.onSetsChanged?.call(_sets);

  Future<void> _loadPersistedSession(String routineExerciseId) async {
    try {
      final workout = await _sessionSetsService.getOrCreateTodaysWorkout(
        routineExerciseId,
      );
      final loaded = await _sessionSetsService.loadSets(workout.id);
      if (!mounted) return;
      setState(() {
        _workoutId = workout.id;
        if (loaded.isNotEmpty && _hasPristineFirstRow) {
          _sets = loaded;
        }
        _workoutFinished = strengthSessionLooksComplete(_sets, _maxSets);
        _sessionReady = true;
      });
      _notifySetsChanged();
    } catch (error, stackTrace) {
      debugPrint('SessionSetsService load failed: $error $stackTrace');
      if (mounted) setState(() => _sessionReady = true);
    }
  }

  bool get _hasPristineFirstRow {
    if (_sets.length != 1) return false;
    final first = _sets.single;
    return first.setNumber == 1 &&
        first.id == null &&
        first.weight == null &&
        first.reps == null;
  }

  void _persistSetRow(int index, Set entry) {
    final workoutId = _workoutId;
    if (workoutId == null) return;
    _sessionSetsService
        .persistSet(workoutId, entry)
        .then((updated) {
          if (!mounted) return;
          setState(() => _sets[index] = updated);
          _notifySetsChanged();
        })
        .catchError((Object error, StackTrace stackTrace) {
          debugPrint('SessionSetsService persist failed: $error $stackTrace');
        });
  }

  void _onPrimaryAction() {
    _editableRowKey.currentState?.flushToParent();
    FocusScope.of(context).unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_lastRowComplete) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enter weight and reps for this set first.'),
          ),
        );
        return;
      }
      if (_canAddAnotherSet) {
        if (_addingSet) return;
        _addNextSet();
      } else {
        _finishWorkout(workoutId: _workoutId);
      }
    });
  }

  void _addNextSet() {
    final nextNumber = _sets.length + 1;
    final workoutId = _workoutId;
    if (workoutId == null) {
      setState(() => _sets.add(Set(setNumber: nextNumber)));
      _notifySetsChanged();
      return;
    }
    setState(() => _addingSet = true);
    _persistAndAddSet(workoutId, nextNumber);
  }

  void _finishWorkout({String? workoutId}) {
    final lastIndex = _sets.length - 1;
    final lastEntry = _sets[lastIndex];
    setState(() => _workoutFinished = true);

    if (workoutId == null) {
      widget.onWorkoutFinished?.call();
      return;
    }

    _sessionSetsService
        .persistSet(workoutId, lastEntry)
        .then((saved) async {
          if (!mounted) return;
          final updatedSets = List<Set>.from(_sets);
          updatedSets[lastIndex] = saved;
          setState(() => _sets[lastIndex] = saved);
          _notifySetsChanged();
          try {
            await _sessionSetsService.saveTotalTrainingLoad(
              workoutId,
              updatedSets,
            );
          } catch (error, stackTrace) {
            debugPrint(
              'WorkoutService total load save failed: $error $stackTrace',
            );
          }
          if (mounted) widget.onWorkoutFinished?.call();
        })
        .catchError((Object error, StackTrace stackTrace) {
          debugPrint(
            'WorkoutService finish persist failed: $error $stackTrace',
          );
          if (mounted) widget.onWorkoutFinished?.call();
        });
  }

  Future<void> _persistAndAddSet(String workoutId, int nextNumber) async {
    try {
      final lastIndex = _sets.length - 1;
      final savedLast = await _sessionSetsService.persistSet(
        workoutId,
        _sets[lastIndex],
      );
      if (!mounted) return;
      setState(() => _sets[lastIndex] = savedLast);
      final newRow = await _sessionSetsService.persistSet(
        workoutId,
        Set(setNumber: nextNumber),
      );
      if (!mounted) return;
      setState(() {
        _sets.add(newRow);
        _addingSet = false;
      });
      _notifySetsChanged();
    } catch (error, stackTrace) {
      debugPrint('SessionSetsService add set failed: $error $stackTrace');
      if (mounted) setState(() => _addingSet = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editableRowIndex = _editableRowIndex;
    final primaryButtonEnabled =
        _sessionReady && _lastRowComplete && !_addingSet;

    return SetEntryTableShell(
      children: [
        const SetEntryTableHeader(),
        ..._sets.asMap().entries.map((entry) {
          final isEditable =
              editableRowIndex != null && entry.key == editableRowIndex;
          if (isEditable) {
            return SetEntryEditableRow(
              key: _editableRowKey,
              rowIndex: entry.key,
              entry: entry.value,
              onCommitted: (index, updated) {
                setState(() => _sets[index] = updated);
                _notifySetsChanged();
                _persistSetRow(index, updated);
              },
            );
          }
          return SetEntryReadOnlyRow(
            key: ValueKey('ro_${entry.key}'),
            entry: entry.value,
          );
        }),
        if (!_workoutFinished)
          SetEntryPrimaryActionButton(
            label: _canAddAnotherSet ? 'ADD SET' : 'FINISH WORKOUT',
            enabled: primaryButtonEnabled,
            leadingIcon: _canAddAnotherSet ? Icons.add : Icons.check,
            onPressed: _onPrimaryAction,
          ),
      ],
    );
  }
}
