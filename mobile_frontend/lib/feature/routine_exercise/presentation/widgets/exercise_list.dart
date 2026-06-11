import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/feature/routine_exercise/data/repositories/routine_exercise_repository.dart';
import 'package:mobile_frontend/feature/routine_exercise/domain/entities/routine_exercise.dart';
import 'package:mobile_frontend/feature/routine_exercise/presentation/widgets/add_exercise_button.dart';
import 'package:mobile_frontend/feature/routine_exercise/presentation/widgets/exercise_tile.dart';
import 'package:mobile_frontend/feature/exercise_analytics/data/repositories/workout_repository.dart';

class ExerciseList extends ConsumerStatefulWidget {
  final String routineId;
  final String routineName;
  final VoidCallback onAddExercise;

  const ExerciseList({
    super.key,
    required this.routineId,
    required this.routineName,
    required this.onAddExercise,
  });

  @override
  ConsumerState<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends ConsumerState<ExerciseList> {
  int _statsRefreshNonce = 0;

  void _refreshExerciseStats() {
    setState(() => _statsRefreshNonce++);
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).colorScheme;
    final routineExerciseRepository = ref.watch(
      routineExerciseRepositoryProvider,
    );
    final workoutRepository = ref.read(workoutRepositoryProvider);

    return StreamBuilder<List<RoutineExercise>>(
      stream: routineExerciseRepository.watchForRoutine(widget.routineId),
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
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: appTheme.outline,
                  ),
                ),
              )
            else
              Column(
                children: [
                  for (var index = 0; index < routineExercises.length; index++)
                    _ExerciseTileWithStats(
                      key: ValueKey(
                        '${routineExercises[index].id}_$_statsRefreshNonce',
                      ),
                      routineExercise: routineExercises[index],
                      listIndex: index,
                      routineName: widget.routineName,
                      workoutRepository: workoutRepository,
                      onAnalyticsClosed: _refreshExerciseStats,
                    ),
                ],
              ),
            AddExerciseButton(onTap: widget.onAddExercise),
          ],
        );
      },
    );
  }
}

class _ExerciseTileWithStats extends StatelessWidget {
  const _ExerciseTileWithStats({
    super.key,
    required this.routineExercise,
    required this.listIndex,
    required this.routineName,
    required this.workoutRepository,
    required this.onAnalyticsClosed,
  });

  final RoutineExercise routineExercise;
  final int listIndex;
  final String routineName;
  final WorkoutRepository workoutRepository;
  final VoidCallback onAnalyticsClosed;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double?>(
      future: workoutRepository.latestSessionTrainingLoadChangePercent(
        routineExercise.id,
      ),
      builder: (context, snap) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ExerciseTile(
            routineExercise: routineExercise,
            listIndex: listIndex,
            routineName: routineName,
            trainingLoadChangePercent: snap.data,
            onAnalyticsClosed: onAnalyticsClosed,
          ),
        );
      },
    );
  }
}
