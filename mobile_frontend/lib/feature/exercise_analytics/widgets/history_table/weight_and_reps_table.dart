import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/workout.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/history_table/horizontal_scroll_with_thumb.dart';

const double _dateColWidth = 92;
const double _metricColWidth = 48;

const _monthAbbrev = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Read-only table: one row per past session, columns **Date**, **W1**/**R1** … **WN**/**RN**.
class WeightsAndRepsTable extends StatelessWidget {
  final List<Workout> sessions;

  const WeightsAndRepsTable({super.key, required this.sessions});

  static int _maxSetCount(List<Workout> sessions) {
    var maxSetCount = 0;
    for (final workout in sessions) {
      for (final set in workout.sets) {
        if (set.setNumber > maxSetCount) maxSetCount = set.setNumber;
      }
    }
    return maxSetCount;
  }

  static Set? _setForNumber(Workout workout, int setNumber) {
    for (final set in workout.sets) {
      if (set.setNumber == setNumber) return set;
    }
    return null;
  }

  static String _dateLabel(DateTime date) =>
      '${_monthAbbrev[date.month - 1]} ${date.day}';

  static String _metricText(Set? set, {required bool weight}) {
    if (set == null) return '—';
    if (weight) {
      final value = set.weight;
      if (value == null) return '—';
      return value == value.roundToDouble()
          ? value.toInt().toString()
          : value.toStringAsFixed(1);
    }
    if (set.reps == null) return '—';
    return '${set.reps}';
  }

  static BoxDecoration _frameDecoration(ColorScheme colorScheme) =>
      BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(4),
      );

  static TableRow _headerRow(int maxSetCount, TextStyle style, ColorScheme cs) {
    return TableRow(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [cs.surfaceContainerHigh, cs.surfaceContainerHighest],
        ),
        border: Border(
          bottom: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.35)),
        ),
      ),
      children: [
        _HeaderCell(text: 'DATE', style: style),
        for (var setNumber = 1; setNumber <= maxSetCount; setNumber++) ...[
          _HeaderCell(text: 'W$setNumber', style: style),
          _HeaderCell(text: 'R$setNumber', style: style),
        ],
      ],
    );
  }

  static TableRow _dataRow(
    Workout workout,
    int maxSetCount,
    TextStyle filledStyle,
    TextStyle emptyStyle,
    ColorScheme colorScheme,
  ) {
    TextStyle styleFor(String text) => text == '—' ? emptyStyle : filledStyle;

    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.12),
          ),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            _dateLabel(workout.date),
            style: filledStyle,
            textAlign: TextAlign.center,
          ),
        ),
        for (var setNumber = 1; setNumber <= maxSetCount; setNumber++)
          ..._weightAndRepsCells(
            _setForNumber(workout, setNumber),
            setNumber,
            styleFor,
            colorScheme,
          ),
      ],
    );
  }

  /// W/R pair for one set; odd sets use a tinted band on data rows only.
  static List<_MetricCell> _weightAndRepsCells(
    Set? set,
    int setNumber,
    TextStyle Function(String text) styleFor,
    ColorScheme colorScheme,
  ) {
    final fill = setNumber.isOdd ? colorScheme.surfaceContainerLow : null;
    final weightText = _metricText(set, weight: true);
    final repsText = _metricText(set, weight: false);
    return [
      _MetricCell(text: weightText, style: styleFor(weightText), fill: fill),
      _MetricCell(text: repsText, style: styleFor(repsText), fill: fill),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (sessions.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: _frameDecoration(colorScheme),
        alignment: Alignment.center,
        child: Text(
          'No saved workout history for this exercise yet.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface.withValues(alpha: 0.65),
          ),
        ),
      );
    }

    final maxSetCount = _maxSetCount(sessions);
    final headerStyle = GoogleFonts.inter(
      fontSize: 8,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
      color: colorScheme.onSurface.withValues(alpha: 0.72),
    );
    final cellStyle = GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    );
    final emptyCellStyle = GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: colorScheme.outlineVariant,
    );

    final table = Table(
      columnWidths: {
        0: const FixedColumnWidth(_dateColWidth),
        for (var column = 1; column <= maxSetCount * 2; column++)
          column: const FixedColumnWidth(_metricColWidth),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder(
        verticalInside: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.25),
        ),
      ),
      children: [
        _headerRow(maxSetCount, headerStyle, colorScheme),
        for (final workout in sessions)
          _dataRow(
            workout,
            maxSetCount,
            cellStyle,
            emptyCellStyle,
            colorScheme,
          ),
      ],
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: _frameDecoration(colorScheme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
            child: Text(
              'WORKOUT HISTORY',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: colorScheme.onSurface.withValues(alpha: 0.85),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: HorizontalScrollWithThumb(
              thumbVisibility: maxSetCount > 3,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: table,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _HeaderCell({required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Center(
        child: Text(text, style: style, textAlign: TextAlign.center),
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color? fill;

  const _MetricCell({required this.text, required this.style, this.fill});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: fill,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      alignment: Alignment.center,
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }
}
