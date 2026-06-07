import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Footer action row (ADD SET / LOG SET / FINISH WORKOUT).
class SetEntryPrimaryActionButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final IconData leadingIcon;
  final VoidCallback? onPressed;

  const SetEntryPrimaryActionButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.leadingIcon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        child: Opacity(
          opacity: enabled ? 1 : 0.4,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  leadingIcon,
                  size: 16,
                  color: colorScheme.onSurface,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
