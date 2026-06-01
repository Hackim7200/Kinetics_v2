import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:mobile_frontend/feature/exercise/widgets/add_exercise_button.dart';
import 'package:mobile_frontend/feature/exercise/widgets/exercise_tile.dart';
import 'package:mobile_frontend/feature/exercise_analytics/data/workout_log_stats.dart';
import 'package:mobile_frontend/feature/routine/data/routine_exercise_service.dart';

class ExerciseList extends StatelessWidget {
  final String routineId;
  final String routineName;
  final RoutineExerciseService routineExerciseService;
  final VoidCallback onAddExercise;

  const ExerciseList({
    super.key,
    required this.routineId,
    required this.routineName,
    required this.routineExerciseService,
    required this.onAddExercise,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).colorScheme;

    return StreamBuilder<List<RoutineExercise>>(
      stream: routineExerciseService.watchForRoutine(routineId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            'Could not load exercises',
            style: GoogleFonts.inter(color: appTheme.error),
          );
        }
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final routineExercises = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: appTheme.surfaceContainerHighest),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EXERCISES',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                          color: appTheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${routineExercises.length} Total',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: appTheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (routineExercises.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'No exercises yet. Use the button below to add one.',
                  style: GoogleFonts.inter(fontSize: 14, color: appTheme.outline),
                ),
              )
            else
              FutureBuilder<Map<String, Exercise>>(
                key: ValueKey(routineExercises.map((e) => e.id).join(',')),
                future: routineExerciseService.exerciseMapForIds(
                  routineExercises.map((re) => re.exerciseId).toSet(),
                ),
                builder: (context, exSnap) {
                  if (!exSnap.hasData) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final map = exSnap.data!;
                  return StreamBuilder<List<WorkoutLog>>(
                    stream: routineExerciseService.watchAllWorkoutLogs(),
                    builder: (context, logSnap) {
                      final logs = logSnap.data ?? const <WorkoutLog>[];
                      return Column(
                        children: [
                          for (var i = 0; i < routineExercises.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ExerciseTile(
                                exercise: map[routineExercises[i].exerciseId],
                                routineExercise: routineExercises[i],
                                listIndex: i,
                                routineName: routineName,
                                trainingLoadChangePercent:
                                    map[routineExercises[i].exerciseId]?.type !=
                                        'timer'
                                    ? WorkoutLogStats.trainingLoadChangePercentForLatestSession(
                                        routineExercises[i].id,
                                        logs,
                                      )
                                    : null,
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            AddExerciseButton(onTap: onAddExercise),
          ],
        );
      },
    );
  }
}
