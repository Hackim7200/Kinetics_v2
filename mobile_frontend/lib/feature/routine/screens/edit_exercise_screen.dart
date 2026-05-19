import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/utils/timer_routine_target.dart';
import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:mobile_frontend/feature/routine/data/routine_exercise_service.dart';

class EditExerciseScreen extends StatefulWidget {
  final AppDatabase db;
  final RoutineExercise link;
  final Exercise exercise;
  final String? routineName;

  const EditExerciseScreen({
    super.key,
    required this.db,
    required this.link,
    required this.exercise,
    this.routineName,
  });

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _setsController;
  late final TextEditingController _repsController;
  late final RoutineExerciseService _linkService =
      RoutineExerciseService(widget.db);
  late String _type;
  late String _timerTarget;
  bool _saving = false;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    final ex = widget.exercise;
    final link = widget.link;
    _nameController = TextEditingController(text: ex.name);
    _type = ex.type == 'timer' ? 'timer' : 'strength';
    _setsController = TextEditingController(
      text: link.targetSets?.toString() ?? '',
    );
    _repsController = TextEditingController(text: link.targetReps ?? '');
    _timerTarget = TimerRoutineTarget.isValid(link.timerTarget)
        ? link.timerTarget!
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
      await _linkService.updateExerciseInRoutine(
        exercise: widget.exercise,
        link: widget.link,
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
      await _linkService.deleteExerciseEntry(
        link: widget.link,
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
    final cs = Theme.of(context).colorScheme;
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
                color: (_saving || _deleting) ? cs.outline : cs.primary,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        children: [
          Text(
            'UPDATE',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 3,
              color: cs.tertiary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.exercise.name.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
              height: 1.0,
              color: cs.onSurface,
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
                color: cs.outline,
              ),
            ),
          ],
          const SizedBox(height: 48),
          _buildField('EXERCISE NAME', 'e.g. Bench Press', _nameController),
          const SizedBox(height: 32),
          _buildTypeSelector(cs),
          if (_type == 'strength') ...[
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildField(
                    'TARGET SETS',
                    '1-${TrainingTargetInput.maxSets}',
                    _setsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: TrainingTargetInput.setsFieldFormatters,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildField(
                    'TARGET REPS',
                    '1-${TrainingTargetInput.maxReps}',
                    _repsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: TrainingTargetInput.repsFieldFormatters,
                  ),
                ),
              ],
            ),
          ],
          if (_type == 'timer') ...[
            const SizedBox(height: 32),
            _buildField(
              'TARGET SETS',
              '1-${TrainingTargetInput.maxSets}',
              _setsController,
              keyboardType: TextInputType.number,
              inputFormatters: TrainingTargetInput.setsFieldFormatters,
            ),
            const SizedBox(height: 32),
            _buildTimerTargetSelector(cs),
          ],
          const SizedBox(height: 48),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [cs.primary, cs.primaryContainer],
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
                              color: cs.onPrimary,
                            ),
                          )
                        : Text(
                            'SAVE CHANGES',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 3,
                              color: cs.onPrimary,
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
                        color: cs.error,
                      ),
                    )
                  : Text(
                      'Delete Exercise',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: cs.error,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerTargetSelector(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TARGET',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: cs.tertiary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _TypeOption(
                label: 'Increase',
                selected: _timerTarget == TimerRoutineTarget.increase,
                onTap: () =>
                    setState(() => _timerTarget = TimerRoutineTarget.increase),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _TypeOption(
                label: 'Decrease',
                selected: _timerTarget == TimerRoutineTarget.decrease,
                onTap: () =>
                    setState(() => _timerTarget = TimerRoutineTarget.decrease),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeSelector(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TYPE',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: cs.tertiary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _TypeOption(
                label: 'Strength',
                selected: _type == 'strength',
                onTap: () => setState(() => _type = 'strength'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _TypeOption(
                label: 'Timer',
                selected: _type == 'timer',
                onTap: () => setState(() => _type = 'timer'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: cs.tertiary,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: cs.outlineVariant,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: cs.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.only(bottom: 12),
          ),
        ),
      ],
    );
  }
}

class _TypeOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected
                    ? cs.primary
                    : cs.outlineVariant.withValues(alpha: 0.3),
                width: selected ? 2 : 1,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Center(
              child: Text(
                label.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: selected ? cs.onSurface : cs.outline,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
