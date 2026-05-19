import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/exercise_analytics/data/exercise_techniques_service.dart';

/// Shows saved technique notes from Drift when non-empty.
class TechniqueNotesCard extends ConsumerStatefulWidget {
  final String exerciseId;

  const TechniqueNotesCard({super.key, required this.exerciseId});

  @override
  ConsumerState<TechniqueNotesCard> createState() =>
      _TechniqueNotesCardState();
}

class _TechniqueNotesCardState extends ConsumerState<TechniqueNotesCard> {
  late final Future<String?> _notesFuture;

  @override
  void initState() {
    super.initState();
    _notesFuture = ExerciseTechniquesService(ref.read(appDatabaseProvider))
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
