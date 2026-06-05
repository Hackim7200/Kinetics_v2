import 'package:flutter/material.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/workout.dart';

const double workoutHistoryDateColWidth = 92;
const double workoutHistoryColumnSpacing = 12;
const double workoutHistoryHorizontalMargin = 8;
const int workoutHistoryRowsPerPage = 7;

int maxSetCountAcrossWorkouts(List<Workout> workouts) {
  var highestSetNumber = 0;
  for (final workout in workouts) {
    for (final set in workout.sets) {
      if (set.setNumber > highestSetNumber) highestSetNumber = set.setNumber;
    }
  }
  return highestSetNumber;
}

int lastPageFirstRowIndex(int rowCount, int rowsPerPage) {
  if (rowCount <= 0) return 0;
  return ((rowCount - 1) ~/ rowsPerPage) * rowsPerPage;
}

Set? setForWorkoutAndNumber(Workout workout, int setNumber) {
  for (final set in workout.sets) {
    if (set.setNumber == setNumber) return set;
  }
  return null;
}

String workoutHistoryDateLabel(DateTime date) => '${date.month}/${date.day}';

class _WorkoutHistoryDataSource extends DataTableSource {
  _WorkoutHistoryDataSource({
    required List<Workout> workouts,
    required int displaySetCount,
    required this.metricsPerSet,
    required this.metricColWidth,
    required this.metricCellText,
  }) : _workouts = workouts,
       _displaySetCount = displaySetCount;

  List<Workout> _workouts;
  int _displaySetCount;
  final int metricsPerSet;
  final double metricColWidth;
  final String Function(Set? set, int metricIndex) metricCellText;

  void update(List<Workout> workouts, int displaySetCount) {
    _workouts = workouts;
    _displaySetCount = displaySetCount;
    notifyListeners();
  }

  @override
  int get rowCount => _workouts.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow? getRow(int index) {
    if (index < 0 || index >= _workouts.length) return null;

    final workout = _workouts[index];
    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            width: workoutHistoryDateColWidth,
            child: Text(
              workoutHistoryDateLabel(workout.date),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        for (var setNumber = 1; setNumber <= _displaySetCount; setNumber++)
          for (var metricIndex = 0; metricIndex < metricsPerSet; metricIndex++)
            DataCell(
              SizedBox(
                width: metricColWidth,
                child: Text(
                  metricCellText(
                    setForWorkoutAndNumber(workout, setNumber),
                    metricIndex,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
      ],
    );
  }
}

/// Read-only paginated table: one row per session, **DATE** plus per-set metric columns.
class WorkoutHistoryTable extends StatefulWidget {
  final List<Workout> workouts;
  final int metricsPerSet;
  final double metricColWidth;
  final int minSetCount;
  final String Function(int setNumber, int metricIndex) metricColumnLabel;
  final String Function(Set? set, int metricIndex) metricCellText;

  const WorkoutHistoryTable({
    super.key,
    required this.workouts,
    required this.metricsPerSet,
    required this.metricColWidth,
    this.minSetCount = 0,
    required this.metricColumnLabel,
    required this.metricCellText,
  });

  @override
  State<WorkoutHistoryTable> createState() => _WorkoutHistoryTableState();
}

class _WorkoutHistoryTableState extends State<WorkoutHistoryTable> {
  late _WorkoutHistoryDataSource _dataSource;

  int get _displaySetCount {
    final loggedSetCount = maxSetCountAcrossWorkouts(widget.workouts);
    return loggedSetCount > widget.minSetCount
        ? loggedSetCount
        : widget.minSetCount;
  }

  @override
  void initState() {
    super.initState();
    _dataSource = _WorkoutHistoryDataSource(
      workouts: widget.workouts,
      displaySetCount: _displaySetCount,
      metricsPerSet: widget.metricsPerSet,
      metricColWidth: widget.metricColWidth,
      metricCellText: widget.metricCellText,
    );
  }

  @override
  void didUpdateWidget(WorkoutHistoryTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.workouts != widget.workouts ||
        oldWidget.minSetCount != widget.minSetCount) {
      _dataSource.update(widget.workouts, _displaySetCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.workouts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'No saved workout history for this exercise yet.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    final displaySetCount = _displaySetCount;
    final columnCount = 1 + displaySetCount * widget.metricsPerSet;
    final minTableWidth =
        workoutHistoryDateColWidth +
        (displaySetCount * widget.metricsPerSet * widget.metricColWidth) +
        (columnCount * workoutHistoryColumnSpacing) +
        (workoutHistoryHorizontalMargin * 2);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: minTableWidth,
        child: PaginatedDataTable(
          key: ValueKey('$displaySetCount-${widget.workouts.length}'),
          showCheckboxColumn: false,
          columnSpacing: workoutHistoryColumnSpacing,
          horizontalMargin: workoutHistoryHorizontalMargin,
          initialFirstRowIndex: lastPageFirstRowIndex(
            widget.workouts.length,
            workoutHistoryRowsPerPage,
          ),
          rowsPerPage: workoutHistoryRowsPerPage,
          availableRowsPerPage: const [workoutHistoryRowsPerPage],
          columns: [
            DataColumn(
              label: SizedBox(
                width: workoutHistoryDateColWidth,
                child: const Text('DATE', textAlign: TextAlign.center),
              ),
            ),
            for (var setNumber = 1; setNumber <= displaySetCount; setNumber++)
              for (
                var metricIndex = 0;
                metricIndex < widget.metricsPerSet;
                metricIndex++
              )
                DataColumn(
                  label: SizedBox(
                    width: widget.metricColWidth,
                    child: Text(
                      widget.metricColumnLabel(setNumber, metricIndex),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
          ],
          source: _dataSource,
        ),
      ),
    );
  }
}
