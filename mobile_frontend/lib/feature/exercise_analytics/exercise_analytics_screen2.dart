import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:mobile_frontend/feature/exercise/models/exercise.dart';
import 'package:mobile_frontend/feature/exercise/screens/edit_exercise_screen.dart';
import 'package:mobile_frontend/feature/exercise_analytics/sub_screen/timer_exercise_dashboard2%20.dart';
import 'package:mobile_frontend/feature/exercise_analytics/sub_screen/weight_exercise_dashboard2.dart';

class ExerciseAnalyticsScreen2 extends StatelessWidget {
  final Exercise exercise;
  final RoutineExercise? routineExercise;
  final String? routineName;

  const ExerciseAnalyticsScreen2({
    super.key,
    required this.exercise,
    this.routineExercise,
    this.routineName,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: KineticAppBar(
        showBackButton: true,
        actions: routineExercise == null
            ? null
            : [
                IconButton(
                  tooltip: 'Edit exercise',
                  onPressed: () async {
                    final result = await Navigator.of(context).push<String>(
                      MaterialPageRoute<String>(
                        builder: (_) => EditExerciseScreen(
                          routineExercise: routineExercise!,
                          routineName: routineName,
                        ),
                      ),
                    );
                    if (!context.mounted) return;
                    if (result == 'deleted') Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.edit_outlined, color: cs.onSurface),
                ),
              ],
      ),
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
          const SizedBox(height: 12),
          if (exercise.isStrength)
            WeightExerciseDashboard2(exercise: exercise)
          else
            TimerExerciseDashboard2(exercise: exercise),
        ],
      ),
    );
  }
}
