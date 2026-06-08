import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/exercise.dart';
import 'package:mobile_frontend/feature/exercise_analytics/data/repositories/workout_repository.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/workout.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/progress_graph_data.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/use_cases/workout_metrics.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/history_table/weight_and_reps_table2.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/progress_graph.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/set_entry_table/set_entry_table_weight.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/small_stat_card.dart';

/// Strength session screen: set entry table, progress graph, and history table.
class WeightExerciseDashboard extends ConsumerStatefulWidget {
  final Exercise exercise;

  const WeightExerciseDashboard({super.key, required this.exercise});

  @override
  ConsumerState<WeightExerciseDashboard> createState() =>
      _WeightExerciseDashboardState();
}

class _WeightExerciseDashboardState
    extends ConsumerState<WeightExerciseDashboard> {
  List<Workout> workoutHistory = [];

  @override
  void initState() {
    super.initState();
    _loadWorkoutHistory();
  }

  Future<void> _loadWorkoutHistory() async {
    try {
      final sessions = await ref
          .read(workoutRepositoryProvider)
          .listWorkouts(widget.exercise.routineExerciseId);
      if (!mounted) return;
      setState(() => workoutHistory = sessions);
    } catch (error, stackTrace) {
      debugPrint('Workout history load failed: $error $stackTrace');
    }
  }

  int get _maxSets =>
      TrainingTargetInput.clampConfiguredSets(widget.exercise.sets);

  Future<void> _insertRandomDummyPastWorkout() async {
    try {
      final sessionDate = await ref
          .read(workoutRepositoryProvider)
          .insertRandomDummyStrengthWorkoutInPast(
            routineExerciseId: widget.exercise.routineExerciseId,
            setCount: _maxSets,
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

  @override
  Widget build(BuildContext context) {
    final graphData = ProgressGraphData.fromWorkouts(workoutHistory);
    final maxWeightLast30Days =
        WorkoutMetrics.maxStrengthWeightKgLastDays(workoutHistory);
    final todaysLoad = WorkoutMetrics.todaysTrainingLoad(workoutHistory);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SetEntryTableWeight(
          exercise: widget.exercise,
          onSetsChanged: (_) => _loadWorkoutHistory(),
          onWorkoutFinished: _loadWorkoutHistory,
        ),
        const SizedBox(height: 24),
        ProgressGraph(
          title: 'PROGRESS',
          subtitle: '· training load',
          percentChangeDisplay:
              WorkoutMetrics.formatPercentChange(graphData.percentChange),
          series: graphData.series,
          xLabels: graphData.xLabels,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'MAX WEIGHT',
                value: WorkoutMetrics.formatWeightKg(maxWeightLast30Days),
                unit: maxWeightLast30Days == null ? null : 'KG',
                sublabel: 'last 30 days',
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: StatCard(
                label: 'TRAINING LOAD',
                value: WorkoutMetrics.formatTrainingLoad(todaysLoad),
                sublabel: 'today',
              ),
            ),
          ],
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
