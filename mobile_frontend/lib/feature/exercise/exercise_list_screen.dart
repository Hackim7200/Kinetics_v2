import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/utils/timer_routine_target.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/exercise/models/exercise_ui_mapper.dart';
import 'package:mobile_frontend/feature/routine/data/routine_exercise_service.dart';
import 'package:mobile_frontend/feature/routine/routine_last_session_format.dart';
import 'package:mobile_frontend/feature/exercise/screens/add_exercise_screen.dart';
import 'package:mobile_frontend/feature/routine/screens/edit_routine_screen.dart';
import 'package:mobile_frontend/feature/exercise_analytics/data/workout_log_stats.dart';
import 'package:mobile_frontend/feature/exercise_analytics/exercise_analytics_screen.dart';
import 'package:mobile_frontend/feature/exercise/widgets/add_exercise_button.dart';

class _ExerciseProgressStyle {
  final Color dotColor;
  final Color valueColor;
  final String valueLabel;
  final String caption;
  final Color captionColor;

  const _ExerciseProgressStyle({
    required this.dotColor,
    required this.valueColor,
    required this.valueLabel,
    required this.caption,
    required this.captionColor,
  });
}

/// Change vs last session: negative = decrease (gray), zero = stable (amber), positive = increase (green).
_ExerciseProgressStyle _progressFromDeltaPercent(
  double deltaPercent,
  Color outlineColor,
) {
  const green = Color(0xFF2E7D32);
  const amber = Color(0xFFF59E0B);
  const gray = Color(0xFF6B7280);

  String magnitudeStr(double x) {
    final a = x.abs();
    if ((a - a.round()).abs() < 1e-9) return a.round().toString();
    return a.toStringAsFixed(1);
  }

  if (deltaPercent < 0) {
    return _ExerciseProgressStyle(
      dotColor: gray,
      valueColor: gray,
      valueLabel: '-${magnitudeStr(deltaPercent)}%',
      caption: 'VS LAST SESSION',
      captionColor: gray,
    );
  }

  if (deltaPercent == 0) {
    return _ExerciseProgressStyle(
      dotColor: amber,
      valueColor: amber,
      valueLabel: 'Stable',
      caption: 'VS LAST SESSION',
      captionColor: outlineColor,
    );
  }

  return _ExerciseProgressStyle(
    dotColor: green,
    valueColor: green,
    valueLabel: '+${magnitudeStr(deltaPercent)}%',
    caption: 'VS LAST SESSION',
    captionColor: outlineColor,
  );
}

String _subtitleLine(
  RoutineExercise routineExercise,
  int designIndex,
  Exercise? exercise,
) {
  final sets = routineExercise.targetSets;
  final reps = routineExercise.targetReps?.trim();
  final isTimer = exercise?.type == 'timer';

  if (isTimer) {
    final dir = TimerRoutineTarget.label(routineExercise.timerTarget);
    if (sets != null) {
      return '$sets Sets | Timer · $dir';
    }
    return '— Sets | Timer · $dir';
  }

  if (sets != null && reps != null && reps.isNotEmpty) {
    return '$sets Sets | $reps Reps';
  }
  if (sets != null) {
    return '$sets Sets | —';
  }
  switch (designIndex % 3) {
    case 0:
      return '4 Sets | 8 Reps';
    case 1:
      return '3 Sets | 12 Reps';
    default:
      return '3 Sets | 6 Reps';
  }
}

class ExerciseListScreen extends ConsumerStatefulWidget {
  final Routine routine;

  const ExerciseListScreen({super.key, required this.routine});

  @override
  ConsumerState<ExerciseListScreen> createState() =>
      _ExerciseListScreenState();
}

class _ExerciseListScreenState extends ConsumerState<ExerciseListScreen> {
  late Routine _routine;
  late final RoutineExerciseService _routineExerciseService;

  @override
  void initState() {
    super.initState();
    _routine = widget.routine;
    _routineExerciseService = RoutineExerciseService(ref.read(appDatabaseProvider));
  }

  Future<void> _openEdit() async {
    final updated = await Navigator.of(context).push<Routine>(
      MaterialPageRoute(
        builder: (_) => EditRoutineScreen(routine: _routine),
      ),
    );
    if (updated != null && mounted) setState(() => _routine = updated);
  }

