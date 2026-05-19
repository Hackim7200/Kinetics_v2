import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/widgets/empty_state_widget.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/exercise/exercise_list_screen.dart';
import 'package:mobile_frontend/feature/routine/data/routine_exercise_service.dart';
import 'package:mobile_frontend/feature/routine/data/routine_service.dart';
import 'package:mobile_frontend/feature/routine/screens/create_routine_screen.dart';
import 'package:mobile_frontend/feature/routine/widgets/create_routine_card.dart';
import 'package:mobile_frontend/feature/routine/widgets/routine_card.dart';

class RoutineListScreen extends ConsumerStatefulWidget {
  const RoutineListScreen({super.key});

  @override
  ConsumerState<RoutineListScreen> createState() => _RoutineListScreenState();
}

class _RoutineListScreenState extends ConsumerState<RoutineListScreen> {
  late final RoutineService _service;
  late final RoutineExerciseService _routineExerciseService;

  @override
  void initState() {
    super.initState();
    final db = ref.read(appDatabaseProvider);
    _service = RoutineService(db);
    _routineExerciseService = RoutineExerciseService(db);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const KineticAppBar(),
      body: StreamBuilder<List<Routine>>(
        stream: _service.watchRoutines(),
        builder: (context, routineSnap) {
          if (routineSnap.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: GoogleFonts.inter(color: cs.error),
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
                MaterialPageRoute(
                  builder: (_) => const CreateRoutineScreen(),
                ),
              ),
            );
          }

          return StreamBuilder<List<RoutineExercise>>(
            stream: _routineExerciseService.watchAllRoutineExerciseLinks(),
            builder: (context, linkSnap) {
              return StreamBuilder<List<WorkoutLog>>(
                stream: _routineExerciseService.watchAllWorkoutLogs(),
                builder: (context, logSnap) {
                  final links = linkSnap.data ?? const <RoutineExercise>[];
                  final logs = logSnap.data ?? const <WorkoutLog>[];
                  final counts =
                      RoutineExerciseService.exerciseCountsByRoutineId(links);
                  final lastPerformed =
                      RoutineExerciseService.lastPerformedByRoutineId(
                        links: links,
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
                              color: cs.primary,
                            ),
                          ),
                          Text(
                            '${routines.length} Total',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: cs.tertiary,
                            ),
                          ),
                        ],
                      ),

                      /// Routine list
                      const SizedBox(height: 24),
                      ...routines.map(
                        (routine) => Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: RoutineCard(
                            routine: routine,
                            exerciseCount: counts[routine.id] ?? 0,
                            lastPerformed: lastPerformed[routine.id],
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ExerciseListScreen(
                                  routine: routine,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      CreateRoutineCard(
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
