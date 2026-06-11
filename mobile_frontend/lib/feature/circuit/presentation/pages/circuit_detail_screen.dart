import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/widgets/detail_hero_header.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/common/widgets/metric_pill.dart';
import 'package:mobile_frontend/feature/circuit/data/repositories/circuit_exercise_repository.dart';
import 'package:mobile_frontend/feature/circuit/domain/entities/circuit.dart';
import 'package:mobile_frontend/feature/circuit/domain/entities/circuit_exercise.dart';
import 'package:mobile_frontend/feature/circuit/domain/use_cases/circuit_display.dart';
import 'package:mobile_frontend/feature/circuit/presentation/pages/add_circuit_exercise_screen.dart';
import 'package:mobile_frontend/feature/circuit/presentation/pages/circuit_play_screen.dart';
import 'package:mobile_frontend/feature/circuit/presentation/pages/edit_circuit_exercise_screen.dart';
import 'package:mobile_frontend/feature/circuit/presentation/pages/edit_circuit_screen.dart';
import 'package:mobile_frontend/feature/routine_exercise/presentation/widgets/add_exercise_button.dart';

class CircuitDetailScreen extends ConsumerStatefulWidget {
  final Circuit circuit;

  const CircuitDetailScreen({super.key, required this.circuit});

  @override
  ConsumerState<CircuitDetailScreen> createState() =>
      _CircuitDetailScreenState();
}

class _CircuitDetailScreenState extends ConsumerState<CircuitDetailScreen> {
  late Circuit _circuit;

  Future<void> _openEdit() async {
    final updated = await Navigator.of(context).push<Circuit>(
      MaterialPageRoute(builder: (_) => EditCircuitScreen(circuit: _circuit)),
    );
    if (updated != null && mounted) setState(() => _circuit = updated);
  }

  Future<void> _addExercise() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => AddCircuitExerciseScreen(
          circuitId: _circuit.id,
          circuitName: _circuit.title,
        ),
      ),
    );
  }

  void _openPlay() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => CircuitPlayScreen(circuit: _circuit),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _circuit = widget.circuit;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final circuitExerciseRepository = ref.watch(
      circuitExerciseRepositoryProvider,
    );

    return Scaffold(
      appBar: KineticAppBar(
        showBackButton: true,
        actions: [
          GestureDetector(
            onTap: _openEdit,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.edit_outlined, color: cs.primary, size: 22),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
        children: [
          _CircuitHeroHeader(
            circuit: _circuit,
            circuitExerciseRepository: circuitExerciseRepository,
          ),
          const SizedBox(height: 40),
          _CircuitExerciseList(
            circuitId: _circuit.id,
            circuitName: _circuit.title,
            stationDurationSeconds: _circuit.stationDuration,
            circuitExerciseRepository: circuitExerciseRepository,
            onAddExercise: _addExercise,
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: FloatingActionButton(
          onPressed: _openPlay,
          child: const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}

class _CircuitHeroHeader extends StatelessWidget {
  final Circuit circuit;
  final CircuitExerciseRepository circuitExerciseRepository;

  const _CircuitHeroHeader({
    required this.circuit,
    required this.circuitExerciseRepository,
  });

  @override
  Widget build(BuildContext context) {
    final roundsLabel = circuit.rounds?.toString() ?? '—';
    final durationLabel = CircuitDisplay.secondsLabel(circuit.stationDuration);
    final preStartLabel = CircuitDisplay.countdownLabel(circuit.countdown);
    final restLabel = CircuitDisplay.secondsLabel(circuit.rest);
    final orderLabel = CircuitDisplay.orderLabel(circuit);

    return DetailHeroHeader(
      eyebrowLabel: 'ACTIVE CIRCUIT',
      title: circuit.title,
      metrics: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MetricPillPair(
            leftLabel: 'ROUNDS',
            leftValue: roundsLabel,
            rightLabel: 'ORDER',
            rightValue: orderLabel,
          ),
          const SizedBox(height: 12),
          MetricPillPair(
            leftLabel: 'COUNTDOWN',
            leftValue: preStartLabel,
            rightLabel: 'REST',
            rightValue: restLabel,
          ),
          const SizedBox(height: 12),
          StreamBuilder<List<CircuitExercise>>(
            stream: circuitExerciseRepository.watchForCircuit(circuit.id),
            builder: (context, snap) {
              final exerciseCount = snap.data?.length ?? 0;
              return MetricPillPair(
                leftLabel: 'EACH EXERCISE',
                leftValue: durationLabel,
                rightLabel: 'EXERCISES',
                rightValue: '$exerciseCount',
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CircuitExerciseList extends StatelessWidget {
  final String circuitId;
  final String circuitName;
  final int? stationDurationSeconds;
  final CircuitExerciseRepository circuitExerciseRepository;
  final VoidCallback onAddExercise;

  const _CircuitExerciseList({
    required this.circuitId,
    required this.circuitName,
    required this.stationDurationSeconds,
    required this.circuitExerciseRepository,
    required this.onAddExercise,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return StreamBuilder<List<CircuitExercise>>(
      stream: circuitExerciseRepository.watchForCircuit(circuitId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            'Could not load exercises',
            style: GoogleFonts.inter(color: cs.error),
          );
        }
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final circuitExercises = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: cs.surfaceContainerHighest),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EXERCISES',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${circuitExercises.length} Total',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: cs.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (circuitExercises.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'No exercises yet. Use the button below to add one.',
                  style: GoogleFonts.inter(fontSize: 14, color: cs.outline),
                ),
              )
            else
              Column(
                children: [
                  for (final circuitExercise in circuitExercises)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _CircuitExerciseTile(
                        circuitExercise: circuitExercise,
                        circuitName: circuitName,
                        stationDurationSeconds: stationDurationSeconds,
                      ),
                    ),
                ],
              ),
            AddExerciseButton(onTap: onAddExercise),
          ],
        );
      },
    );
  }
}

class _CircuitExerciseTile extends StatelessWidget {
  final CircuitExercise circuitExercise;
  final String circuitName;
  final int? stationDurationSeconds;

  const _CircuitExerciseTile({
    required this.circuitExercise,
    required this.circuitName,
    required this.stationDurationSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final name = circuitExercise.title;
    final subtitle = CircuitDisplay.stationSubtitle(stationDurationSeconds);

    return Material(
      color: cs.surfaceContainerLowest,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push<void>(
            MaterialPageRoute<void>(
              builder: (_) => EditCircuitExerciseScreen(
                circuitExercise: circuitExercise,
                circuitName: circuitName,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        height: 1.2,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: cs.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: cs.outline),
            ],
          ),
        ),
      ),
    );
  }
}
