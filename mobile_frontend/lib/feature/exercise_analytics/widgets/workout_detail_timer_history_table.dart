import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/workout_log.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/horizontal_scroll_with_thumb.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/timer_add_timed_set_sheet.dart';

const double _timerDateColWidth = 92;
const double _timerDurColWidth = 56;

/// Past timer sessions: **Date** and **D1**…**DN** (duration `mm:ss`).
class WorkoutDetailTimerHistoryTable extends StatelessWidget {
  final List<WorkoutLog> sessions;

  const WorkoutDetailTimerHistoryTable({super.key, required this.sessions});

  static int _maxSetNumberAcross(List<WorkoutLog> sessions) {
    var maxN = 0;
    for (final w in sessions) {
      for (final s in w.sets) {
        if (s.setNumber > maxN) maxN = s.setNumber;
      }
    }
    return maxN;
  }

  static SetEntry? _setForNumber(WorkoutLog w, int n) {
    for (final s in w.sets) {
      if (s.setNumber == n) return s;
    }
    return null;
  }

  static String _durationCell(SetEntry? e) {
    final d = e?.timeElapsed;
    if (d == null || d <= 0) return '—';
    return formatTimerMinutesSeconds(Duration(seconds: d));
  }

  static String _dateLabel(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final maxN = _maxSetNumberAcross(sessions);

    if (sessions.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          'No saved workout history for this exercise yet.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: cs.onSurface.withValues(alpha: 0.65),
          ),
        ),
      );
    }

    final columnWidths = <int, TableColumnWidth>{
      0: const FixedColumnWidth(_timerDateColWidth),
    };
    for (var c = 0; c < maxN; c++) {
      columnWidths[c + 1] = const FixedColumnWidth(_timerDurColWidth);
    }

    final headerStyle = GoogleFonts.inter(
      fontSize: 8,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
      color: cs.onSurface.withValues(alpha: 0.72),
    );
    final cellStyle = GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: cs.onSurface,
    );
    final emptyCellStyle = GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: cs.outlineVariant,
    );

    Color? bandColor(int setNumber) =>
        setNumber.isOdd ? cs.surfaceContainerLow : null;

    TableRow headerRow() {
      final cells = <Widget>[
        _HeaderCell(text: 'DATE', style: headerStyle),
      ];
      for (var n = 1; n <= maxN; n++) {
        cells.add(_HeaderCell(text: 'D$n', style: headerStyle));
      }
      return TableRow(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [cs.surfaceContainerHigh, cs.surfaceContainerHighest],
          ),
          border: Border(
            bottom: BorderSide(
              color: cs.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
        ),
        children: cells,
      );
    }

    TableRow dataRow(WorkoutLog w) {
      final cells = <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            _dateLabel(w.date),
            style: cellStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ];
      for (var n = 1; n <= maxN; n++) {
        final e = _setForNumber(w, n);
        final text = _durationCell(e);
        final fill = bandColor(n);
        cells.add(
          _MetricCell(
            text: text,
            style: text == '—' ? emptyCellStyle : cellStyle,
            fill: fill,
          ),
        );
      }
      return TableRow(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: cs.outlineVariant.withValues(alpha: 0.12),
            ),
          ),
        ),
        children: cells,
      );
    }

    final table = Table(
      columnWidths: columnWidths,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder(
        verticalInside: BorderSide(
          color: cs.outlineVariant.withValues(alpha: 0.25),
        ),
      ),
      children: [headerRow(), ...sessions.map(dataRow)],
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
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
                color: cs.onSurface.withValues(alpha: 0.85),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: HorizontalScrollWithThumb(
              thumbVisibility: maxN > 4,
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
