import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/utils/timer_routine_target.dart';
import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/exercise/widgets/exercise_form_fields.dart';
import 'package:mobile_frontend/feature/exercise/widgets/timer_exercise_fields.dart';
import 'package:mobile_frontend/feature/routine/data/routine_exercise_service.dart';

class EditExerciseScreen extends ConsumerStatefulWidget {
  final RoutineExercise routineExercise;
  final Exercise exercise;
  final String? routineName;

  const EditExerciseScreen({
    super.key,
    required this.routineExercise,
    required this.exercise,
    this.routineName,
  });

  @override
  ConsumerState<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends ConsumerState<EditExerciseScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _setsController;
  late final TextEditingController _repsController;
  late final RoutineExerciseService _routineExerciseService;
  late String _timerTarget;

  String get _type => widget.exercise.type == 'timer' ? 'timer' : 'strength';
  bool _saving = false;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _routineExerciseService = RoutineExerciseService(
      ref.read(appDatabaseProvider),
    );
    final ex = widget.exercise;
    final routineExercise = widget.routineExercise;
    _nameController = TextEditingController(text: ex.name);
    _setsController = TextEditingController(
      text: routineExercise.targetSets?.toString() ?? '',
    );
    _repsController = TextEditingController(
      text: routineExercise.targetReps ?? '',
    );
    _timerTarget = TimerRoutineTarget.isValid(routineExercise.timerTarget)
        ? routineExercise.timerTarget!
        : TimerRoutineTarget.increase;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    if (_type == 'strength') {
      final err = TrainingTargetInput.validateStrengthTargets(
        setsRaw: _setsController.text,
        repsRaw: _repsController.text,
      );
      if (err != null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(err)));
        }
        return;
      }
    }
    if (_type == 'timer') {
      final err = TrainingTargetInput.validateTargetSetsOnly(
        setsRaw: _setsController.text,
      );
      if (err != null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(err)));
        }
        return;
      }
    }

    setState(() => _saving = true);

    try {
      await _routineExerciseService.updateExerciseInRoutine(
        exercise: widget.exercise,
        routineExercise: widget.routineExercise,
        name: name,
        type: _type,
        targetSets: _type == 'strength' || _type == 'timer'
            ? int.parse(_setsController.text.trim())
            : null,
        targetReps: _type == 'strength' ? _repsController.text.trim() : null,
        timerTarget: _type == 'timer' ? _timerTarget : null,
      );
      if (mounted) Navigator.of(context).pop('saved');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmAndDeleteExercise() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Exercise'),
        content: Text(
          'Remove "${widget.exercise.name}" from this routine? '
          'Session history for this exercise will be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);
    try {
      await _routineExerciseService.deleteExerciseEntry(
        routineExercise: widget.routineExercise,
        exercise: widget.exercise,
      );
      if (mounted) Navigator.of(context).pop('deleted');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
        setState(() => _deleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).colorScheme;
    final routineLabel = widget.routineName?.trim();

    return Scaffold(
      appBar: KineticAppBar(
        title: 'EDIT EXERCISE',
        showBackButton: true,
        actions: [
          GestureDetector(
            onTap: (_saving || _deleting) ? null : _save,
            child: Text(
              'SAVE',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: (_saving || _deleting)
                    ? appTheme.outline
                    : appTheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        children: [
          const SizedBox(height: 4),
          Text(
            widget.exercise.name.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
              height: 1.0,
              color: appTheme.onSurface,
            ),
          ),
          if (routineLabel != null && routineLabel.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              routineLabel.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: appTheme.outline,
              ),
            ),
          ],
          const SizedBox(height: 48),
          ExerciseFormField(
            label: 'EXERCISE NAME',
            hint: 'e.g. Bench Press',
            controller: _nameController,
          ),
          const SizedBox(height: 32),
          ExerciseTypeDisplay(type: _type),
          if (_type == 'strength') ...[
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ExerciseFormField(
                    label: 'TARGET SETS',
                    hint: '1-${TrainingTargetInput.maxSets}',
                    controller: _setsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: TrainingTargetInput.setsFieldFormatters,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: ExerciseFormField(
                    label: 'TARGET REPS',
                    hint: '1-${TrainingTargetInput.maxReps}',
                    controller: _repsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: TrainingTargetInput.repsFieldFormatters,
                  ),
                ),
              ],
            ),
          ],
          if (_type == 'timer') ...[
            const SizedBox(height: 32),
            TimerExerciseFields(
              setsController: _setsController,
              timerTarget: _timerTarget,
              onTimerTargetChanged: (value) =>
                  setState(() => _timerTarget = value),
            ),
          ],
          const SizedBox(height: 48),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [appTheme.primary, appTheme.primaryContainer],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (_saving || _deleting) ? null : _save,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: _saving
                        ? SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: appTheme.onPrimary,
                            ),
                          )
                        : Text(
                            'SAVE CHANGES',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 3,
                              color: appTheme.onPrimary,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: (_saving || _deleting)
                  ? null
                  : _confirmAndDeleteExercise,
              child: _deleting
                  ? SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: appTheme.error,
                      ),
                    )
                  : Text(
                      'Delete Exercise',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: appTheme.error,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
