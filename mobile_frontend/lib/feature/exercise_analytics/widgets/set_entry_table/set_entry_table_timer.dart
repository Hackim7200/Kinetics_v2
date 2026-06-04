import 'package:flutter/material.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/set_entry_primary_action_button.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/set_entry_table_header_timer.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/set_entry_table_layout.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/set_entry_timer_read_only_row.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/timer_set_validation.dart';

/// Timer session grid: read-only rows (**SET**, **DURATION**).
///
/// Primary action is owned by the parent ([onPrimaryAction]) — typically opens
/// the add-time bottom sheet.
class SetEntryTableTimer extends StatelessWidget {
  final List<Set> sets;
  final bool workoutFinished;
  final int maxSets;
  final bool primaryButtonEnabled;
  final VoidCallback? onPrimaryAction;

  const SetEntryTableTimer({
    super.key,
    required this.sets,
    required this.workoutFinished,
    required this.maxSets,
    required this.primaryButtonEnabled,
    this.onPrimaryAction,
  });

  bool get _sessionComplete => timerSessionLooksComplete(sets, maxSets);

  String get _primaryLabel => _sessionComplete ? 'FINISH WORKOUT' : 'LOG SET';

  IconData get _primaryIcon =>
      _sessionComplete ? Icons.check : Icons.timer_outlined;

  @override
  Widget build(BuildContext context) {
    final showPrimaryButton = !workoutFinished && onPrimaryAction != null;

    return SetEntryTableShell(
      children: [
        const SetEntryTableHeaderTimer(),
        ...sets.asMap().entries.map(
          (entry) => SetEntryTimerReadOnlyRow(
            key: ValueKey('timer_${entry.key}_${entry.value.setNumber}'),
            entry: entry.value,
          ),
        ),
        if (showPrimaryButton)
          SetEntryPrimaryActionButton(
            label: _primaryLabel,
            enabled: primaryButtonEnabled,
            leadingIcon: _primaryIcon,
            onPressed: onPrimaryAction,
          ),
      ],
    );
  }
}
