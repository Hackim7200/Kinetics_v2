import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/feature/circuit/data/repositories/circuit_repository.dart';
import 'package:mobile_frontend/feature/circuit/domain/use_cases/validate_circuit_form.dart';

class CreateCircuitScreen extends ConsumerStatefulWidget {
  const CreateCircuitScreen({super.key});

  @override
  ConsumerState<CreateCircuitScreen> createState() =>
      _CreateCircuitScreenState();
}

class _CreateCircuitScreenState extends ConsumerState<CreateCircuitScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _roundsController = TextEditingController();
  final _stationSecondsController = TextEditingController();
  final _preStartCountdownController = TextEditingController(text: '10');
  final _restBetweenRoundsController = TextEditingController(text: '30');

  bool _saving = false;
  /// false = follow list order; true = shuffle stations once when Play starts.
  bool _randomizeStationOrder = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _roundsController.dispose();
    _stationSecondsController.dispose();
    _preStartCountdownController.dispose();
    _restBetweenRoundsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final error = ValidateCircuitForm.firstError(
      title: name,
      roundsRaw: _roundsController.text,
      stationDurationRaw: _stationSecondsController.text,
      countdownRaw: _preStartCountdownController.text,
      restRaw: _restBetweenRoundsController.text,
      includeSameForEveryHint: true,
    );
    if (error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
      return;
    }

    setState(() => _saving = true);

    try {
      final circuit = ValidateCircuitForm.buildCircuit(
        id: '',
        title: name,
        randomizeStationOrder: _randomizeStationOrder,
        roundsRaw: _roundsController.text,
        stationDurationRaw: _stationSecondsController.text,
        countdownRaw: _preStartCountdownController.text,
        restRaw: _restBetweenRoundsController.text,
      );
      await ref.read(circuitRepositoryProvider).saveCircuit(circuit);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save circuit: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: KineticAppBar(
        title: 'NEW CIRCUIT',
        showBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        children: [
          Text(
            'CREATE',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 3,
              color: cs.tertiary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'NEW CIRCUIT',
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
              height: 1.0,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 48),
          _buildField('CIRCUIT NAME', 'e.g. HIIT Blast', _nameController),
          const SizedBox(height: 32),
          _buildField(
            'DESCRIPTION (OPTIONAL)',
            'e.g. Metabolic conditioning',
            _descriptionController,
          ),
          const SizedBox(height: 32),
          _buildField(
            'ROUNDS',
            'e.g. 3',
            _roundsController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 32),
          _buildField(
            'EXERCISE DURATION (SECONDS)',
            'e.g. 45 — same for every exercise',
            _stationSecondsController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 32),
          _buildField(
            'STARTING COUNTDOWN (SECONDS)',
            'e.g. 10 — before first exercise; use 0 to skip',
            _preStartCountdownController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 32),
          _buildField(
            'REST BETWEEN ROUNDS (SECONDS)',
            'e.g. 30 — after each full lap when more than one round',
            _restBetweenRoundsController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 32),
          _buildStationOrderSection(cs),
          const SizedBox(height: 32),
          _buildExerciseHint(cs),
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
                              color: cs.onPrimary,
                            ),
                          )
                        : Text(
                            'CREATE CIRCUIT',
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
        ],
      ),
    );
  }

  Widget _buildStationOrderSection(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXERCISE ORDER',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: cs.tertiary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sequential uses your list order. Random shuffles exercises once each time you open Play.',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 1.4,
            color: cs.outline,
          ),
        ),
        const SizedBox(height: 12),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment<bool>(
              value: false,
              label: Text(
                'SEQUENTIAL',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            ButtonSegment<bool>(
              value: true,
              label: Text(
                'RANDOM',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
          selected: {_randomizeStationOrder},
          onSelectionChanged: (Set<bool> selection) {
            setState(() => _randomizeStationOrder = selection.first);
          },
        ),
      ],
    );
  }

  Widget _buildExerciseHint(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXERCISES',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: cs.tertiary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '0',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'After you create this circuit, open it and add exercises. Each exercise uses the work duration above; rest applies between rounds only.',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 1.4,
            color: cs.outline,
          ),
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
