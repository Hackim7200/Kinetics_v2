import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Eyebrow label, large title, and a metrics section (pills / rows).
class DetailHeroHeader extends StatelessWidget {
  final String eyebrowLabel;
  final String title;
  final Widget metrics;

  const DetailHeroHeader({
    super.key,
    required this.eyebrowLabel,
    required this.title,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrowLabel,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
            color: cs.tertiary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            letterSpacing: -2,
            height: 1.0,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        metrics,
      ],
    );
  }
}
