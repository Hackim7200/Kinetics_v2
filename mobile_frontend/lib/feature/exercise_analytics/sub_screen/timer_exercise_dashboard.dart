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
import 'package:mobile_frontend/feature/exercise_analytics/widgets/timer_add_timed_set_sheet.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/timer_session_log_table.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/workout_detail_timer_history_table.dart';

/// Timer session: log each set via bottom-sheet stopwatch; table shows **SET** + **DURATION** (`mm:ss`).
/// Matches [WeightExerciseDashboard] layout (notes, table, progress graph, stats, history).
class TimerExerciseDashboard extends ConsumerStatefulWidget {
  final Exercise exercise;

  /// Bumps [TechniqueNotesCard] key so saved notes refetch from Drift.
  final int techniqueNotesRefreshToken;

  const TimerExerciseDashboard({
    super.key,
    required this.exercise,
    this.techniqueNotesRefreshToken = 0,
  });

  @override
  ConsumerState<TimerExerciseDashboard> createState() =>
      _TimerExerciseDashboardState();
}

class _TimerExerciseDashboardState
    extends ConsumerState<TimerExerciseDashboard> {
  late List<SetEntry> _sets;
  bool _workoutFinished = false;
  bool _sessionReady = true;
  bool _addingSet = false;
  String? _workoutLogId;
  List<double> _sessionTotalSecondsSeries = [];
  List<String> _graphXLabels = [];
  List<WorkoutLog> _historySessions = [];
  int? _maxHoldSecondsLast30Days;
  late final SessionSetsService _sessionSetsService;

  int get _maxSets {
    final n = widget.exercise.sets;
    if (n < TrainingTargetInput.minSets) return TrainingTargetInput.minSets;
    if (n > TrainingTargetInput.maxSets) return TrainingTargetInput.maxSets;
    return n;
  }

  bool get _lastRowComplete =>
      _sets.isNotEmpty && timerSetHasDuration(_sets.last);

  Duration? get _personalBestDuration {
    int? bestSec = _maxHoldSecondsLast30Days;
    final todayMax = maxTimeElapsedInSession(_sets);
    if (todayMax != null &&
        todayMax > 0 &&
        (bestSec == null || todayMax > bestSec)) {
      bestSec = todayMax;
    }
    if (bestSec != null && bestSec > 0) {
      return Duration(seconds: bestSec);
    }
    for (final w in _historySessions) {
      final m = maxTimeElapsedInSession(w.sets);
      if (m != null && m > 0 && (bestSec == null || m > bestSec)) bestSec = m;
    }
    if (bestSec == null || bestSec < 1) return null;
    return Duration(seconds: bestSec);
  }

  String get _latestSessionTotalDisplay {
    if (_sessionTotalSecondsSeries.isEmpty) return '—';
    final sec = _sessionTotalSecondsSeries.last.round();
    if (sec <= 0) return '—';
    return formatTimerMinutesSeconds(Duration(seconds: sec));
  }

  String get _sessionTotalChangeDisplay {
    if (_historySessions.length < 2) return '—';
    final totals = _historySessions
        .map(
          (w) =>
              w.totalTrainingLoad ??
              totalTimeElapsedForSets(w.sets).toDouble(),
        )
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

  String get _maxTimeLast30DaysDisplay {
    final sec = _maxHoldSecondsLast30Days;
    if (sec == null || sec < 1) return '—';
    return formatTimerMinutesSeconds(Duration(seconds: sec));
  }

  @override
  void initState() {
    super.initState();
    _sessionSetsService = SessionSetsService(ref.read(appDatabaseProvider));
    _sets = [const SetEntry(setNumber: 1)];
    final linkId = widget.exercise.routineExerciseId;
    if (linkId != null) {
      _sessionReady = false;
      _loadPersistedSession(linkId);
      _loadHistory(linkId);
    }
  }

  Future<void> _loadHistory(String routineExerciseId) async {
    try {
      final sessions = await _sessionSetsService.recentWorkoutsWithSets(
        routineExerciseId,
        limit: 20,
      );
      final maxHold = await _sessionSetsService.maxTimerHoldSecondsLastDays(
        routineExerciseId,
        days: 30,
      );
      if (!mounted) return;
      final graphSlice = sessions.length > 7
          ? sessions.sublist(sessions.length - 7)
          : sessions;
      setState(() {
        _historySessions = sessions;
        _maxHoldSecondsLast30Days = maxHold;
        _sessionTotalSecondsSeries = graphSlice
            .map((w) => totalTimeElapsedForSets(w.sets).toDouble())
            .toList();
        _graphXLabels = graphSlice
            .map((w) => '${w.date.month}/${w.date.day}')
            .toList();
      });
    } catch (e, st) {
      debugPrint('Timer history load failed: $e $st');
    }
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
              _sets.single.timeElapsed == null;
          if (stillPristineFirstRow) {
            _sets = loaded;
          }
        }
        _workoutFinished = timerSessionLooksComplete(_sets, _maxSets);
        _sessionReady = true;
      });
    } catch (e, st) {
      debugPrint('Timer session load failed: $e $st');
      if (mounted) setState(() => _sessionReady = true);
    }
  }

  Future<void> _onPrimaryAction() async {
    if (!mounted) return;
    if (!_sessionReady || _workoutFinished || _addingSet) return;

    if (timerSessionLooksComplete(_sets, _maxSets)) {
      _finishWorkout(logId: _workoutLogId);
      return;
    }

    if (_lastRowComplete) return;

    final logId = _workoutLogId;
    if (logId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Open this exercise from a routine to save timed sets.',
          ),
        ),
      );
      return;
    }

    final setNumber = _sets.last.setNumber;

    setState(() => _addingSet = true);
    final duration = await showTimerAddTimedSetSheet(
      context: context,
      exercise: widget.exercise,
      setNumber: setNumber,
      maxSets: _maxSets,
      personalBestDuration: _personalBestDuration,
    );

    if (!mounted) {
      return;
    }
    if (duration == null || duration.inSeconds < 1) {
      setState(() => _addingSet = false);
      return;
    }

    final index = _sets.length - 1;
    final entry = _sets[index].copyWith(
      timeElapsed: duration.inSeconds,
      isCompleted: true,
    );

    try {
      final saved = await _sessionSetsService.persistSet(logId, entry);
      if (!mounted) return;

      if (setNumber < _maxSets) {
        final nextNumber = setNumber + 1;
        final newRow = await _sessionSetsService.persistSet(
          logId,
          SetEntry(setNumber: nextNumber),
        );
        if (!mounted) return;
        setState(() {
          _sets[index] = saved;
          _sets.add(newRow);
          _addingSet = false;
        });
      } else {
        setState(() {
          _sets[index] = saved;
          _addingSet = false;
        });
      }
    } catch (e, st) {
      debugPrint('Timer persist failed: $e $st');
      if (mounted) setState(() => _addingSet = false);
    }
  }

  void _finishWorkout({String? logId}) {
    setState(() => _workoutFinished = true);

    void refreshHistory() {
      final rid = widget.exercise.routineExerciseId;
      if (rid != null) _loadHistory(rid);
    }

    if (logId == null) {
      refreshHistory();
      return;
    }

    _sessionSetsService
        .saveWorkoutLogTotalTrainingLoad(logId, _sets)
        .then((_) {
          if (mounted) refreshHistory();
        })
        .catchError((Object e, StackTrace st) {
          debugPrint('Timer total save failed: $e $st');
          refreshHistory();
        });
  }

  bool get _primaryEnabled {
    if (!_sessionReady || _workoutFinished || _addingSet) return false;
    if (timerSessionLooksComplete(_sets, _maxSets)) return true;
    return !timerSetHasDuration(_sets.last);
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
        TimerSessionLogTable(
          sets: _sets,
          workoutFinished: _workoutFinished,
          maxSets: _maxSets,
          primaryButtonEnabled: _primaryEnabled,
          onPrimaryAction: !_sessionReady || _workoutFinished
              ? null
              : _onPrimaryAction,
        ),
        const SizedBox(height: 24),
        ProgressGraph(
          title: 'PROGRESS',
          subtitle: '· total set time (s) · last 7',
          currentValue: _sessionTotalChangeDisplay,
          unit: '%',
          series: _sessionTotalSecondsSeries,
          xLabels: _graphXLabels,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'MAX TIME',
                value: _maxTimeLast30DaysDisplay,
                sublabel: 'last 30 days',
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: StatCard(
                label: 'TRAINING LOAD',
                value: _latestSessionTotalDisplay,
                sublabel: 'Sum of sets',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        WorkoutDetailTimerHistoryTable(sessions: _historySessions),
      ],
    );
  }
}
