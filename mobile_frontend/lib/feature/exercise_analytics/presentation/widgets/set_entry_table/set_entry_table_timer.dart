import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/exercise.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/set_entry_table/set_entry_primary_action_button.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/set_entry_table/set_entry_table_header_timer.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/set_entry_table/set_entry_table_layout.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/set_entry_table/set_entry_timer_read_only_row.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/set_entry_table_add_time_sheet.dart';
import 'package:mobile_frontend/feature/exercise_analytics/state/timer_session_notifier.dart';

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
  int get _maxSets =>
      TrainingTargetInput.clampConfiguredSets(widget.exercise.sets);

  late final _provider = timerSessionProvider(
    widget.exercise.routineExerciseId,
    _maxSets,
  );

  Future<void> _onPrimaryAction() async {
    if (!mounted) return;
    final sessionState = ref.read(_provider);
    final notifier = ref.read(_provider.notifier);

    if (!sessionState.sessionReady ||
        sessionState.workoutFinished ||
        sessionState.addingSet) {
      return;
    }

    if (sessionState.sessionComplete) {
      await notifier.finish();
      return;
    }

    if (!sessionState.lastRowNeedsDuration) return;

    final setNumber = sessionState.sets.last.setNumber;
    notifier.setAddingSet(true);

    final duration = await showTimerAddTimedSetSheet(
      context: context,
      exercise: widget.exercise,
      setNumber: setNumber,
      maxSets: _maxSets,
      personalBestDuration: sessionState.personalBestDuration,
    );

    if (!mounted) return;
    if (duration == null) {
      notifier.setAddingSet(false);
      return;
    }

    await notifier.logSet(duration.inSeconds);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(_provider, (previous, next) {
      if (previous == null || !identical(previous.sets, next.sets)) {
        widget.onSetsChanged?.call(next.sets);
      }
      if (previous != null &&
          !previous.workoutFinished &&
          next.workoutFinished) {
        widget.onWorkoutFinished?.call();
      }
    });

    final sessionState = ref.watch(_provider);

    return SetEntryTableShell(
      children: [
        const SetEntryTableHeaderTimer(),
        ...sessionState.sets.asMap().entries.map(
          (entry) => SetEntryTimerReadOnlyRow(
            key: ValueKey('timer_${entry.key}_${entry.value.setNumber}'),
            entry: entry.value,
          ),
        ),
        if (!sessionState.workoutFinished)
          SetEntryPrimaryActionButton(
            label: sessionState.primaryButtonLabel,
            enabled: sessionState.primaryButtonEnabled,
            leadingIcon: sessionState.sessionComplete
                ? Icons.check
                : Icons.timer_outlined,
            onPressed: _onPrimaryAction,
          ),
      ],
    );
  }
}
