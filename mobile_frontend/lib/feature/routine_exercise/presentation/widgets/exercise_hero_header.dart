import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/widgets/detail_hero_header.dart';
import 'package:mobile_frontend/common/widgets/metric_pill.dart';
import 'package:mobile_frontend/feature/routine/domain/entities/routine.dart';
import 'package:mobile_frontend/feature/routine/domain/use_cases/routine_display.dart';
import 'package:mobile_frontend/feature/routine_exercise/data/repositories/routine_exercise_repository.dart';
import 'package:mobile_frontend/feature/routine_exercise/domain/entities/routine_exercise.dart';
import 'package:mobile_frontend/feature/routine_exercise/domain/use_cases/exercise_stats.dart';

class ExerciseHeroHeader extends StatelessWidget {
  final Routine routine;
  final RoutineExerciseRepository routineExerciseRepository;

  const ExerciseHeroHeader({
    super.key,
    required this.routine,
    required this.routineExerciseRepository,
  });

  @override
  Widget build(BuildContext context) {
    return DetailHeroHeader(
      eyebrowLabel: 'ACTIVE ROUTINE',
      title: routine.title,
      metrics: StreamBuilder<List<RoutineExercise>>(
        stream: routineExerciseRepository.watchForRoutine(routine.id),
        builder: (context, routineExerciseSnap) {
          final routineExercises =
              routineExerciseSnap.data ?? const <RoutineExercise>[];
          final exerciseCount = routineExercises.length;
          return StreamBuilder(
            stream: routineExerciseRepository.watchAllExerciseSessionLogs(),
            builder: (context, logSnap) {
              DateTime? last;
              if (routineExercises.isNotEmpty && logSnap.hasData) {
                final map = RoutineExerciseMetrics.lastPerformedByRoutineId(
                  routineExercises: routineExercises,
                  logs: logSnap.data!,
                );
                last = map[routine.id];
              }
              return MetricPillPair(
                leftLabel: 'EXERCISES',
                leftValue: '$exerciseCount',
                rightLabel: 'LAST SESSION',
                rightValue: RoutineDisplay.formatLastSessionLabel(last)
                    .toUpperCase(),
              );
            },
          );
        },
      ),
    );
  }
}
