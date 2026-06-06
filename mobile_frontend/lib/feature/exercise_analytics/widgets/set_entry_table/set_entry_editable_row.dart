import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/set_entry_table_layout.dart';

/// Latest row only — weight/reps fields commit on blur or before primary action.
class SetEntryEditableRow extends StatefulWidget {
  final int rowIndex;
  final Set entry;
  final void Function(int index, Set updated) onCommitted;

  const SetEntryEditableRow({
    super.key,
    required this.rowIndex,
    required this.entry,
    required this.onCommitted,
  });

  @override
  State<SetEntryEditableRow> createState() => SetEntryEditableRowState();
}

class SetEntryEditableRowState extends State<SetEntryEditableRow> {
  late final TextEditingController _weightController;
  late final TextEditingController _repsController;
  late final FocusNode _weightFocus;
  late final FocusNode _repsFocus;

  static String _weightFieldText(double? weight) {
    if (weight == null) return '';
    if (weight == weight.roundToDouble()) return weight.toInt().toString();
    return weight.toStringAsFixed(1);
  }

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(
      text: _weightFieldText(widget.entry.weight),
    );
    _repsController = TextEditingController(
      text: widget.entry.reps != null ? '${widget.entry.reps}' : '',
    );
    _weightFocus = FocusNode()..addListener(_onWeightFocusChange);
    _repsFocus = FocusNode()..addListener(_onRepsFocusChange);
  }

  @override
  void didUpdateWidget(covariant SetEntryEditableRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entry.setNumber != widget.entry.setNumber) {
      _weightController.text = _weightFieldText(widget.entry.weight);
      _repsController.text = widget.entry.reps != null
          ? '${widget.entry.reps}'
          : '';
      return;
    }
    if (!_weightFocus.hasFocus &&
        oldWidget.entry.weight != widget.entry.weight) {
      _weightController.text = _weightFieldText(widget.entry.weight);
    }
    if (!_repsFocus.hasFocus && oldWidget.entry.reps != widget.entry.reps) {
      _repsController.text = widget.entry.reps != null
          ? '${widget.entry.reps}'
          : '';
    }
  }

  @override
  void dispose() {
    _weightFocus.removeListener(_onWeightFocusChange);
    _repsFocus.removeListener(_onRepsFocusChange);
    _weightFocus.dispose();
    _repsFocus.dispose();
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _onWeightFocusChange() {
    if (!_weightFocus.hasFocus) _commit();
  }

  void _onRepsFocusChange() {
    if (!_repsFocus.hasFocus) _commit();
  }

  /// Merges controller text into parent before **ADD SET** / **FINISH WORKOUT**.
  void flushToParent() => _commit();

  void _commit() {
    final weightText = _weightController.text.trim();
    final repsText = _repsController.text.trim();

    double? weight;
    if (weightText.isEmpty) {
      weight = null;
    } else {
      final parsed = double.tryParse(weightText);
      if (parsed == null || parsed <= 0 || parsed > 999.5) {
        _weightController.text = _weightFieldText(widget.entry.weight);
        weight = widget.entry.weight;
      } else {
        weight = parsed;
      }
    }

    int? reps;
    if (repsText.isEmpty) {
      reps = null;
    } else {
      final parsed = int.tryParse(repsText);
      if (parsed == null ||
          parsed < TrainingTargetInput.minReps ||
          parsed > TrainingTargetInput.maxReps) {
        _repsController.text = widget.entry.reps != null
            ? '${widget.entry.reps}'
            : '';
        reps = widget.entry.reps;
      } else {
        reps = parsed;
      }
    }

    final load = trainingLoadForSet(weight: weight, reps: reps);
    final updated = widget.entry.copyWith(
      weight: weight,
      reps: reps,
      trainingLoad: load,
    );

    if (updated.weight != widget.entry.weight ||
        updated.reps != widget.entry.reps ||
        updated.isLogged != widget.entry.isLogged ||
        updated.trainingLoad != widget.entry.trainingLoad) {
      widget.onCommitted(widget.rowIndex, updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                  widget.entry.setNumber.toString().padLeft(2, '0'),
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
                child: TextField(
                  controller: _weightController,
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
                  decoration: _cellDecoration(colorScheme),
                  style: _cellTextStyle(
                    colorScheme,
                    hasValue: _weightController.text.isNotEmpty,
                  ),
                  onSubmitted: (_) => _repsFocus.requestFocus(),
                  onChanged: (_) {
                    setState(() {});
                    _commit();
                  },
                ),
              ),
            ),
            SetEntryColumnSeparator(colorScheme: colorScheme),
            Expanded(
              child: Center(
                child: TextField(
                  controller: _repsController,
                  focusNode: _repsFocus,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.done,
                  inputFormatters: TrainingTargetInput.repsFieldFormatters,
                  decoration: _cellDecoration(colorScheme),
                  style: _cellTextStyle(
                    colorScheme,
                    hasValue: _repsController.text.isNotEmpty,
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

  InputDecoration _cellDecoration(ColorScheme colorScheme) {
    return InputDecoration(
      isDense: true,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      hintText: '--',
      hintStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: colorScheme.outlineVariant,
      ),
    );
  }

  TextStyle _cellTextStyle(ColorScheme colorScheme, {required bool hasValue}) {
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: hasValue ? colorScheme.onSurface : colorScheme.outlineVariant,
    );
  }
}
