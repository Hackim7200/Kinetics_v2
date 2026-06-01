import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/routine/data/routine_exercise_service.dart';
import 'package:mobile_frontend/feature/routine/data/routine_service.dart';

class EditRoutineScreen extends ConsumerStatefulWidget {
  final Routine routine;

  const EditRoutineScreen({super.key, required this.routine});

  @override
  ConsumerState<EditRoutineScreen> createState() => _EditRoutineScreenState();
}

class _EditRoutineScreenState extends ConsumerState<EditRoutineScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final RoutineService _service;
  late final RoutineExerciseService _routineExerciseService;
  bool _saving = false;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    final db = ref.read(appDatabaseProvider);
    _service = RoutineService(db);
    _routineExerciseService = RoutineExerciseService(db);
    final r = widget.routine;
    _nameController = TextEditingController(text: r.name);
    _descriptionController = TextEditingController(text: r.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _saving = true);

    try {
      final desc = _descriptionController.text.trim();

      final updated = widget.routine.copyWith(
        name: name,
        description: Value(desc.isEmpty ? null : desc),
      );
      await _service.saveRoutine(updated);
      if (mounted) Navigator.of(context).pop(updated);
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

  Future<void> _confirmAndDeleteRoutine() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Routine'),
        content: Text(
          'Delete "${widget.routine.name}"? This cannot be undone.',
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
      await _service.deleteRoutine(widget.routine);
      if (!mounted) return;
      nav.pop();
      nav.pop();
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

    return Scaffold(
      appBar: KineticAppBar(
        title: 'EDIT ROUTINE',
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
                color: (_saving || _deleting) ? appTheme.outline : appTheme.primary,
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
            widget.routine.name.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
              height: 1.0,
              color: appTheme.onSurface,
            ),
          ),
          const SizedBox(height: 48),
          _buildField('ROUTINE NAME', 'e.g. Push Day', _nameController),
          const SizedBox(height: 32),
          _buildField(
            'DESCRIPTION',
            'e.g. Chest, Shoulders, Triceps',
            _descriptionController,
          ),
          const SizedBox(height: 32),
          _buildDerivedExerciseCount(appTheme),
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
                  : _confirmAndDeleteRoutine,
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
                      'Delete Routine',
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

  Widget _buildDerivedExerciseCount(ColorScheme appTheme) {
    return StreamBuilder<List<RoutineExercise>>(
      stream: _routineExerciseService.watchForRoutine(widget.routine.id),
      builder: (context, snapshot) {
        final n = snapshot.data?.length ?? 0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EXERCISES',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: appTheme.tertiary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$n',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: appTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Based on exercises linked to this routine. Add or remove them from the routine screen.',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.4,
                color: appTheme.outline,
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
  }) {
    final appTheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: appTheme.tertiary,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: appTheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: appTheme.outlineVariant,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: appTheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: appTheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: appTheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.only(bottom: 12),
          ),
        ),
      ],
    );
  }
}
