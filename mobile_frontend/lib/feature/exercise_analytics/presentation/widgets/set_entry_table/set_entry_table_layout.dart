import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fixed width for the SET column (matches read-only and editable rows).
const double setEntrySetColumnWidth = 48;

TextStyle setEntryColumnHeaderStyle(ColorScheme colorScheme) {
  return GoogleFonts.inter(
    fontSize: 9,
    fontWeight: FontWeight.w700,
    letterSpacing: 2,
    color: colorScheme.onSurface.withValues(alpha: 0.72),
  );
}

/// Shared bordered container for strength and timer set-entry tables.
class SetEntryTableShell extends StatelessWidget {
  final List<Widget> children;

  const SetEntryTableShell({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(children: children),
    );
  }
}

/// Vertical divider between SET / WEIGHT / REPS columns.
class SetEntryColumnSeparator extends StatelessWidget {
  final ColorScheme colorScheme;

  const SetEntryColumnSeparator({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      color: colorScheme.outlineVariant.withValues(alpha: 0.45),
    );
  }
}
