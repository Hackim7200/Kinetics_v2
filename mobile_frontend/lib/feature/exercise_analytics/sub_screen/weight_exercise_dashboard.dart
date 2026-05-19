import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/exercise/models/exercise.dart';
import 'package:mobile_frontend/feature/exercise_analytics/data/session_sets_service.dart';
import 'package:mobile_frontend/feature/exercise_analytics/models/workout_log.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/progress_graph.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/small_stat_card.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/technique_notes_card.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/workout_detail_history_table.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/workout_table.dart';

bool _strengthSetHasValues(SetEntry s) {
  final w = s.weight;
  final r = s.reps;
  if (w == null || w <= 0 || w > 999.5) return false;
  if (r == null ||
      r < TrainingTargetInput.minReps ||
      r > TrainingTargetInput.maxReps) {
    return false;
  }
  return true;
}

/// True when each set index `1..maxSets` appears on exactly one row with valid weight+reps.
///
/// Uses [SetEntry.setNumber] as the source of truth, not list order, so renumbering or
/// extra rows (e.g. set `99`) do not break detection as long as slots `1..maxSets` exist and are complete.
/// Duplicate or missing indices keep the session "in progress" until the data matches.
bool _strengthSessionLooksComplete(List<SetEntry> sets, int maxSets) {
  for (var n = 1; n <= maxSets; n++) {
    final forN = sets.where((s) => s.setNumber == n).toList();
    if (forN.length != 1) return false;
    if (!_strengthSetHasValues(forN.single)) return false;
  }
  return true;
}

/// Strength session grid: one editable row at a time (the latest set).
/// Enter weight and reps, tap **ADD SET** to lock that row and open the next;
/// on the last target set, tap **FINISH WORKOUT** to lock the table.
class WeightExerciseDashboard extends ConsumerStatefulWidget {
  final Exercise exercise;

  /// Bumps [TechniqueNotesCard] key so saved notes refetch from Drift.
  final int techniqueNotesRefreshToken;

  const WeightExerciseDashboard({
    super.key,
    required this.exercise,
    this.techniqueNotesRefreshToken = 0,
  });

  @override
  ConsumerState<WeightExerciseDashboard> createState() =>
      _WeightExerciseDashboardState();
}

