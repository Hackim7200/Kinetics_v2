import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/widgets/empty_state_widget.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/circuit/circuit_detail_screen.dart';
import 'package:mobile_frontend/feature/circuit/data/circuit_exercise_service.dart';
import 'package:mobile_frontend/feature/circuit/data/circuit_service.dart';
import 'package:mobile_frontend/feature/circuit/screens/create_circuit_screen.dart';
import 'package:mobile_frontend/feature/circuit/widgets/circuit_list_card.dart';
import 'package:mobile_frontend/feature/circuit/widgets/create_circuit_card.dart';

class CircuitDashboardScreen extends ConsumerStatefulWidget {
  const CircuitDashboardScreen({super.key});

  @override
  ConsumerState<CircuitDashboardScreen> createState() =>
      _CircuitDashboardScreenState();
}

class _CircuitDashboardScreenState extends ConsumerState<CircuitDashboardScreen> {
  late final CircuitService _service;
  late final CircuitExerciseService _circuitExerciseService;

  @override
  void initState() {
    super.initState();
    final db = ref.read(appDatabaseProvider);
    _service = CircuitService(db);
    _circuitExerciseService = CircuitExerciseService(db);
  }

  void _openCreate() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const CreateCircuitScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const KineticAppBar(),
      body: StreamBuilder<List<Circuit>>(
        stream: _service.watchCircuits(),
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
              onAction: _openCreate,
            );
          }

          return StreamBuilder<List<CircuitExercise>>(
            stream: _circuitExerciseService.watchAllCircuitExerciseLinks(),
            builder: (context, linkSnap) {
              final counts = linkSnap.hasData
                  ? CircuitExerciseService.exerciseCountsByCircuitId(
                      linkSnap.data!,
                    )
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
                  CreateCircuitCard(onTap: _openCreate),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
