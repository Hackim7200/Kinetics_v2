import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/widgets/detail_hero_header.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/common/widgets/metric_pill.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/routine/data/routine_exercise_service.dart';
import 'package:mobile_frontend/feature/routine/routine_last_session_format.dart';
import 'package:mobile_frontend/feature/exercise/screens/add_exercise_screen.dart';
import 'package:mobile_frontend/feature/routine/screens/edit_routine_screen.dart';
import 'package:mobile_frontend/feature/exercise_analytics/data/workout_log_stats.dart';
import 'package:mobile_frontend/feature/exercise/widgets/add_exercise_button.dart';
import 'package:mobile_frontend/feature/exercise/widgets/exercise_tile.dart';

class ExerciseListScreen extends ConsumerStatefulWidget {
  final Routine routine;

  const ExerciseListScreen({super.key, required this.routine});

  @override
  ConsumerState<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends ConsumerState<ExerciseListScreen> {
  late Routine _routine;
  late final RoutineExerciseService _routineExerciseService;

  @override
  void initState() {
    super.initState();
    _routine = widget.routine;
    _routineExerciseService = RoutineExerciseService(
      ref.read(appDatabaseProvider),
    );
  }

  Future<void> _openEdit() async {
    final updated = await Navigator.of(context).push<Routine>(
      MaterialPageRoute(builder: (_) => EditRoutineScreen(routine: _routine)),
    );
    if (updated != null && mounted) setState(() => _routine = updated);
  }

  Future<void> _addExercise() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => AddExerciseScreen(
          routineId: _routine.id,
          routineName: _routine.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: KineticAppBar(
        showBackButton: true,
        actions: [
          GestureDetector(
            onTap: _openEdit,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.edit_outlined, color: cs.primary, size: 22),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
        children: [
          _HeroHeader(
            routine: _routine,
            routineExerciseService: _routineExerciseService,
          ),
          const SizedBox(height: 40),
          _ExerciseList(
            routineId: _routine.id,
            routineName: _routine.name,
            routineExerciseService: _routineExerciseService,
            onAddExercise: _addExercise,
          ),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final Routine routine;
  final RoutineExerciseService routineExerciseService;

  const _HeroHeader({
    required this.routine,
    required this.routineExerciseService,
  });

  @override
  Widget build(BuildContext context) {
    return DetailHeroHeader(
      eyebrowLabel: 'ACTIVE ROUTINE',
      title: routine.name,
      metrics: StreamBuilder<List<RoutineExercise>>(
        stream: routineExerciseService.watchForRoutine(routine.id),
        builder: (context, routineExerciseSnap) {
          final routineExercises =
              routineExerciseSnap.data ?? const <RoutineExercise>[];
          final n = routineExercises.length;
          return StreamBuilder<List<WorkoutLog>>(
            stream: routineExerciseService.watchAllWorkoutLogs(),
            builder: (context, logSnap) {
              DateTime? last;
              if (routineExercises.isNotEmpty && logSnap.hasData) {
                final map = RoutineExerciseService.lastPerformedByRoutineId(
                  routineExercises: routineExercises,
                  logs: logSnap.data!,
                );
                last = map[routine.id];
              }
              return MetricPillPair(
                leftLabel: 'EXERCISES',
                leftValue: '$n',
                rightLabel: 'LAST SESSION',
                rightValue: formatRoutineLastSessionLabel(last).toUpperCase(),
              );
            },
          );
        },
      ),
    );
  }
}

class _ExerciseList extends StatelessWidget {
  final String routineId;
  final String routineName;
  final RoutineExerciseService routineExerciseService;
  final VoidCallback onAddExercise;

  const _ExerciseList({
    required this.routineId,
    required this.routineName,
    required this.routineExerciseService,
    required this.onAddExercise,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return StreamBuilder<List<RoutineExercise>>(
      stream: routineExerciseService.watchForRoutine(routineId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            'Could not load exercises',
            style: GoogleFonts.inter(color: cs.error),
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
                    bottom: BorderSide(color: cs.surfaceContainerHighest),
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
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${routineExercises.length} Total',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: cs.outline,
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
                  style: GoogleFonts.inter(fontSize: 14, color: cs.outline),
                ),
              )
            else
              /// List of exercises for a routine
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
