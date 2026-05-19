import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/feature/workout/models/workout_log.dart';
import 'package:mobile_frontend/feature/workout/widgets/timer_add_timed_set_sheet.dart';

const double _timerSetColWidth = 48;

bool timerSetHasDuration(SetEntry s) =>
    s.durationSeconds != null && s.durationSeconds! > 0;

/// Each index `1..maxSets` has exactly one row with a logged duration.
bool timerSessionLooksComplete(List<SetEntry> sets, int maxSets) {
  for (var n = 1; n <= maxSets; n++) {
    final forN = sets.where((s) => s.setNumber == n).toList();
    if (forN.length != 1) return false;
    if (!timerSetHasDuration(forN.single)) return false;
  }
  return true;
}

/// Timer session grid: read-only rows (**SET**, **DURATION**). Primary action is
/// provided by parent ([onPrimaryAction]) — typically opens [showTimerAddTimedSetSheet].
class TimerSessionLogTable extends StatelessWidget {
  final List<SetEntry> sets;
  final bool workoutFinished;
  final int maxSets;
  final bool primaryButtonEnabled;
  final VoidCallback? onPrimaryAction;

  const TimerSessionLogTable({
    super.key,
    required this.sets,
    required this.workoutFinished,
    required this.maxSets,
    required this.primaryButtonEnabled,
    this.onPrimaryAction,
  });

  String get _primaryLabel {
    final allDone = timerSessionLooksComplete(sets, maxSets);
    if (allDone) return 'FINISH WORKOUT';
    return 'LOG SET';
  }

  bool get _showPrimaryButton =>
      !workoutFinished && onPrimaryAction != null;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [cs.surfaceContainerHigh, cs.surfaceContainerHighest],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              border: Border(
                bottom: BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.35),
                ),
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: _timerSetColWidth,
                    child: Center(
                      child: Text(
                        'SET',
                        style: _columnHeaderStyle(cs),
                      ),
                    ),
                  ),
                  _ColumnSeparator(colorScheme: cs),
                  Expanded(
                    child: Center(
                      child: Text(
                        'DURATION',
                        style: _columnHeaderStyle(cs),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ...sets.asMap().entries.map(
                (e) => _TimerLogSetRow(
                  key: ValueKey('timer_${e.key}_${e.value.setNumber}'),
                  entry: e.value,
                ),
              ),
          if (_showPrimaryButton)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: primaryButtonEnabled ? onPrimaryAction : null,
                child: Opacity(
                  opacity: primaryButtonEnabled ? 1 : 0.4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: cs.outlineVariant.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          sets.isNotEmpty &&
                                  timerSessionLooksComplete(sets, maxSets)
                              ? Icons.check
                              : Icons.timer_outlined,
                          size: 16,
                          color: cs.onSurface,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _primaryLabel,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: cs.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  TextStyle _columnHeaderStyle(ColorScheme cs) {
    return GoogleFonts.inter(
      fontSize: 9,
      fontWeight: FontWeight.w700,
      letterSpacing: 2,
      color: cs.onSurface.withValues(alpha: 0.72),
    );
  }
}

class _ColumnSeparator extends StatelessWidget {
  final ColorScheme colorScheme;

  const _ColumnSeparator({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      color: colorScheme.outlineVariant.withValues(alpha: 0.45),
    );
  }
}

class _TimerLogSetRow extends StatelessWidget {
  final SetEntry entry;

  const _TimerLogSetRow({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final d = entry.durationSeconds;
    final hasD = d != null && d > 0;
    final text = hasD
        ? formatTimerMinutesSeconds(Duration(seconds: d))
        : '—';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.1)),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: _timerSetColWidth,
              child: Center(
                child: Text(
                  entry.setNumber.toString().padLeft(2, '0'),
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ),
            _ColumnSeparator(colorScheme: cs),
            Expanded(
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: hasD ? cs.onSurface : cs.outlineVariant,
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
