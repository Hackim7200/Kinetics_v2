import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/database/database.dart' as drift;
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/exercise/models/exercise.dart';
import 'package:mobile_frontend/feature/exercise/models/exercise_ui_mapper.dart';
import 'package:mobile_frontend/feature/routine/data/routine_exercise_service.dart';
import 'package:mobile_frontend/feature/exercise/screens/edit_exercise_screen.dart';
import 'package:mobile_frontend/feature/exercise_analytics/sub_screen/timer_exercise_dashboard.dart';
import 'package:mobile_frontend/feature/exercise_analytics/sub_screen/weight_exercise_dashboard.dart';
import 'package:mobile_frontend/feature/exercise_analytics/widgets/technique_notes_editor.dart';

class ExerciseAnalyticsScreen extends ConsumerStatefulWidget {
  final Exercise exercise;

  /// Routine link when opened from a routine (enables edit/delete on workout page).
  final drift.RoutineExercise? routineLink;
  final drift.Exercise? storedExercise;
  final String? routineName;

  /// Passed through [exerciseForWorkoutDetail] when refreshing after edit.
  final int listIndex;

  const ExerciseAnalyticsScreen({
    super.key,
    required this.exercise,
    this.routineLink,
    this.storedExercise,
    this.routineName,
    this.listIndex = 0,
  });

  @override
  ConsumerState<ExerciseAnalyticsScreen> createState() =>
      _ExerciseAnalyticsScreenState();
}

class _ExerciseAnalyticsScreenState
    extends ConsumerState<ExerciseAnalyticsScreen> {
  late final RoutineExerciseService _routineExerciseService;
  late Exercise _exercise;
  int _techniqueNotesRefreshToken = 0;

  bool get _canEditFromRoutine =>
      widget.routineLink != null && widget.storedExercise != null;

  @override
  void initState() {
    super.initState();
    _routineExerciseService = RoutineExerciseService(ref.read(appDatabaseProvider));
    _exercise = widget.exercise;
  }

  Future<void> _onTechniqueNotesPressed() async {
    final ok = await showTechniqueNotesEditor(context, _exercise.id);
    if (ok && mounted) {
      setState(() => _techniqueNotesRefreshToken++);
    }
  }

  Future<void> _refreshExerciseFromStore() async {
    final link = widget.routineLink;
    final stored = widget.storedExercise;
    if (link == null || stored == null) return;

    try {
      final routineExercises = await _routineExerciseService
          .routineExercisesForRoutine(link.routineId);
      final linkRow = routineExercises
          .where((re) => re.id == link.id)
          .firstOrNull;
      final exercises = await _routineExerciseService.exerciseMapForIds({stored.id});
      final exerciseRow = exercises[stored.id];
      if (!mounted || linkRow == null || exerciseRow == null) return;
      setState(() {
        _exercise = exerciseForWorkoutDetail(
          exerciseRow,
          linkRow,
          widget.listIndex,
        );
      });
    } catch (_) {
      // Keep current session UI if refresh fails.
    }
  }

  Future<void> _openEditExercise() async {
    if (!_canEditFromRoutine) return;
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => EditExerciseScreen(
          routineExercise: widget.routineLink!,
          exercise: widget.storedExercise!,
          routineName: widget.routineName,
        ),
      ),
    );
    if (!mounted) return;
    if (result == 'deleted') {
      Navigator.of(context).pop();
      return;
    }
    if (result == 'saved') {
      await _refreshExerciseFromStore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercise = _exercise;
    final cs = Theme.of(context).colorScheme;

    final actions = <Widget>[];
    if (_canEditFromRoutine) {
      actions.add(
        IconButton(
          tooltip: 'Edit exercise',
          onPressed: _openEditExercise,
          icon: Icon(Icons.edit_outlined, color: cs.onSurface),
        ),
      );
    }
    if (exercise.isStrength || exercise.isTimer) {
      actions.add(
        IconButton(
          tooltip: 'Technique notes',
          onPressed: _onTechniqueNotesPressed,
          icon: Icon(Icons.edit_note, color: cs.onSurface),
        ),
      );
    }

    return Scaffold(
      appBar: KineticAppBar(
        showBackButton: true,
        actions: actions.isEmpty ? null : actions,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  'CURRENT SESSION',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                    color: cs.tertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  exercise.name.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.5,
                    height: 1.0,
                    color: cs.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          if (exercise.isStrength)
            WeightExerciseDashboard(
              exercise: exercise,
              techniqueNotesRefreshToken: _techniqueNotesRefreshToken,
            )
          else
            TimerExerciseDashboard(
              exercise: exercise,
              techniqueNotesRefreshToken: _techniqueNotesRefreshToken,
            ),
        ],
      ),
    );
  }
}
