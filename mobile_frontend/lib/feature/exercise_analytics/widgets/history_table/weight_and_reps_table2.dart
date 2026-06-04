import 'package:flutter/material.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/set.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/workout.dart';

const double _dateColWidth = 92;
const double _metricColWidth = 48;
const List<int> _rowsPerPageOptions = [5, 10, 20];

/// Read-only paginated table: one row per session, columns Date, W1/R1 … WN/RN.
class WeightsAndRepsTable2 extends StatefulWidget {
  final List<Workout> workouts;

  const WeightsAndRepsTable2({super.key, required this.workouts});

  static int maxSetCount(List<Workout> workouts) {
    var maxSetCount = 0;
    for (final workout in workouts) {
      for (final set in workout.sets) {
        if (set.setNumber > maxSetCount) maxSetCount = set.setNumber;
      }
    }
    return maxSetCount;
  }

  @override
  State<WeightsAndRepsTable2> createState() => _WeightsAndRepsTable2State();
}

class _WeightsAndRepsTable2State extends State<WeightsAndRepsTable2> {
  int _rowsPerPage = _rowsPerPageOptions.first;
  late _WorkoutHistoryDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = _WorkoutHistoryDataSource(
      workouts: widget.workouts,
      maxSetCount: WeightsAndRepsTable2.maxSetCount(widget.workouts),
    );
  }

  @override
  void didUpdateWidget(WeightsAndRepsTable2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.workouts != widget.workouts) {
      _dataSource.update(
        workouts: widget.workouts,
        maxSetCount: WeightsAndRepsTable2.maxSetCount(widget.workouts),
      );
    }
  }

  List<DataColumn> _columns(TextStyle? headerStyle) {
    return [
      DataColumn(label: Text('DATE', style: headerStyle)),
      for (
        var setNumber = 1;
        setNumber <= _dataSource.maxSetCount;
        setNumber++
      ) ...[
        DataColumn(label: Text('W$setNumber', style: headerStyle)),
        DataColumn(label: Text('R$setNumber', style: headerStyle)),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerStyle = theme.textTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.bold,
    );

    if (widget.workouts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'No saved workout history for this exercise yet.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    final columnCount = 1 + _dataSource.maxSetCount * 2;
    const columnSpacing = 12.0;
    final minTableWidth =
        _dateColWidth +
        (_dataSource.maxSetCount * 2 * _metricColWidth) +
        (columnCount * columnSpacing);

    return LayoutBuilder(
      builder: (context, constraints) {
        final tableWidth = minTableWidth.clamp(
          constraints.maxWidth,
          double.infinity,
        );

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: tableWidth,
            child: PaginatedDataTable(
              key: ValueKey(widget.workouts.length),
              showCheckboxColumn: false,
              columnSpacing: columnSpacing,
              horizontalMargin: 8,
              headingRowHeight: 40,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 52,
              rowsPerPage: _rowsPerPage,
              availableRowsPerPage: _rowsPerPageOptions,
              onRowsPerPageChanged: (rowsPerPage) {
                if (rowsPerPage == null) return;
                setState(() => _rowsPerPage = rowsPerPage);
              },
              columns: _columns(headerStyle),
              source: _dataSource,
            ),
          ),
        );
      },
    );
  }
}

class _WorkoutHistoryDataSource extends DataTableSource {
  _WorkoutHistoryDataSource({
    required List<Workout> workouts,
    required this.maxSetCount,
  }) : _workouts = workouts;

  List<Workout> _workouts;
  int maxSetCount;

  void update({required List<Workout> workouts, required int maxSetCount}) {
    _workouts = workouts;
    this.maxSetCount = maxSetCount;
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index < 0 || index >= _workouts.length) return null;

    final workout = _workouts[index];
    return DataRow(
      cells: [
        DataCell(Text(_dateLabel(workout.date))),
        for (var setNumber = 1; setNumber <= maxSetCount; setNumber++) ...[
          DataCell(
            Text(_metricText(_setForNumber(workout, setNumber), weight: true)),
          ),
          DataCell(
            Text(_metricText(_setForNumber(workout, setNumber), weight: false)),
          ),
        ],
      ],
    );
  }

  @override
  int get rowCount => _workouts.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

Set? _setForNumber(Workout workout, int setNumber) {
  for (final set in workout.sets) {
    if (set.setNumber == setNumber) return set;
  }
  return null;
}

String _dateLabel(DateTime date) => '${date.month}/${date.day}';

String _metricText(Set? set, {required bool weight}) {
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
