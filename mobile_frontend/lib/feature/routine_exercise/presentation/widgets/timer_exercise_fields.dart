import 'package:flutter/material.dart';
import 'package:mobile_frontend/common/utils/timer_routine_target.dart';
import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/feature/routine_exercise/presentation/widgets/exercise_form_fields.dart';

/// Target sets and increase/decrease direction for timer exercises in add/edit forms.
class TimerExerciseFields extends StatelessWidget {
  final TextEditingController setsController;
  final String timerTarget;
  final ValueChanged<String> onTimerTargetChanged;

  const TimerExerciseFields({
    super.key,
    required this.setsController,
    required this.timerTarget,
    required this.onTimerTargetChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExerciseFormField(
          label: 'TARGET SETS',
          hint: '1-${TrainingTargetInput.maxSets}',
          controller: setsController,
          keyboardType: TextInputType.number,
          inputFormatters: TrainingTargetInput.setsFieldFormatters,
        ),
        const SizedBox(height: 32),
        const ExerciseFormSectionLabel(label: 'TARGET'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ExerciseFormOption(
                label: 'Increase',
                selected: timerTarget == TimerRoutineTarget.increase,
                onTap: () => onTimerTargetChanged(TimerRoutineTarget.increase),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ExerciseFormOption(
                label: 'Decrease',
                selected: timerTarget == TimerRoutineTarget.decrease,
                onTap: () => onTimerTargetChanged(TimerRoutineTarget.decrease),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