  Future<void> _addExercise() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => AddExerciseScreen(
          routineId: _routine.id,
          routineName: _routine.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: KineticAppBar(
        showBackButton: true,
        actions: [
          GestureDetector(
            onTap: _openEdit,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.edit_outlined, color: cs.primary, size: 22),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
        children: [
          _HeroHeader(routine: _routine, routineExerciseService: _routineExerciseService),
          const SizedBox(height: 40),
          _ExerciseList(
            routineId: _routine.id,
            routineName: _routine.name,
            routineExerciseService: _routineExerciseService,
            onAddExercise: _addExercise,
          ),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final Routine routine;
  final RoutineExerciseService routineExerciseService;

  const _HeroHeader({required this.routine, required this.routineExerciseService});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACTIVE ROUTINE',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
            color: cs.tertiary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          routine.name.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            letterSpacing: -2,
            height: 1.0,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<RoutineExercise>>(
          stream: routineExerciseService.watchForRoutine(routine.id),
          builder: (context, routineExerciseSnap) {
            final routineExercises =
                routineExerciseSnap.data ?? const <RoutineExercise>[];
            final n = routineExercises.length;
            return StreamBuilder<List<WorkoutLog>>(
              stream: routineExerciseService.watchAllWorkoutLogs(),
              builder: (context, logSnap) {
                DateTime? last;
                if (routineExercises.isNotEmpty && logSnap.hasData) {
                  final map = RoutineExerciseService.lastPerformedByRoutineId(
                    routineExercises: routineExercises,
                    logs: logSnap.data!,
                  );
                  last = map[routine.id];
                }
                return Row(
                  children: [
                    _MetricPill(label: 'EXERCISES', value: '$n'),
                    Container(
                      width: 1,
                      height: 32,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      color: cs.surfaceContainerHighest,
                    ),
                    _MetricPill(
                      label: 'LAST SESSION',
                      value: formatRoutineLastSessionLabel(last).toUpperCase(),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _ExerciseList extends StatelessWidget {
  final String routineId;
  final String routineName;
  final RoutineExerciseService routineExerciseService;
  final VoidCallback onAddExercise;

  const _ExerciseList({
    required this.routineId,
    required this.routineName,
    required this.routineExerciseService,
    required this.onAddExercise,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return StreamBuilder<List<RoutineExercise>>(
      stream: routineExerciseService.watchForRoutine(routineId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            'Could not load exercises',
            style: GoogleFonts.inter(color: cs.error),
          );
        }
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final routineExercises = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: cs.surfaceContainerHighest),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EXERCISES',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${routineExercises.length} Total',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: cs.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (routineExercises.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'No exercises yet. Use the button below to add one.',
                  style: GoogleFonts.inter(fontSize: 14, color: cs.outline),
                ),
              )
            else
              /// List of exercises for a routine
              FutureBuilder<Map<String, Exercise>>(
                key: ValueKey(routineExercises.map((e) => e.id).join(',')),
                future: routineExerciseService.exerciseMapForIds(
                  routineExercises.map((re) => re.exerciseId).toSet(),
                ),
                builder: (context, exSnap) {
                  if (!exSnap.hasData) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final map = exSnap.data!;
                  return StreamBuilder<List<WorkoutLog>>(
                    stream: routineExerciseService.watchAllWorkoutLogs(),
                    builder: (context, logSnap) {
                      final logs = logSnap.data ?? const <WorkoutLog>[];
                      return Column(
                        children: [
                          for (var i = 0; i < routineExercises.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _ExerciseTile(
                                exercise: map[routineExercises[i].exerciseId],
                                routineExercise: routineExercises[i],
                                listIndex: i,
                                routineName: routineName,
                                trainingLoadChangePercent:
                                    map[routineExercises[i].exerciseId]?.type != 'timer'
                                    ? WorkoutLogStats.trainingLoadChangePercentForLatestSession(
                                        routineExercises[i].id,
                                        logs,
                                      )
                                    : null,
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            AddExerciseButton(onTap: onAddExercise),
          ],
        );
      },
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final Exercise? exercise;
  final RoutineExercise routineExercise;
  final int listIndex;
  final String routineName;
  final double? trainingLoadChangePercent;

  const _ExerciseTile({
    required this.exercise,
    required this.routineExercise,
    required this.listIndex,
    required this.routineName,
    this.trainingLoadChangePercent,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final name = exercise?.name ?? 'Unknown exercise';
    final delta = trainingLoadChangePercent;
    final subtitle = _subtitleLine(routineExercise, listIndex, exercise);
    final progress = delta != null
        ? _progressFromDeltaPercent(delta, cs.outline)
        : null;

    return Material(
      color: cs.surfaceContainerLowest,
      child: InkWell(
        onTap: () {
          final detailExercise = exerciseForWorkoutDetail(
            exercise,
            routineExercise,
            listIndex,
          );
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ExerciseAnalyticsScreen(
                exercise: detailExercise,
                routineLink: routineExercise,
                storedExercise: exercise,
                routineName: routineName,
                listIndex: listIndex,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        height: 1.2,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: cs.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (progress != null) ...[
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: progress.dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          progress.valueLabel,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: progress.valueColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      progress.caption,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: progress.captionColor,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  final String label;
  final String value;

  const _MetricPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            color: cs.outline,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}
