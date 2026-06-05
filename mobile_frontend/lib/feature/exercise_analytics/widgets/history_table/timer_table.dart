import 'package:flutter/material.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/workout.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/set_entry_table_add_time_sheet.dart';

const double _dateColWidth = 92;
const double _durationColWidth = 56;
const double _columnSpacing = 12;
const double _horizontalMargin = 8;

int _maxSetCount(List<Workout> workouts) {
  var highestSetNumber = 0;
  for (final workout in workouts) {
    for (final set in workout.sets) {
      if (set.setNumber > highestSetNumber) highestSetNumber = set.setNumber;
    }
  }
  return highestSetNumber;
}

int _lastPageFirstRowIndex(int rowCount, int rowsPerPage) {
  if (rowCount <= 0) return 0;
  return ((rowCount - 1) ~/ rowsPerPage) * rowsPerPage;
}

Set? _setForNumber(Workout workout, int setNumber) {
  for (final set in workout.sets) {
    if (set.setNumber == setNumber) return set;
  }
  return null;
}

String _dateLabel(DateTime date) => '${date.month}/${date.day}';

String _durationText(Set? set) {
  final seconds = set?.timeElapsed;
  if (seconds == null || seconds <= 0) return '—';
  return formatTimerMinutesSeconds(Duration(seconds: seconds));
}

class _TimerWorkoutHistoryDataSource extends DataTableSource {
  _TimerWorkoutHistoryDataSource({required List<Workout> workouts})
    : _workouts = workouts,
      maxSetCount = _maxSetCount(workouts);

  List<Workout> _workouts;
  int maxSetCount;

  void update(List<Workout> workouts) {
    _workouts = workouts;
    maxSetCount = _maxSetCount(workouts);
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
        DataCell(Text(_dateLabel(workout.date))),
        for (var setNumber = 1; setNumber <= maxSetCount; setNumber++)
          DataCell(Text(_durationText(_setForNumber(workout, setNumber)))),
      ],
    );
  }
}

/// Read-only paginated table: one row per session, columns Date, D1 … DN.
class TimerTable extends StatefulWidget {
  final List<Workout> workouts;

  const TimerTable({super.key, required this.workouts});

  @override
  State<TimerTable> createState() => _TimerTableState();
}

class _TimerTableState extends State<TimerTable> {
  static const int _rowsPerPage = 7;

  late _TimerWorkoutHistoryDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = _TimerWorkoutHistoryDataSource(workouts: widget.workouts);
  }

  @override
  void didUpdateWidget(TimerTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.workouts != widget.workouts) {
      _dataSource.update(widget.workouts);
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

    final maxSetCount = _dataSource.maxSetCount;
    final columnCount = 1 + maxSetCount;
    final minTableWidth =
        _dateColWidth +
        (maxSetCount * _durationColWidth) +
        (columnCount * _columnSpacing) +
        (_horizontalMargin * 2);

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : minTableWidth;
        final tableWidth = minTableWidth > viewportWidth
            ? minTableWidth
            : viewportWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: tableWidth,
            child: PaginatedDataTable(
              key: ValueKey(widget.workouts.length),
              showCheckboxColumn: false,
              columnSpacing: _columnSpacing,
              horizontalMargin: _horizontalMargin,
              initialFirstRowIndex: _lastPageFirstRowIndex(
                widget.workouts.length,
                _rowsPerPage,
              ),
              rowsPerPage: _rowsPerPage,
              availableRowsPerPage: const [_rowsPerPage],
              columns: [
                const DataColumn(label: Text('DATE')),
                for (var setNumber = 1; setNumber <= maxSetCount; setNumber++)
                  DataColumn(label: Text('D$setNumber')),
              ],
              source: _dataSource,
            ),
          ),
        );
      },
    );
  }
}
