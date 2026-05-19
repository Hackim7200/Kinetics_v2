import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:mobile_frontend/feature/workout/data/exercise_techniques_service.dart';

/// Shows saved technique notes from Drift when non-empty.
class TechniqueNotesCard extends StatefulWidget {
  final AppDatabase db;
  final String exerciseId;

  const TechniqueNotesCard({
    super.key,
    required this.db,
    required this.exerciseId,
  });

  @override
  State<TechniqueNotesCard> createState() => _TechniqueNotesCardState();
}

class _TechniqueNotesCardState extends State<TechniqueNotesCard> {
  late final Future<String?> _notesFuture;

  @override
  void initState() {
    super.initState();
    _notesFuture = ExerciseTechniquesService(widget.db)
        .storedTechniquesTrimmed(widget.exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return FutureBuilder<String?>(
      future: _notesFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }
        final text = snap.data?.trim();
        if (text == null || text.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            border: Border.all(
              color: cs.outlineVariant.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      cs.surfaceContainerHigh,
                      cs.surfaceContainerHighest,
                    ],
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: cs.outlineVariant.withValues(alpha: 0.35),
                    ),
                  ),
                ),
                child: Text(
                  'TECHNIQUE NOTES',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: cs.tertiary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
