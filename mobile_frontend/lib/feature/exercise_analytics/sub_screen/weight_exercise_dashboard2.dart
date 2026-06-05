import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/exercise/models/exercise.dart';
import 'package:mobile_frontend/feature/exercise_analytics/data/workout_service.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/workout.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/history_table/weight_and_reps_table2.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/progress_graph.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table/set_entry_table_weight.dart';

/// Strength session screen: set entry table, progress graph, and history table.
class WeightExerciseDashboard2 extends ConsumerStatefulWidget {
  final Exercise exercise;

  const WeightExerciseDashboard2({super.key, required this.exercise});

  @override
  ConsumerState<WeightExerciseDashboard2> createState() =>
      _WeightExerciseDashboard2State();
}

class _WeightExerciseDashboard2State
    extends ConsumerState<WeightExerciseDashboard2> {
  List<Workout> workoutHistory = [];
  late final WorkoutService _workoutService;

  @override
  void initState() {
    super.initState();
    _workoutService = WorkoutService(ref.read(appDatabaseProvider));
    _loadWorkoutHistory();
  }

  Future<void> _loadWorkoutHistory() async {
    final routineExerciseId = widget.exercise.routineExerciseId;
    if (routineExerciseId == null) return;

    try {
      final sessions = await _workoutService.allWorkoutSince(routineExerciseId);
      if (!mounted) return;
      setState(() => workoutHistory = sessions);
    } catch (error, stackTrace) {
      debugPrint('Workout history load failed: $error $stackTrace');
    }
  }

  int get _maxSets =>
      TrainingTargetInput.clampConfiguredSets(widget.exercise.sets);

  Future<void> _insertRandomDummyPastWorkout() async {
    final routineExerciseId = widget.exercise.routineExerciseId;
    if (routineExerciseId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Open this exercise from a routine to add test data.'),
        ),
      );
      return;
    }

    try {
      final sessionDate = await _workoutService
          .insertRandomDummyStrengthWorkoutInPast(
            routineExerciseId: routineExerciseId,
            setCount: _maxSets,
            weightHintKg: widget.exercise.weight > 0
                ? widget.exercise.weight
                : 60,
            repsHint: widget.exercise.reps > 0 ? widget.exercise.reps : 8,
          );
      if (!mounted) return;
      if (sessionDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No free past day in the last 90 days for this exercise.',
            ),
          ),
        );
        return;
      }
      await _loadWorkoutHistory();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Random past workout added (${sessionDate.month}/${sessionDate.day}).',
          ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Dummy workout insert failed: $error $stackTrace');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not add test data: $error')),
      );
    }
  }

  double _calculatePercentChange(Workout earlierWorkout, Workout laterWorkout) {
    final double? earlierTotal = earlierWorkout.totalTrainingLoad;
    final double? laterTotal = laterWorkout.totalTrainingLoad;
    if (earlierTotal == null || earlierTotal == 0 || laterTotal == null) {
      return 0;
    }
    return ((laterTotal - earlierTotal) / earlierTotal) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final List<double> series = workoutHistory
        .map((workout) => workout.totalTrainingLoad ?? workout.trainingLoad())
        .toList();
    final List<String> xLabels = workoutHistory
        .map((workout) => '${workout.date.month}/${workout.date.day}')
        .toList();

    return Column(
      children: [
        SetEntryTableWeight(
          exercise: widget.exercise,
          onWorkoutFinished: _loadWorkoutHistory,
        ),
        const SizedBox(height: 24),
        ProgressGraph(
          title: 'PROGRESS',
          subtitle: '· training load',
          percentChangeDisplay:
              (workoutHistory.length > 1
                      ? _calculatePercentChange(
                          workoutHistory[workoutHistory.length - 2],
                          workoutHistory[workoutHistory.length - 1],
                        )
                      : 0)
                  .toString(),
          series: series,
          xLabels: xLabels,
        ),
        const SizedBox(height: 24),
        WeightsAndRepsTable2(workouts: workoutHistory),
        if (kDebugMode) ...[
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _insertRandomDummyPastWorkout,
            icon: const Icon(Icons.science_outlined, size: 18),
            label: const Text('Add random past workout (test data)'),
          ),
        ],
      ],
    );
  }
}
