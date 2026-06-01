import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/utils/timer_routine_target.dart';
import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/exercise/widgets/exercise_form_fields.dart';
import 'package:mobile_frontend/feature/exercise/widgets/timer_exercise_fields.dart';
import 'package:mobile_frontend/feature/routine/data/routine_exercise_service.dart';

/// Full-screen form to add an exercise to a routine (matches [CreateRoutineScreen] layout).
class AddExerciseScreen extends ConsumerStatefulWidget {
  final String routineId;
  final String? routineName;

  const AddExerciseScreen({
    super.key,
    required this.routineId,
    this.routineName,
  });

  @override
  ConsumerState<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends ConsumerState<AddExerciseScreen> {
  final _nameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  late final RoutineExerciseService _routineExerciseService;

  @override
  void initState() {
    super.initState();
    _routineExerciseService = RoutineExerciseService(
      ref.read(appDatabaseProvider),
    );
  }

  String _type = 'strength';
  String _timerTarget = TimerRoutineTarget.increase;
  bool _saving = false;

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
      await _routineExerciseService.addExerciseToRoutine(
        routineId: widget.routineId,
        title: name,
        type: _type,
        targetSets: _type == 'strength' || _type == 'timer'
            ? int.parse(_setsController.text.trim())
            : null,
        targetReps: _type == 'strength' ? _repsController.text.trim() : null,
        timerTarget: _type == 'timer' ? _timerTarget : null,
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add exercise: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).colorScheme;
    final routineLabel = widget.routineName?.trim();

    return Scaffold(
      appBar: KineticAppBar(
        title: 'NEW EXERCISE',
        showBackButton: true,
        actions: [
          GestureDetector(
            onTap: _saving ? null : _save,
            child: Text(
              'SAVE',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: _saving ? appTheme.outline : appTheme.primary,
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
            'EXERCISE',
            style: GoogleFonts.inter(
              fontSize: 36,
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
          ExerciseTypeSelector(
            selectedType: _type,
            onTypeChanged: (type) => setState(() => _type = type),
          ),
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
                onTap: _saving ? null : _save,
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
                            'ADD EXERCISE',
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
        ],
      ),
    );
  }
}
