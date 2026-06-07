import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/feature/exercise/models/exercise.dart';
import 'package:mobile_frontend/feature/exercise_analytics/data/repositories/workout_repository.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/workout.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/progress_graph_data.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/use_cases/workout_metrics.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/history_table/timer_table.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/progress_graph.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/set_entry_table/set_entry_table_timer.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/small_stat_card.dart';

/// Timer session screen: set entry table, progress graph, and history table.
class TimerExerciseDashboard2 extends ConsumerStatefulWidget {
  final Exercise exercise;

  const TimerExerciseDashboard2({super.key, required this.exercise});

  @override
  ConsumerState<TimerExerciseDashboard2> createState() =>
      _TimerExerciseDashboard2State();
}

class _TimerExerciseDashboard2State
    extends ConsumerState<TimerExerciseDashboard2> {
  List<Workout> workoutHistory = [];

  @override
  void initState() {
    super.initState();
    _loadWorkoutHistory();
  }

  Future<void> _loadWorkoutHistory() async {
    final routineExerciseId = widget.exercise.routineExerciseId;
    if (routineExerciseId == null) return;

    try {
      final sessions = await ref
          .read(workoutRepositoryProvider)
          .listWorkouts(routineExerciseId);
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
      final sessionDate = await ref
          .read(workoutRepositoryProvider)
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

  @override
  Widget build(BuildContext context) {
    final graphData = ProgressGraphData.fromWorkouts(workoutHistory);
    final maxHoldLast30Days =
        WorkoutMetrics.maxTimerHoldSecondsLastDays(workoutHistory);
    final todaysTotalSeconds = WorkoutMetrics.todaysTrainingLoad(
      workoutHistory,
    ).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SetEntryTableTimer(
          exercise: widget.exercise,
          onSetsChanged: (_) => _loadWorkoutHistory(),
          onWorkoutFinished: _loadWorkoutHistory,
        ),
        const SizedBox(height: 24),
        ProgressGraph(
          title: 'PROGRESS',
          subtitle: '· training load',
          percentChangeDisplay: graphData.percentChange.toString(),
          series: graphData.series,
          xLabels: graphData.xLabels,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'MAX HOLD',
                value: WorkoutMetrics.formatDurationSeconds(maxHoldLast30Days),
                sublabel: 'last 30 days',
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: StatCard(
                label: 'TOTAL TIME',
                value: WorkoutMetrics.formatDurationSeconds(todaysTotalSeconds),
                sublabel: 'today',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        TimerTable(workouts: workoutHistory, minSetCount: _maxSets),
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
