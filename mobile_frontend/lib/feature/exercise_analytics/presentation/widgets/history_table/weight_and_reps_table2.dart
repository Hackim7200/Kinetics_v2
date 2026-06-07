import 'package:flutter/material.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/workout.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/history_table/workout_history_table.dart';

const double _weightMetricColWidth = 30;

String _weightOrRepsText(Set? set, {required bool weight}) {
  if (set == null) return '—';
  if (weight) {
    final value = set.weight;
    if (value == null) return '—';
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }
  if (set.reps == null) return '—';
  return '${set.reps}';
}

/// Read-only paginated table: one row per session, columns Date, W1/R1 … WN/RN.
class WeightsAndRepsTable2 extends StatelessWidget {
  final List<Workout> workouts;

  const WeightsAndRepsTable2({super.key, required this.workouts});

  @override
  Widget build(BuildContext context) {
    return WorkoutHistoryTable(
      workouts: workouts,
      metricsPerSet: 2,
      metricColWidth: _weightMetricColWidth,
      metricColumnLabel: (setNumber, metricIndex) =>
          metricIndex == 0 ? 'W$setNumber' : 'R$setNumber',
      metricCellText: (set, metricIndex) =>
          _weightOrRepsText(set, weight: metricIndex == 0),
      metricIsBold: (_, metricIndex) => metricIndex.isEven,
    );
  }
}
