import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MetricPill extends StatelessWidget {
  final String label;
  final String value;

  const MetricPill({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            color: appTheme.outline,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: appTheme.onSurface,
          ),
        ),
      ],
    );
  }
}

/// Two [MetricPill]s in a row with a vertical divider between them.
class MetricPillPair extends StatelessWidget {
  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;

  const MetricPillPair({
    super.key,
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: MetricPill(label: leftLabel, value: leftValue),
        ),
        Container(
          width: 1,
          height: 32,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          color: appTheme.surfaceContainerHighest,
        ),
        Expanded(
          child: MetricPill(label: rightLabel, value: rightValue),
        ),
      ],
    );
  }
}