class _WeightExerciseDashboardState
    extends ConsumerState<WeightExerciseDashboard> {
  late List<SetEntry> _sets;
  bool _workoutFinished = false;
  bool _sessionReady = true;
  bool _addingSet = false;
  String? _workoutLogId;
  List<double> _trainingLoadSeries = [];
  List<String> _trainingLoadLabels = [];
  List<WorkoutLog> _historySessions = [];
  double? _maxWeightLast30Days;
  late final SessionSetsService _sessionSetsService;
  final GlobalKey<SessionLogTableState> _sessionTableKey =
      GlobalKey<SessionLogTableState>();

  int get _maxSets {
    final n = widget.exercise.sets;
    if (n < TrainingTargetInput.minSets) {
      return TrainingTargetInput.minSets;
    }
    if (n > TrainingTargetInput.maxSets) {
      return TrainingTargetInput.maxSets;
    }
    return n;
  }

  int? get _editableRowIndex {
    if (_workoutFinished || _sets.isEmpty) return null;
    return _sets.length - 1;
  }

  bool get _lastRowComplete =>
      _sets.isNotEmpty && _strengthSetHasValues(_sets.last);

  @override
  void initState() {
    super.initState();
    _sessionSetsService = SessionSetsService(ref.read(appDatabaseProvider));
    _sets = [const SetEntry(setNumber: 1)];
    final linkId = widget.exercise.routineExerciseId;
    if (linkId != null) {
      _sessionReady = false;
      _loadPersistedSession(linkId);
      _loadTrainingLoadHistory(linkId);
    }
  }

  Future<void> _loadTrainingLoadHistory(String routineExerciseId) async {
    try {
      final sessions = await _sessionSetsService.recentWorkoutsWithSets(
        routineExerciseId,
        limit: 20,
      );
      final maxWeight = await _sessionSetsService.maxStrengthWeightLastDays(
        routineExerciseId,
        days: 30,
      );
      if (!mounted) return;
      final graphSlice = sessions.length > 7
          ? sessions.sublist(sessions.length - 7)
          : sessions;
      setState(() {
        _historySessions = sessions;
        _maxWeightLast30Days = maxWeight;
        _trainingLoadSeries = graphSlice
            .map((w) => totalTrainingLoadForSets(w.sets))
            .toList();
        _trainingLoadLabels = graphSlice
            .map((w) => '${w.date.month}/${w.date.day}')
            .toList();
      });
    } catch (e, st) {
      debugPrint('Training load history failed: $e $st');
    }
  }

  String get _todaysTrainingLoadDisplay {
    final v = totalTrainingLoadForSets(_sets);
    if (v <= 0) return '—';
    if (v >= 1000) return v.round().toString();
    if (v == v.roundToDouble()) return v.round().toString();
    return v.toStringAsFixed(1);
  }

  String get _maxWeightLast30DaysDisplay {
    final v = _maxWeightLast30Days;
    if (v == null) return '—';
    if (v >= 1000) return v.round().toString();
    if (v == v.roundToDouble()) return v.round().toString();
    return v.toStringAsFixed(1);
  }

  /// Header for [ProgressGraph]: saved % vs previous session, or derived from last two totals.
  String get _trainingLoadChangeDisplay {
    if (_historySessions.isEmpty) return '—';
    final last = _historySessions.last;
    final saved = last.trainingLoadChangePercent;
    if (saved != null) {
      final sign = saved > 0 ? '+' : '';
      return '$sign${saved.toStringAsFixed(1)}';
    }
    if (_historySessions.length < 2) return '—';
    final totals = _historySessions
        .map((w) => totalTrainingLoadForSets(w.sets))
        .toList();
    final prev = totals[totals.length - 2];
    final cur = totals[totals.length - 1];
    final pct = SessionSetsService.trainingLoadChangePercentVsPrevious(
      cur,
      prev,
    );
    if (pct == null) return '—';
    final sign = pct > 0 ? '+' : '';
    return '$sign${pct.toStringAsFixed(1)}';
  }

  Future<void> _loadPersistedSession(String routineExerciseId) async {
    try {
      final log = await _sessionSetsService.getOrCreateTodaysLog(
        routineExerciseId,
      );
      final loaded = await _sessionSetsService.loadSets(log.id);
      if (!mounted) return;
      setState(() {
        _workoutLogId = log.id;
        if (loaded.isNotEmpty) {
          final stillPristineFirstRow =
              _sets.length == 1 &&
              _sets.single.setNumber == 1 &&
              _sets.single.datastoreId == null &&
              _sets.single.weight == null &&
              _sets.single.reps == null;
          if (stillPristineFirstRow) {
            _sets = loaded;
          }
        }
        _workoutFinished = _strengthSessionLooksComplete(_sets, _maxSets);
        _sessionReady = true;
      });
    } catch (e, st) {
      debugPrint('SessionSetsService load failed: $e $st');
      if (mounted) {
        setState(() => _sessionReady = true);
      }
    }
  }

  void _persistSetRow(int index, SetEntry entry) {
    final logId = _workoutLogId;
    if (logId == null) return;
    _sessionSetsService
        .persistSet(logId, entry)
        .then((updated) {
          if (mounted) setState(() => _sets[index] = updated);
        })
        .catchError((Object e, StackTrace st) {
          debugPrint('SessionSetsService persist failed: $e $st');
        });
  }

  void _onPrimaryAction() {
    _sessionTableKey.currentState?.commitPendingEdits();
    FocusScope.of(context).unfocus();
    // Next frame so any focus-dismiss commits land before we validate / persist.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_lastRowComplete) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enter weight and reps for this set first.'),
          ),
        );
        return;
      }
      if (_sets.length < _maxSets) {
        if (_addingSet) return;
        final nextNumber = _sets.length + 1;
        final logId = _workoutLogId;
        if (logId != null) {
          setState(() => _addingSet = true);
          _persistAndAddSet(logId, nextNumber);
        } else {
          setState(() {
            _sets.add(SetEntry(setNumber: nextNumber));
          });
        }
      } else {
        _finishWorkout(logId: _workoutLogId);
      }
    });
  }

  /// Locks the grid immediately; persists the last row in the background when online.
  void _finishWorkout({String? logId}) {
    final lastIndex = _sets.length - 1;
    final lastEntry = _sets[lastIndex];
    setState(() => _workoutFinished = true);

    void refreshHistory() {
      final rid = widget.exercise.routineExerciseId;
      if (rid != null) {
        _loadTrainingLoadHistory(rid);
      }
    }

    if (logId == null) {
      refreshHistory();
      return;
    }
    _sessionSetsService
        .persistSet(logId, lastEntry)
        .then((saved) async {
          if (!mounted) return;
          final updatedSets = List<SetEntry>.from(_sets);
          updatedSets[lastIndex] = saved;
          setState(() => _sets[lastIndex] = saved);
          try {
            await _sessionSetsService.saveWorkoutLogTotalTrainingLoad(
              logId,
              updatedSets,
            );
          } catch (e, st) {
            debugPrint('SessionSetsService total load save failed: $e $st');
          }
          if (mounted) refreshHistory();
        })
        .catchError((Object e, StackTrace st) {
          debugPrint('SessionSetsService finish persist failed: $e $st');
          refreshHistory();
        });
  }

  Future<void> _persistAndAddSet(String logId, int nextNumber) async {
    try {
      final lastIndex = _sets.length - 1;
      final savedLast = await _sessionSetsService.persistSet(
        logId,
        _sets[lastIndex],
      );
      if (!mounted) return;
      setState(() => _sets[lastIndex] = savedLast);
      final newRow = await _sessionSetsService.persistSet(
        logId,
        SetEntry(setNumber: nextNumber),
      );
      if (!mounted) return;
      setState(() {
        _sets.add(newRow);
        _addingSet = false;
      });
    } catch (e, st) {
      debugPrint('SessionSetsService add set failed: $e $st');
      if (mounted) setState(() => _addingSet = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TechniqueNotesCard(
          key: ValueKey(widget.techniqueNotesRefreshToken),
          exerciseId: widget.exercise.id,
        ),
        const SizedBox(height: 16),
        SessionLogTable(
          key: _sessionTableKey,
          sets: _sets,
          // Keep the active row editable while the log loads; values were
          // showing as "--" for the whole session when this was tied to [_sessionReady].
          editableRowIndex: _editableRowIndex,
          workoutFinished: _workoutFinished,
          maxSets: _maxSets,
          onSetCommitted: (index, entry) {
            setState(() => _sets[index] = entry);
            _persistSetRow(index, entry);
          },
          primaryButtonEnabled:
              _sessionReady && _lastRowComplete && !_addingSet,
          onPrimaryAction: !_sessionReady || _workoutFinished
              ? null
              : _onPrimaryAction,
        ),
        const SizedBox(height: 24),
        ProgressGraph(
          title: 'PROGRESS',
          subtitle: '· last 7 workouts',
          currentValue: _trainingLoadChangeDisplay,
          unit: '%',
          series: _trainingLoadSeries,
          xLabels: _trainingLoadLabels,
        ),

        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'MAX WEIGHT',
                value: _maxWeightLast30DaysDisplay,
                unit: 'KG',
                sublabel: 'last 30 days',
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: StatCard(
                label: 'TRAINING LOAD',
                value: _todaysTrainingLoadDisplay,
                // unit: 'kg×rep',
                sublabel: 'today',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        WorkoutDetailHistoryTable(sessions: _historySessions),
      ],
    );
  }
}
