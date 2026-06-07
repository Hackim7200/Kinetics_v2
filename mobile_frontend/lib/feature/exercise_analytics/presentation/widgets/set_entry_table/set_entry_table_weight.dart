import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/feature/exercise/models/exercise.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/set_entry_table/set_entry_editable_row.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/set_entry_table/set_entry_primary_action_button.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/set_entry_table/set_entry_read_only_row.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/set_entry_table/set_entry_table_header.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/set_entry_table/set_entry_table_layout.dart';
import 'package:mobile_frontend/feature/exercise_analytics/state/strength_session_notifier.dart';

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

  int get _maxSets =>
      TrainingTargetInput.clampConfiguredSets(widget.exercise.sets);

  late final _provider = strengthSessionProvider(
    widget.exercise.routineExerciseId,
    _maxSets,
  );

  void _onPrimaryAction() {
    _editableRowKey.currentState?.flushToParent();
    FocusScope.of(context).unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final sessionState = ref.read(_provider);
      if (!sessionState.lastRowComplete) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enter weight and reps for this set first.'),
          ),
        );
        return;
      }
      if (sessionState.canAddAnotherSet) {
        if (sessionState.addingSet) return;
        ref.read(_provider.notifier).addNextSet();
      } else {
        ref.read(_provider.notifier).finish();
      }
    });
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
    final editableRowIndex = sessionState.editableRowIndex;

    return SetEntryTableShell(
      children: [
        const SetEntryTableHeader(),
        ...sessionState.sets.asMap().entries.map((entry) {
          final isEditable =
              editableRowIndex != null && entry.key == editableRowIndex;
          if (isEditable) {
            return SetEntryEditableRow(
              key: _editableRowKey,
              rowIndex: entry.key,
              entry: entry.value,
              onCommitted: (index, updated) {
                ref.read(_provider.notifier).commitRow(index, updated);
              },
            );
          }
          return SetEntryReadOnlyRow(
            key: ValueKey('ro_${entry.key}'),
            entry: entry.value,
          );
        }),
        if (!sessionState.workoutFinished)
          SetEntryPrimaryActionButton(
            label: sessionState.primaryButtonLabel,
            enabled: sessionState.primaryButtonEnabled,
            leadingIcon: sessionState.canAddAnotherSet ? Icons.add : Icons.check,
            onPressed: _onPrimaryAction,
          ),
      ],
    );
  }
}
