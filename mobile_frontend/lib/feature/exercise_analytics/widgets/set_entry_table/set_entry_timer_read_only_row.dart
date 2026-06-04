import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/set_entry_table_layout.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/timer_set_validation.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table_add_time_sheet.dart';

/// Locked timer row — displays set number and logged duration.
class SetEntryTimerReadOnlyRow extends StatelessWidget {
  final Set entry;

  const SetEntryTimerReadOnlyRow({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasDuration = timerSetHasDuration(entry);
    final durationText = hasDuration
        ? formatTimerMinutesSeconds(Duration(seconds: entry.timeElapsed!))
        : '—';
    final valueStyle = GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w700,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: setEntrySetColumnWidth,
              child: Center(
                child: Text(
                  entry.setNumber.toString().padLeft(2, '0'),
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            SetEntryColumnSeparator(colorScheme: colorScheme),
            Expanded(
              child: Center(
                child: Text(
                  durationText,
                  textAlign: TextAlign.center,
                  style: valueStyle.copyWith(
                    color: hasDuration
                        ? colorScheme.onSurface
                        : colorScheme.outlineVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
