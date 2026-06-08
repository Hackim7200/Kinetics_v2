import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Small-caps section label used above form fields and option rows.
class ExerciseFormSectionLabel extends StatelessWidget {
  final String label;

  const ExerciseFormSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
        color: cs.tertiary,
      ),
    );
  }
}

/// Labeled underline text field for add/edit exercise forms.
class ExerciseFormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const ExerciseFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExerciseFormSectionLabel(label: label),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: cs.outlineVariant,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: cs.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.only(bottom: 12),
          ),
        ),
      ],
    );
  }
}

/// Tappable underline option (e.g. Strength / Timer, Increase / Decrease).
class ExerciseFormOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ExerciseFormOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected
                    ? cs.primary
                    : cs.outlineVariant.withValues(alpha: 0.3),
                width: selected ? 2 : 1,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Center(
              child: Text(
                label.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: selected ? cs.onSurface : cs.outline,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Strength vs timer picker on the add-exercise form.
class ExerciseTypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeChanged;

  const ExerciseTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ExerciseFormSectionLabel(label: 'TYPE'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ExerciseFormOption(
                label: 'Strength',
                selected: selectedType == 'strength',
                onTap: () => onTypeChanged('strength'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ExerciseFormOption(
                label: 'Timer',
                selected: selectedType == 'timer',
                onTap: () => onTypeChanged('timer'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Read-only exercise type on the edit-exercise form (type cannot be changed).
class ExerciseTypeDisplay extends StatelessWidget {
  final String type;

  const ExerciseTypeDisplay({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final label = type == 'timer' ? 'TIMER' : 'STRENGTH';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ExerciseFormSectionLabel(label: 'TYPE'),
        const SizedBox(height: 12),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: cs.primary, width: 2)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: cs.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
