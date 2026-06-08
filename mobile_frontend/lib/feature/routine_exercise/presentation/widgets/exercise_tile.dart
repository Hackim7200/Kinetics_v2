import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/feature/routine_exercise/domain/entities/routine_exercise.dart';
import 'package:mobile_frontend/feature/routine_exercise/domain/use_cases/exercise_stats.dart';
import 'package:mobile_frontend/feature/exercise_analytics/presentation/pages/exercise_analytics_screen.dart';

class ExerciseTile extends StatelessWidget {
  final RoutineExercise routineExercise;
  final int listIndex;
  final String routineName;
  final double? trainingLoadChangePercent;
  final VoidCallback? onAnalyticsClosed;

  const ExerciseTile({
    super.key,
    required this.routineExercise,
    required this.listIndex,
    required this.routineName,
    this.trainingLoadChangePercent,
    this.onAnalyticsClosed,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).colorScheme;
    final name = routineExercise.title;
    final delta = trainingLoadChangePercent;
    final subtitle = ExerciseStats.subtitleLine(routineExercise, listIndex);
    final progress = delta != null
        ? ExerciseStats.progressFromDeltaPercent(delta, appTheme.outline)
        : null;

    return Material(
      color: appTheme.surfaceContainerLowest,
      child: InkWell(
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ExerciseAnalyticsScreen2(
                routineExercise: routineExercise,
                listIndex: listIndex,
                routineName: routineName,
              ),
            ),
          );
          onAnalyticsClosed?.call();
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
