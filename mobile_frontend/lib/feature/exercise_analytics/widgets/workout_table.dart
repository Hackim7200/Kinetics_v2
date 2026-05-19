import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/workout_log.dart';

const double _setColWidth = 48;

/// Strength set grid: only the row at [editableRowIndex] is editable; rows above are read-only
/// after the user taps **ADD SET**. [IntrinsicHeight] avoids unbounded height in a [ListView].
class SessionLogTable extends StatefulWidget {
  final List<SetEntry> sets;
  final int? editableRowIndex;
  final bool workoutFinished;
  final int maxSets;
  final void Function(int index, SetEntry updated) onSetCommitted;
  final bool primaryButtonEnabled;
  final VoidCallback? onPrimaryAction;

  const SessionLogTable({
    super.key,
    required this.sets,
    required this.editableRowIndex,
    required this.workoutFinished,
    required this.maxSets,
    required this.onSetCommitted,
    required this.primaryButtonEnabled,
    this.onPrimaryAction,
  });

  @override
  State<SessionLogTable> createState() => SessionLogTableState();
}

class SessionLogTableState extends State<SessionLogTable> {
  final GlobalKey<_EditableLogSetRowState> _editableRowKey = GlobalKey();

  /// Pushes the active row text fields into [onSetCommitted] before ADD SET / FINISH checks.
  void commitPendingEdits() {
    _editableRowKey.currentState?.flushToParent();
  }

  String get _primaryLabel =>
      widget.sets.length < widget.maxSets ? 'ADD SET' : 'FINISH WORKOUT';

