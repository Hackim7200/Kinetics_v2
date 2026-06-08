import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/widgets/empty_state_widget.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/feature/routine/data/repositories/routine_repository.dart';
import 'package:mobile_frontend/feature/routine/domain/entities/routine.dart';
import 'package:mobile_frontend/feature/routine/presentation/pages/create_routine_screen.dart';
import 'package:mobile_frontend/feature/routine/presentation/widgets/create_routine_button.dart';
import 'package:mobile_frontend/feature/routine/presentation/widgets/routine_card.dart';
import 'package:mobile_frontend/feature/routine_exercise/data/repositories/routine_exercise_repository.dart';
import 'package:mobile_frontend/feature/routine_exercise/domain/entities/routine_exercise.dart';
import 'package:mobile_frontend/feature/routine_exercise/domain/use_cases/exercise_stats.dart';
import 'package:mobile_frontend/feature/routine_exercise/presentation/pages/exercise_list_screen.dart';

class RoutineListScreen extends ConsumerWidget {
  const RoutineListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final routineRepository = ref.watch(routineRepositoryProvider);
    final routineExerciseRepository = ref.watch(
      routineExerciseRepositoryProvider,
    );

    return Scaffold(
      appBar: const KineticAppBar(),
      body: StreamBuilder<List<Routine>>(
        stream: routineRepository.watchRoutines(),
        builder: (context, routineSnap) {
          if (routineSnap.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: GoogleFonts.inter(color: colorScheme.error),
              ),
            );
          }

          if (!routineSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final routines = routineSnap.data!;

          if (routines.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.fitness_center,
              title: 'No routines yet',
              subtitle:
                  'Create a routine (e.g. Push Day) and add exercises from the detail screen.',
              actionLabel: 'Create routine',
              onAction: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreateRoutineScreen()),
              ),
            );
          }

          return StreamBuilder<List<RoutineExercise>>(
            stream: routineExerciseRepository.watchAllRoutineExercises(),
            builder: (context, routineExerciseSnap) {
              return StreamBuilder(
                stream: routineExerciseRepository.watchAllExerciseSessionLogs(),
                builder: (context, logSnap) {
                  final routineExercises =
                      routineExerciseSnap.data ?? const <RoutineExercise>[];
                  final logs = logSnap.data ?? const [];
                  final exercisesCountForRoutine =
                      RoutineExerciseMetrics.exerciseCountsByRoutineId(
                        routineExercises,
                      );
                  final lastPerformed =
                      RoutineExerciseMetrics.lastPerformedByRoutineId(
                        routineExercises: routineExercises,
                        logs: logs,
                      );

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'ACTIVE ROUTINES',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: colorScheme.primary,
                            ),
                          ),
                          Text(
                            '${routines.length} Total',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ...routines.map(
                        (routine) => RoutineCard(
                          routine: routine,
                          exerciseCount:
                              exercisesCountForRoutine[routine.id] ?? 0,
                          lastPerformed: lastPerformed[routine.id],
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ExerciseListScreen(routine: routine),
                            ),
                          ),
                        ),
                      ),
                      CreateRoutineButton(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CreateRoutineScreen(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
