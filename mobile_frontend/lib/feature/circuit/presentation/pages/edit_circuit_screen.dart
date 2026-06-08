import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/feature/circuit/data/repositories/circuit_exercise_repository.dart';
import 'package:mobile_frontend/feature/circuit/data/repositories/circuit_repository.dart';
import 'package:mobile_frontend/feature/circuit/domain/entities/circuit.dart';
import 'package:mobile_frontend/feature/circuit/domain/use_cases/validate_circuit_form.dart';

class EditCircuitScreen extends ConsumerStatefulWidget {
  final Circuit circuit;

  const EditCircuitScreen({super.key, required this.circuit});

  @override
  ConsumerState<EditCircuitScreen> createState() => _EditCircuitScreenState();
}

class _EditCircuitScreenState extends ConsumerState<EditCircuitScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _roundsController;
  late final TextEditingController _durationController;
  late final TextEditingController _preStartCountdownController;
  late final TextEditingController _restBetweenRoundsController;
  bool _saving = false;
  bool _deleting = false;
  late bool _randomizeStationOrder;

  @override
  void initState() {
    super.initState();
    final circuit = widget.circuit;
    _nameController = TextEditingController(text: circuit.title);
    _descriptionController = TextEditingController();
    _roundsController = TextEditingController(
      text: circuit.rounds?.toString() ?? '',
    );
    _durationController = TextEditingController(
      text: circuit.stationDuration?.toString() ?? '',
    );
    _preStartCountdownController = TextEditingController(
      text: circuit.countdown?.toString() ?? '10',
    );
    _restBetweenRoundsController = TextEditingController(
      text: circuit.rest?.toString() ?? '30',
    );
    _randomizeStationOrder = circuit.isRandomised;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _roundsController.dispose();
    _durationController.dispose();
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
      stationDurationRaw: _durationController.text,
      countdownRaw: _preStartCountdownController.text,
      restRaw: _restBetweenRoundsController.text,
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
      final updated = ValidateCircuitForm.buildCircuit(
        id: widget.circuit.id,
        title: name,
        randomizeStationOrder: _randomizeStationOrder,
        roundsRaw: _roundsController.text,
        stationDurationRaw: _durationController.text,
        countdownRaw: _preStartCountdownController.text,
        restRaw: _restBetweenRoundsController.text,
      );
      await ref.read(circuitRepositoryProvider).saveCircuit(updated);
      if (mounted) Navigator.of(context).pop(updated);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmAndDeleteCircuit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Circuit'),
        content: Text(
          'Delete "${widget.circuit.title}"? This cannot be undone.',
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
    final nav = Navigator.of(context);
    try {
      await ref.read(circuitRepositoryProvider).deleteCircuit(widget.circuit);
      if (!mounted) return;
      nav.pop();
      nav.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: $e')),
        );
        setState(() => _deleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final circuitExerciseRepository = ref.read(circuitExerciseRepositoryProvider);

    return Scaffold(
      appBar: KineticAppBar(
        title: 'EDIT CIRCUIT',
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
            widget.circuit.title.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 28,
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
            _durationController,
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
          _buildDerivedExerciseCount(cs, circuitExerciseRepository),
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
              onPressed: (_saving || _deleting) ? null : _confirmAndDeleteCircuit,
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
                      'Delete Circuit',
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

  Widget _buildDerivedExerciseCount(
    ColorScheme cs,
    CircuitExerciseRepository circuitExerciseRepository,
  ) {
    return StreamBuilder(
      stream: circuitExerciseRepository.watchForCircuit(widget.circuit.id),
      builder: (context, snapshot) {
        final exerciseCount = snapshot.data?.length ?? 0;
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
              '$exerciseCount',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Based on exercises linked to this circuit. Add or remove them from the circuit screen.',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.4,
                color: cs.outline,
              ),
            ),
          ],
        );
      },
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
