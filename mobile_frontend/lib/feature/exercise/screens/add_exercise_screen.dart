import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/utils/training_target_input.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/feature/exercise/models/exercise.dart';
import 'package:mobile_frontend/feature/exercise/widgets/exercise_type_selector.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  ExerciseType _selectedType = ExerciseType.strength;
  final _nameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _durationController = TextEditingController();

  void _trySubmit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter an exercise name.')),
      );
      return;
    }
    if (_selectedType == ExerciseType.strength) {
      final err = TrainingTargetInput.validateStrengthTargets(
        setsRaw: _setsController.text,
        repsRaw: _repsController.text,
      );
      if (err != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
        return;
      }
    }
    if (_selectedType == ExerciseType.timer) {
      final err = TrainingTargetInput.validateTargetSetsOnly(
        setsRaw: _setsController.text,
      );
      if (err != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
        return;
      }
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: KineticAppBar(
        title: 'NEW EXERCISE',
        showBackButton: true,
        actions: [
          GestureDetector(
            onTap: _trySubmit,
            child: Text(
              'SAVE',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: cs.primary,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        children: [
          Text(
            'ADD',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 3,
              color: cs.tertiary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'NEW EXERCISE',
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
              height: 1.0,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 40),

          // Exercise Name
          _buildField('EXERCISE NAME', 'e.g. Bench Press', _nameController),
          const SizedBox(height: 32),

          // Exercise Type Selector
          Text(
            'EXERCISE TYPE',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: cs.tertiary,
            ),
          ),
          const SizedBox(height: 12),
          ExerciseTypeSelector(
            selectedType: _selectedType,
            onChanged: (type) => setState(() => _selectedType = type),
          ),
          const SizedBox(height: 32),

          // Dynamic fields based on type
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _selectedType == ExerciseType.strength
                ? _buildStrengthFields()
                : _buildTimerFields(),
          ),
          const SizedBox(height: 48),

          // Save Button
          _buildSaveButton(cs),
        ],
      ),
    );
  }

  Widget _buildStrengthFields() {
    return Column(
      key: const ValueKey('strength'),
      children: [
        Row(
          children: [
            Expanded(
              child: _buildField(
                'SETS',
                '1-${TrainingTargetInput.maxSets}',
                _setsController,
                keyboardType: TextInputType.number,
                inputFormatters: TrainingTargetInput.setsFieldFormatters,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildField(
                'REPS',
                '1-${TrainingTargetInput.maxReps}',
                _repsController,
                keyboardType: TextInputType.number,
                inputFormatters: TrainingTargetInput.repsFieldFormatters,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildField(
          'WEIGHT (KG)',
          'e.g. 100',
          _weightController,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildTimerFields() {
    return Column(
      key: const ValueKey('timer'),
      children: [
        _buildField(
          'DURATION (SEC)',
          'e.g. 60',
          _durationController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 32),
        _buildField(
          'SETS',
          '1-${TrainingTargetInput.maxSets}',
          _setsController,
          keyboardType: TextInputType.number,
          inputFormatters: TrainingTargetInput.setsFieldFormatters,
        ),
      ],
    );
  }

  Widget _buildSaveButton(ColorScheme cs) {
    return Container(
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
          onTap: _trySubmit,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'ADD EXERCISE',
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
