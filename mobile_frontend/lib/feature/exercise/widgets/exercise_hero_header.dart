import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/widgets/detail_hero_header.dart';
import 'package:mobile_frontend/common/widgets/metric_pill.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:mobile_frontend/feature/routine/data/routine_exercise_service.dart';
import 'package:mobile_frontend/feature/routine/routine_last_session_format.dart';

class ExerciseHeroHeader extends StatelessWidget {
  final Routine routine;
  final RoutineExerciseService routineExerciseService;

  const ExerciseHeroHeader({
    super.key,
    required this.routine,
    required this.routineExerciseService,
  });

  @override
  Widget build(BuildContext context) {
    return DetailHeroHeader(
      eyebrowLabel: 'ACTIVE ROUTINE',
      title: routine.title,
      metrics: StreamBuilder<List<RoutineExercise>>(
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
              return MetricPillPair(
                leftLabel: 'EXERCISES',
                leftValue: '$n',
                rightLabel: 'LAST SESSION',
                rightValue: formatRoutineLastSessionLabel(last).toUpperCase(),
              );
            },
          );
        },
      ),
    );
  }
}
