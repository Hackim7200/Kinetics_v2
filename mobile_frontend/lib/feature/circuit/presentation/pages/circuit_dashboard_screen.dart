import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/widgets/empty_state_widget.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/feature/circuit/data/repositories/circuit_exercise_repository.dart';
import 'package:mobile_frontend/feature/circuit/data/repositories/circuit_repository.dart';
import 'package:mobile_frontend/feature/circuit/domain/use_cases/circuit_display.dart';
import 'package:mobile_frontend/feature/circuit/presentation/pages/circuit_detail_screen.dart';
import 'package:mobile_frontend/feature/circuit/presentation/pages/create_circuit_screen.dart';
import 'package:mobile_frontend/feature/circuit/presentation/widgets/circuit_list_card.dart';
import 'package:mobile_frontend/feature/circuit/presentation/widgets/create_circuit_card.dart';

class CircuitDashboardScreen extends ConsumerWidget {
  const CircuitDashboardScreen({super.key});

  void _openCreate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const CreateCircuitScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final circuitRepository = ref.watch(circuitRepositoryProvider);
    final circuitExerciseRepository = ref.watch(circuitExerciseRepositoryProvider);

    return Scaffold(
      appBar: const KineticAppBar(),
      body: StreamBuilder(
        stream: circuitRepository.watchCircuits(),
        builder: (context, circuitSnap) {
          if (circuitSnap.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: GoogleFonts.inter(color: cs.error),
              ),
            );
          }

          if (!circuitSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final circuits = circuitSnap.data!;

          if (circuits.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.loop,
              title: 'No circuits yet',
              subtitle:
                  'Create a circuit and add timed exercises from the detail screen.',
              actionLabel: 'Create circuit',
              onAction: () => _openCreate(context),
            );
          }

          return StreamBuilder(
            stream: circuitExerciseRepository.watchAllCircuitExercises(),
            builder: (context, circuitExerciseSnap) {
              final counts = circuitExerciseSnap.hasData
                  ? CircuitDisplay.exerciseCountsByCircuitId(circuitExerciseSnap.data!)
                  : <String, int>{};

              return ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                children: [
                  Text(
                    'CURRENT PROTOCOL',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                      color: cs.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          'ACTIVE\nCIRCUITS',
                          style: GoogleFonts.inter(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.5,
                            height: 1.1,
                            color: cs.primary,
                          ),
                        ),
                      ),
                      Text(
                        '${circuits.length} Total',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: cs.tertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ...circuits.map(
                    (circuit) => Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: CircuitListCard(
                        circuit: circuit,
                        exerciseCount: counts[circuit.id] ?? 0,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => CircuitDetailScreen(
                              circuit: circuit,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  CreateCircuitCard(onTap: () => _openCreate(context)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
