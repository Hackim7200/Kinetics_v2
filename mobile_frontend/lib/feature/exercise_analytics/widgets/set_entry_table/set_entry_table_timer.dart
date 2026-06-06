import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/exercise/models/exercise.dart';
import 'package:mobile_frontend/feature/exercise_analytics/data/workout_service.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/set_entry_primary_action_button.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/set_entry_table_header_timer.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/set_entry_table_layout.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/set_entry_timer_read_only_row.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/timer_set_validation.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table_add_time_sheet.dart';

/// Timer session: log each set via bottom-sheet stopwatch; table shows **SET** + **DURATION**.
class SetEntryTableTimer extends ConsumerStatefulWidget {
  final Exercise exercise;
  final void Function(List<Set> sets)? onSetsChanged;
  final VoidCallback? onWorkoutFinished;

  const SetEntryTableTimer({
    super.key,
    required this.exercise,
    this.onSetsChanged,
    this.onWorkoutFinished,
  });

  @override
  ConsumerState<SetEntryTableTimer> createState() => _SetEntryTableTimerState();
}

class _SetEntryTableTimerState extends ConsumerState<SetEntryTableTimer> {
  late List<Set> _sets;
  bool _workoutFinished = false;
  bool _sessionReady = true;
  bool _addingSet = false;
  String? _workoutId;
  int? _maxHoldSecondsLast30Days;
  late final WorkoutService _sessionSetsService;

  int get _maxSets =>
      TrainingTargetInput.clampConfiguredSets(widget.exercise.sets);

  bool get _sessionComplete => timerSessionLooksComplete(_sets, _maxSets);

  bool get _lastRowNeedsDuration =>
      _sets.isNotEmpty && !timerSetHasDuration(_sets.last);

  Duration? get _personalBestDuration {
    int? bestSeconds = _maxHoldSecondsLast30Days;
    final todayMax = maxTimeElapsedInSession(_sets);
    if (todayMax != null &&
        todayMax > 0 &&
        (bestSeconds == null || todayMax > bestSeconds)) {
      bestSeconds = todayMax;
    }
    if (bestSeconds == null || bestSeconds < 1) return null;
    return Duration(seconds: bestSeconds);
  }

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
      _loadPersonalBest(linkId);
    }
  }

  void _notifySetsChanged() => widget.onSetsChanged?.call(_sets);

  Future<void> _loadPersonalBest(String routineExerciseId) async {
    try {
      final maxHold = await _sessionSetsService.maxTimerHoldSecondsLastDays(
        routineExerciseId,
        days: 30,
      );
      if (!mounted) return;
      setState(() => _maxHoldSecondsLast30Days = maxHold);
    } catch (error, stackTrace) {
      debugPrint('Timer personal best load failed: $error $stackTrace');
    }
  }

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
        _workoutFinished = timerSessionLooksComplete(_sets, _maxSets);
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
        first.timeElapsed == null;
  }

  Future<void> _onPrimaryAction() async {
    if (!mounted) return;
    if (!_sessionReady || _workoutFinished || _addingSet) return;

    if (_sessionComplete) {
      _finishWorkout(workoutId: _workoutId);
      return;
    }

    if (!_lastRowNeedsDuration) return;

    final workoutId = _workoutId;
    if (workoutId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Open this exercise from a routine to save timed sets.',
          ),
        ),
      );
      return;
    }

    final setNumber = _sets.last.setNumber;

    setState(() => _addingSet = true);
    final duration = await showTimerAddTimedSetSheet(
      context: context,
      exercise: widget.exercise,
      setNumber: setNumber,
      maxSets: _maxSets,
      personalBestDuration: _personalBestDuration,
    );

    if (!mounted) return;
    if (duration == null || duration.inSeconds < 1) {
      setState(() => _addingSet = false);
      return;
    }

    final index = _sets.length - 1;
    final entry = _sets[index].copyWith(timeElapsed: duration.inSeconds);

    try {
      final saved = await _sessionSetsService.persistSet(workoutId, entry);
      if (!mounted) return;

      if (setNumber < _maxSets) {
        final nextNumber = setNumber + 1;
        final newRow = await _sessionSetsService.persistSet(
          workoutId,
          Set(setNumber: nextNumber),
        );
        if (!mounted) return;
        setState(() {
          _sets[index] = saved;
          _sets.add(newRow);
          _addingSet = false;
        });
      } else {
        setState(() {
          _sets[index] = saved;
          _addingSet = false;
        });
      }
      _notifySetsChanged();
    } catch (error, stackTrace) {
      debugPrint('Timer persist failed: $error $stackTrace');
      if (mounted) setState(() => _addingSet = false);
    }
  }

  void _finishWorkout({String? workoutId}) {
    setState(() => _workoutFinished = true);

    if (workoutId == null) {
      widget.onWorkoutFinished?.call();
      return;
    }

    _sessionSetsService
        .saveTotalTrainingLoad(workoutId, _sets)
        .then((_) {
          if (mounted) widget.onWorkoutFinished?.call();
        })
        .catchError((Object error, StackTrace stackTrace) {
          debugPrint('WorkoutService total save failed: $error $stackTrace');
          if (mounted) widget.onWorkoutFinished?.call();
        });
  }

  bool get _primaryButtonEnabled {
    if (!_sessionReady || _workoutFinished || _addingSet) return false;
    if (_sessionComplete) return true;
    return _lastRowNeedsDuration;
  }

  @override
  Widget build(BuildContext context) {
    return SetEntryTableShell(
      children: [
        const SetEntryTableHeaderTimer(),
        ..._sets.asMap().entries.map(
          (entry) => SetEntryTimerReadOnlyRow(
            key: ValueKey('timer_${entry.key}_${entry.value.setNumber}'),
            entry: entry.value,
          ),
        ),
        if (!_workoutFinished)
          SetEntryPrimaryActionButton(
            label: _sessionComplete ? 'FINISH WORKOUT' : 'LOG SET',
            enabled: _primaryButtonEnabled,
            leadingIcon: _sessionComplete ? Icons.check : Icons.timer_outlined,
            onPressed: _onPrimaryAction,
          ),
      ],
    );
  }
}
