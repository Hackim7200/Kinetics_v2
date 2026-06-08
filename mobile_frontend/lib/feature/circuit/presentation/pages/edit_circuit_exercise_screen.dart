import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/feature/circuit/data/repositories/circuit_exercise_repository.dart';
import 'package:mobile_frontend/feature/circuit/domain/entities/circuit_exercise.dart';
import 'package:mobile_frontend/feature/circuit/domain/use_cases/validate_circuit_exercise.dart';

class EditCircuitExerciseScreen extends ConsumerStatefulWidget {
  final CircuitExercise link;
  final String? circuitName;

  const EditCircuitExerciseScreen({
    super.key,
    required this.link,
    this.circuitName,
  });

  @override
  ConsumerState<EditCircuitExerciseScreen> createState() =>
      _EditCircuitExerciseScreenState();
}

class _EditCircuitExerciseScreenState
    extends ConsumerState<EditCircuitExerciseScreen> {
  late final TextEditingController _nameController;
  bool _saving = false;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.link.title);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (ValidateCircuitExercise.nameError(name) != null) return;

    setState(() => _saving = true);

    try {
      await ref.read(circuitExerciseRepositoryProvider).updateExerciseInCircuit(
            link: widget.link,
            title: name,
          );
      if (mounted) Navigator.of(context).pop();
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

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Exercise'),
        content: Text(
          'Remove "${widget.link.title}" from this circuit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('REMOVE'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);
    try {
      await ref
          .read(circuitExerciseRepositoryProvider)
          .deleteExerciseEntry(widget.link);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove: $e')),
        );
        setState(() => _deleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final circuitLabel = widget.circuitName?.trim();

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
            'EXERCISE',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
              height: 1.0,
              color: cs.onSurface,
            ),
          ),
          if (circuitLabel != null && circuitLabel.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              circuitLabel.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: cs.outline,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'Exercise duration applies to all exercises. Edit the circuit to change it.',
            style: GoogleFonts.inter(
              fontSize: 13,
              height: 1.4,
              color: cs.outline,
            ),
          ),
          const SizedBox(height: 24),
          _buildField('EXERCISE NAME', 'e.g. Jump Squats', _nameController),
          const SizedBox(height: 40),
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
              onPressed: (_saving || _deleting) ? null : _confirmDelete,
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
                      'Remove from circuit',
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

  Widget _buildField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
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
