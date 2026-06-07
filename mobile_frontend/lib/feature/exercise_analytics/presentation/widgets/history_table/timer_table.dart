import 'package:flutter/material.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/domain/entities/workout.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/history_table/workout_history_table.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/widgets/set_entry_table_add_time_sheet.dart';

const double _durationColWidth = 56;

String _durationText(Set? set) {
  final seconds = set?.timeElapsed;
  if (seconds == null || seconds <= 0) return '—';
  return formatTimerMinutesSeconds(Duration(seconds: seconds));
}

/// Read-only paginated table: one row per session, columns Date, D1 … DN.
class TimerTable extends StatelessWidget {
  final List<Workout> workouts;
  final int minSetCount;

  const TimerTable({
    super.key,
    required this.workouts,
    this.minSetCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return WorkoutHistoryTable(
      workouts: workouts,
      metricsPerSet: 1,
      metricColWidth: _durationColWidth,
      minSetCount: minSetCount,
      metricColumnLabel: (setNumber, _) => 'D$setNumber',
      metricCellText: (set, _) => _durationText(set),
    );
  }
}
