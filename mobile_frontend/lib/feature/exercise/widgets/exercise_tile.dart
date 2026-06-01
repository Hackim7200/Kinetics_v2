import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/utils/timer_routine_target.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:mobile_frontend/feature/exercise/models/exercise_ui_mapper.dart';
import 'package:mobile_frontend/feature/exercise_analytics/exercise_analytics_screen2.dart';

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

String _subtitleLine(RoutineExercise routineExercise, int designIndex) {
  final sets = routineExercise.targetSets;
  final reps = routineExercise.targetReps?.trim();
  final isTimer = routineExercise.type == 'timer';

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

class ExerciseTile extends StatelessWidget {
  final RoutineExercise routineExercise;
  final int listIndex;
  final String routineName;
  final double? trainingLoadChangePercent;

  const ExerciseTile({
    super.key,
    required this.routineExercise,
    required this.listIndex,
    required this.routineName,
    this.trainingLoadChangePercent,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).colorScheme;
    final name = routineExercise.title;
    final delta = trainingLoadChangePercent;
    final subtitle = _subtitleLine(routineExercise, listIndex);
    final progress = delta != null
        ? _progressFromDeltaPercent(delta, appTheme.outline)
        : null;

    return Material(
      color: appTheme.surfaceContainerLowest,
      child: InkWell(
        onTap: () {
          final detailExercise = exerciseForWorkoutDetail(
            routineExercise,
            listIndex,
          );
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ExerciseAnalyticsScreen2(exercise: detailExercise),
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
                        color: appTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: appTheme.tertiary,
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
