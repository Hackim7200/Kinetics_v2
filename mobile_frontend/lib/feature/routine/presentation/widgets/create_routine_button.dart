import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateRoutineButton extends StatelessWidget {
  final VoidCallback? onTap;

  const CreateRoutineButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 240),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 32, color: colorScheme.outlineVariant),
            const SizedBox(height: 16),
            Text(
              'CREATE NEW ROUTINE',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
                color: colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
