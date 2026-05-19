import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/feature/exercise/models/exercise.dart';

class ExerciseTypeSelector extends StatelessWidget {
  final ExerciseType selectedType;
  final ValueChanged<ExerciseType> onChanged;

  const ExerciseTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ExerciseType.values.map((type) {
        final isSelected = type == selectedType;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: type == ExerciseType.strength ? 8 : 0,
              left: type == ExerciseType.timer ? 8 : 0,
            ),
            child: _TypeChip(
              label: type == ExerciseType.strength ? 'STRENGTH' : 'TIMER',
              icon: type == ExerciseType.strength
                  ? Icons.fitness_center
                  : Icons.timer,
              isSelected: isSelected,
              onTap: () => onChanged(type),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : cs.surfaceContainer,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