  bool get _showPrimaryButton =>
      !widget.workoutFinished && widget.onPrimaryAction != null;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sets = widget.sets;
    final editableRowIndex = widget.editableRowIndex;
    final onSetCommitted = widget.onSetCommitted;
    final primaryButtonEnabled = widget.primaryButtonEnabled;
    final onPrimaryAction = widget.onPrimaryAction;
    final maxSets = widget.maxSets;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          // Darker header band so column titles separate from body rows.
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [cs.surfaceContainerHigh, cs.surfaceContainerHighest],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
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
                    width: _setColWidth,
                    child: Center(
                      child: Text('SET', style: _columnHeaderStyle(cs)),
                    ),
                  ),
                  _ColumnSeparator(colorScheme: cs),
                  Expanded(
                    child: Center(
                      child: Text(
                        'WEIGHT',
                        style: _columnHeaderStyle(cs),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  _ColumnSeparator(colorScheme: cs),
                  Expanded(
                    child: Center(
                      child: Text(
                        'REPS',
                        style: _columnHeaderStyle(cs),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          ...sets.asMap().entries.map((e) {
            final editable =
                editableRowIndex != null && e.key == editableRowIndex;
            if (editable) {
              return _EditableLogSetRow(
                key: _editableRowKey,
                rowIndex: e.key,
                entry: e.value,
                onCommitted: onSetCommitted,
              );
            }
            return _ReadOnlyLogSetRow(
              // Index (not setNumber) so duplicate set indices in the list cannot clash.
              key: ValueKey('ro_${e.key}'),
              entry: e.value,
            );
          }),

          // ADD SET / FINISH WORKOUT; hidden when workoutFinished is true.
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
                          sets.length < maxSets ? Icons.add : Icons.check,
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

class _ReadOnlyLogSetRow extends StatelessWidget {
  final SetEntry entry;

  const _ReadOnlyLogSetRow({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasW = entry.weight != null;
    final hasR = entry.reps != null;

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
              width: _setColWidth,
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
                  hasW ? entry.weight!.toInt().toString() : '--',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: hasW ? cs.onSurface : cs.outlineVariant,
                  ),
                ),
              ),
            ),
            _ColumnSeparator(colorScheme: cs),
            Expanded(
              child: Center(
                child: Text(
                  hasR ? entry.reps.toString() : '--',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: hasR ? cs.onSurface : cs.outlineVariant,
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

class _EditableLogSetRow extends StatefulWidget {
  final int rowIndex;
  final SetEntry entry;
  final void Function(int index, SetEntry updated) onCommitted;

  const _EditableLogSetRow({
    super.key,
    required this.rowIndex,
    required this.entry,
    required this.onCommitted,
  });

  @override
  State<_EditableLogSetRow> createState() => _EditableLogSetRowState();
}

class _EditableLogSetRowState extends State<_EditableLogSetRow> {
  late final TextEditingController _weightCtrl;
  late final TextEditingController _repsCtrl;
  late final FocusNode _weightFocus;
  late final FocusNode _repsFocus;

  static String _weightFieldText(double? w) {
    if (w == null) return '';
    if (w == w.roundToDouble()) return w.toInt().toString();
    return w.toStringAsFixed(1);
  }

  @override
  void initState() {
    super.initState();
    _weightCtrl = TextEditingController(
      text: _weightFieldText(widget.entry.weight),
    );
    _repsCtrl = TextEditingController(
      text: widget.entry.reps != null ? '${widget.entry.reps}' : '',
    );
    _weightFocus = FocusNode();
    _repsFocus = FocusNode();
    _weightFocus.addListener(_onWeightFocusChange);
    _repsFocus.addListener(_onRepsFocusChange);
  }

  @override
  void didUpdateWidget(covariant _EditableLogSetRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entry.setNumber != widget.entry.setNumber) {
      _weightCtrl.text = _weightFieldText(widget.entry.weight);
      _repsCtrl.text = widget.entry.reps != null ? '${widget.entry.reps}' : '';
      return;
    }
    if (!_weightFocus.hasFocus &&
        oldWidget.entry.weight != widget.entry.weight) {
      _weightCtrl.text = _weightFieldText(widget.entry.weight);
    }
    if (!_repsFocus.hasFocus && oldWidget.entry.reps != widget.entry.reps) {
      _repsCtrl.text = widget.entry.reps != null ? '${widget.entry.reps}' : '';
    }
  }

  @override
  void dispose() {
    _weightFocus.removeListener(_onWeightFocusChange);
    _repsFocus.removeListener(_onRepsFocusChange);
    _weightFocus.dispose();
    _repsFocus.dispose();
    _weightCtrl.dispose();
    _repsCtrl.dispose();
    super.dispose();
  }

  void _onWeightFocusChange() {
    if (!_weightFocus.hasFocus) _commit();
  }

  void _onRepsFocusChange() {
    if (!_repsFocus.hasFocus) _commit();
  }

  /// Called before ADD SET / FINISH so controller text is merged into parent state.
  void flushToParent() => _commit();

  /// Writes parsed cells to parent so ADD SET / FINISH enables without an extra blur.
  void _commit() {
    final wText = _weightCtrl.text.trim();
    final rText = _repsCtrl.text.trim();

    double? w;
    if (wText.isEmpty) {
      w = null;
    } else {
      final parsed = double.tryParse(wText);
      if (parsed == null || parsed <= 0 || parsed > 999.5) {
        _weightCtrl.text = _weightFieldText(widget.entry.weight);
        w = widget.entry.weight;
      } else {
        w = parsed;
      }
    }

    int? r;
    if (rText.isEmpty) {
      r = null;
    } else {
      final parsed = int.tryParse(rText);
      if (parsed == null ||
          parsed < TrainingTargetInput.minReps ||
          parsed > TrainingTargetInput.maxReps) {
        _repsCtrl.text = widget.entry.reps != null
            ? '${widget.entry.reps}'
            : '';
        r = widget.entry.reps;
      } else {
        r = parsed;
      }
    }

    final load = trainingLoadForStrengthSet(w, r);
    final updated = widget.entry.copyWith(
      weight: w,
      reps: r,
      isCompleted: load != null,
      trainingLoad: load,
    );

    if (updated.weight != widget.entry.weight ||
        updated.reps != widget.entry.reps ||
        updated.isCompleted != widget.entry.isCompleted ||
        updated.trainingLoad != widget.entry.trainingLoad) {
      widget.onCommitted(widget.rowIndex, updated);
    }
  }

  InputDecoration _cellDecoration(ColorScheme cs) {
    return InputDecoration(
      isDense: true,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      hintText: '--',
      hintStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: cs.outlineVariant,
      ),
    );
  }

  TextStyle _cellTextStyle(ColorScheme cs, {required bool hasValue}) {
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: hasValue ? cs.onSurface : cs.outlineVariant,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
              width: _setColWidth,
              child: Center(
                child: Text(
                  widget.entry.setNumber.toString().padLeft(2, '0'),
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
                child: TextField(
                  controller: _weightCtrl,
                  focusNode: _weightFocus,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d{0,3}\.?\d{0,2}'),
                    ),
                  ],
                  decoration: _cellDecoration(cs),
                  style: _cellTextStyle(
                    cs,
                    hasValue: _weightCtrl.text.isNotEmpty,
                  ),
                  onSubmitted: (_) => _repsFocus.requestFocus(),
                  onChanged: (_) {
                    setState(() {});
                    _commit();
                  },
                ),
              ),
            ),
            _ColumnSeparator(colorScheme: cs),
            Expanded(
              child: Center(
                child: TextField(
                  controller: _repsCtrl,
                  focusNode: _repsFocus,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.done,
                  inputFormatters: TrainingTargetInput.repsFieldFormatters,
                  decoration: _cellDecoration(cs),
                  style: _cellTextStyle(
                    cs,
                    hasValue: _repsCtrl.text.isNotEmpty,
                  ),
                  onSubmitted: (_) {
                    _repsFocus.unfocus();
                    _commit();
                  },
                  onChanged: (_) {
                    setState(() {});
                    _commit();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
