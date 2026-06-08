import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/feature/routine_exercise/domain/entities/routine_exercise.dart';
import 'package:mobile_frontend/feature/routine_exercise/presentation/pages/edit_exercise_screen.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/use_cases/map_routine_exercise_for_session.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/pages/timer_exercise_dashboard.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/pages/weight_exercise_dashboard.dart';

class ExerciseAnalyticsScreen2 extends StatelessWidget {
  final RoutineExercise routineExercise;
  final int listIndex;
  final String? routineName;

  const ExerciseAnalyticsScreen2({
    super.key,
    required this.routineExercise,
    required this.listIndex,
    this.routineName,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final exercise = mapRoutineExerciseForSession(routineExercise, listIndex);

    return Scaffold(
      appBar: KineticAppBar(
        showBackButton: true,
        actions: [
          IconButton(
            tooltip: 'Edit exercise',
            onPressed: () async {
              final result = await Navigator.of(context).push<String>(
                MaterialPageRoute<String>(
                  builder: (_) => EditExerciseScreen(
                    routineExercise: routineExercise,
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
            WeightExerciseDashboard(exercise: exercise)
          else
            TimerExerciseDashboard2(exercise: exercise),
        ],
      ),
    );
  }
}
