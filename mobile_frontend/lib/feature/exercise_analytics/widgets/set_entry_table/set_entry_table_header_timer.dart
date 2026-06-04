import 'package:flutter/material.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/set_entry_table_layout.dart';

/// Column titles: SET | DURATION.
class SetEntryTableHeaderTimer extends StatelessWidget {
  const SetEntryTableHeaderTimer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final headerStyle = setEntryColumnHeaderStyle(colorScheme);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surfaceContainerHigh,
            colorScheme.surfaceContainerHighest,
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: setEntrySetColumnWidth,
              child: Center(child: Text('SET', style: headerStyle)),
            ),
            SetEntryColumnSeparator(colorScheme: colorScheme),
            Expanded(
              child: Center(
                child: Text(
                  'DURATION',
                  style: headerStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
