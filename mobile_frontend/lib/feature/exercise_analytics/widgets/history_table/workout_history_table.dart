import 'package:flutter/material.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/workout.dart';

const double workoutHistoryDateColWidth = 92;
const double workoutHistoryColumnSpacing = 4;
const double workoutHistoryHorizontalMargin = 4;
const int workoutHistoryRowsPerPage = 7;
const double workoutHistoryHeadingRowHeight = 36;
const double workoutHistoryDataRowHeight = 32;

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

const _workoutHistoryMonthNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String workoutHistoryDateLabel(DateTime date) =>
    '${date.day} ${_workoutHistoryMonthNames[date.month - 1]}';

class _WorkoutHistoryDataSource extends DataTableSource {
  _WorkoutHistoryDataSource({
    required List<Workout> workouts,
    required int displaySetCount,
    required this.metricsPerSet,
    required this.metricCellText,
    this.metricIsBold,
  }) : _workouts = workouts,
       _displaySetCount = displaySetCount;

  List<Workout> _workouts;
  int _displaySetCount;
  final int metricsPerSet;
  final String Function(Set? set, int metricIndex) metricCellText;
  final bool Function(int setNumber, int metricIndex)? metricIsBold;
  TextStyle? metricTextStyle;

  void update(List<Workout> workouts, int displaySetCount) {
    _workouts = workouts;
    _displaySetCount = displaySetCount;
    notifyListeners();
  }

  TextStyle _metricTextStyle(int setNumber, int metricIndex) {
    final isBold = metricIsBold?.call(setNumber, metricIndex) ?? false;
    final baseStyle = metricTextStyle ?? const TextStyle();
    return baseStyle.copyWith(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );
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
          Text(
            workoutHistoryDateLabel(workout.date),
            textAlign: TextAlign.center,
          ),
        ),
        for (var setNumber = 1; setNumber <= _displaySetCount; setNumber++)
          for (var metricIndex = 0; metricIndex < metricsPerSet; metricIndex++)
            DataCell(
              Text(
                metricCellText(
                  setForWorkoutAndNumber(workout, setNumber),
                  metricIndex,
                ),
                textAlign: TextAlign.center,
                style: _metricTextStyle(setNumber, metricIndex),
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
  final bool Function(int setNumber, int metricIndex)? metricIsBold;

  const WorkoutHistoryTable({
    super.key,
    required this.workouts,
    required this.metricsPerSet,
    required this.metricColWidth,
    this.minSetCount = 0,
    required this.metricColumnLabel,
    required this.metricCellText,
    this.metricIsBold,
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
      metricCellText: widget.metricCellText,
      metricIsBold: widget.metricIsBold,
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

  TextStyle _metricTextStyle(int setNumber, int metricIndex) {
    final isBold = widget.metricIsBold?.call(setNumber, metricIndex) ?? false;
    final baseStyle = Theme.of(context).textTheme.bodyMedium;
    return (baseStyle ?? const TextStyle()).copyWith(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );
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

    _dataSource.metricTextStyle = Theme.of(context).textTheme.bodyMedium;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: minTableWidth,
        child: PaginatedDataTable(
          key: ValueKey('$displaySetCount-${widget.workouts.length}'),
          showCheckboxColumn: false,
          columnSpacing: workoutHistoryColumnSpacing,
          horizontalMargin: workoutHistoryHorizontalMargin,
          headingRowHeight: workoutHistoryHeadingRowHeight,
          dataRowMinHeight: workoutHistoryDataRowHeight,
          dataRowMaxHeight: workoutHistoryDataRowHeight,
          initialFirstRowIndex: lastPageFirstRowIndex(
            widget.workouts.length,
            workoutHistoryRowsPerPage,
          ),
          rowsPerPage: workoutHistoryRowsPerPage,
          availableRowsPerPage: const [workoutHistoryRowsPerPage],
          columns: [
            DataColumn(
              columnWidth: FixedColumnWidth(workoutHistoryDateColWidth),
              label: const Text('DATE', textAlign: TextAlign.center),
            ),
            for (var setNumber = 1; setNumber <= displaySetCount; setNumber++)
              for (
                var metricIndex = 0;
                metricIndex < widget.metricsPerSet;
                metricIndex++
              )
                DataColumn(
                  columnWidth: FixedColumnWidth(widget.metricColWidth),
                  label: Text(
                    widget.metricColumnLabel(setNumber, metricIndex),
                    textAlign: TextAlign.center,
                    style: _metricTextStyle(setNumber, metricIndex),
                  ),
                ),
          ],
          source: _dataSource,
        ),
      ),
    );
  }
}
