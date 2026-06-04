import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/feature/exercise/models/exercise.dart';
import 'package:mobile_frontend/feature/exercise_analytics/sub_screen/weight_exercise_dashboard2.dart';

class ExerciseAnalyticsScreen2 extends StatelessWidget {
  final Exercise exercise;

  const ExerciseAnalyticsScreen2({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const KineticAppBar(showBackButton: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  'CURRENT SESSION',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                    color: cs.tertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  exercise.name.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.5,
                    height: 1.0,
                    color: cs.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // const SizedBox(height: 32),
          if (exercise.isStrength) WeightExerciseDashboard2(exercise: exercise),
          // else
          // TimerExerciseDashboard(exercise: exercise),
        ],
      ),
    );
  }
}
