import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/use_cases/parse_strength_set_input.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/set_entry_table/set_entry_table_layout.dart';

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

  static String _weightFieldText(double? weight) =>
      StrengthSetInput.weightFieldText(weight);

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
    final parseResult = StrengthSetInput.parse(
      current: widget.entry,
      weightText: _weightController.text,
      repsText: _repsController.text,
    );

    if (parseResult.weightFieldText != _weightController.text.trim()) {
      _weightController.text = parseResult.weightFieldText;
    }
    if (parseResult.repsFieldText != _repsController.text.trim()) {
      _repsController.text = parseResult.repsFieldText;
    }

    if (parseResult.didChangeFrom(widget.entry)) {
      widget.onCommitted(widget.rowIndex, parseResult.updated);
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
