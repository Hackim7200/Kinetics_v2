import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/app/themes/app_theme.dart';
import 'package:mobile_frontend/feature/exercise/models/exercise.dart';


class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback? onTap;

  const ExerciseCard({super.key, required this.exercise, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        color: cs.surfaceContainerLowest,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exercise.summaryText,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: cs.tertiary,
                    ),
                  ),
                ],
              ),
            ),
            _ProgressIndicator(exercise: exercise),
          ],
        ),
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final Exercise exercise;

  const _ProgressIndicator({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final percent = exercise.progressPercent;
    if (percent == null) return const SizedBox.shrink();

    final isRisk = percent >= 10;
    final isStable = percent == 0;
    final isDecrease = percent < 0;
    final color = isRisk
        ? cs.error
        : isDecrease
            ? const Color(0xFF6B7280)
            : isStable
                ? const Color(0xFFF59E0B)
                : AppTheme.success;
    final text = isStable
        ? 'Stable'
        : '${percent >= 0 ? '+' : ''}${percent.toStringAsFixed(1)}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          (exercise.progressLabel ?? '').toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: isRisk
                ? cs.error
                : isDecrease
                    ? const Color(0xFF6B7280)
                    : cs.outline,
          ),
        ),
      ],
    );
  }
}
