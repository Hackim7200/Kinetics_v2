import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/widgets/kinetic_app_bar.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/circuit/data/circuit_exercise_service.dart';
import 'package:mobile_frontend/feature/circuit/screens/add_circuit_exercise_screen.dart';
import 'package:mobile_frontend/feature/circuit/screens/circuit_play_screen.dart';
import 'package:mobile_frontend/feature/circuit/screens/edit_circuit_exercise_screen.dart';
import 'package:mobile_frontend/feature/circuit/screens/edit_circuit_screen.dart';

String _stationSubtitle(int? stationSeconds) {
  final w = stationSeconds;
  if (w == null) return '—';
  return '$w SEC';
}

class CircuitDetailScreen extends ConsumerStatefulWidget {
  final Circuit circuit;

  const CircuitDetailScreen({super.key, required this.circuit});

  @override
  ConsumerState<CircuitDetailScreen> createState() =>
      _CircuitDetailScreenState();
}

class _CircuitDetailScreenState extends ConsumerState<CircuitDetailScreen> {
  late Circuit _circuit;
  late final CircuitExerciseService circuitExerciseService;

  @override
  void initState() {
    super.initState();
    _circuit = widget.circuit;
    circuitExerciseService = CircuitExerciseService(ref.read(appDatabaseProvider));
  }

  Future<void> _openEdit() async {
    final updated = await Navigator.of(context).push<Circuit>(
      MaterialPageRoute(
        builder: (_) => EditCircuitScreen(circuit: _circuit),
      ),
    );
    if (updated != null && mounted) setState(() => _circuit = updated);
  }

  Future<void> _addExercise() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => AddCircuitExerciseScreen(
          circuitId: _circuit.id,
          circuitName: _circuit.name,
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
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
          _CircuitHeroHeader(circuit: _circuit),
          const SizedBox(height: 40),
          _CircuitExerciseList(
            circuitId: _circuit.id,
            circuitName: _circuit.name,
            stationDurationSeconds: _circuit.stationDurationSeconds,
            circuitExerciseService: circuitExerciseService,
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

  const _CircuitHeroHeader({required this.circuit});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final roundsLabel = circuit.rounds?.toString() ?? '—';
    final sec = circuit.stationDurationSeconds;
    final durationLabel = sec != null ? '$sec SEC' : '—';
    final preStartSec = circuit.preStartCountdownSeconds;
    final preStartLabel = preStartSec == null
        ? '—'
        : preStartSec == 0
        ? 'OFF'
        : '$preStartSec SEC';
    final restSec = circuit.restBetweenRoundsSeconds;
    final restLabel = restSec != null ? '$restSec SEC' : '—';
    final orderLabel = circuit.randomizeStationOrder == true
        ? 'RANDOM'
        : 'LIST';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACTIVE CIRCUIT',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
            color: cs.tertiary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          circuit.name.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            letterSpacing: -2,
            height: 1.0,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        _CircuitHeroHeader._metricsRow(
          cs,
          left: _MetricPill(label: 'ROUNDS', value: roundsLabel),
          right: _MetricPill(label: 'ORDER', value: orderLabel),
        ),
        const SizedBox(height: 12),
        _CircuitHeroHeader._metricsRow(
          cs,
          left: _MetricPill(label: 'COUNTDOWN', value: preStartLabel),
          right:         _MetricPill(label: 'REST', value: restLabel),
        ),
        const SizedBox(height: 12),
        _CircuitHeroHeader._metricsRow(
          cs,
          left: _MetricPill(label: 'EACH EXERCISE', value: durationLabel),
  
          right: const SizedBox.shrink(),
          showCenterRule: false,
        ),
      ],
    );
  }

  /// Two equal columns; optional vertical rule (same width as rule + margins when off).
  static Widget _metricsRow(
    ColorScheme cs, {
    required Widget left,
    required Widget right,
    bool showCenterRule = true,
  }) {
    final gutter = showCenterRule
        ? Container(
            width: 1,
            height: 32,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            color: cs.surfaceContainerHighest,
          )
        : const SizedBox(width: 49);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        gutter,
        Expanded(child: right),
      ],
    );
  }
}

class _CircuitExerciseList extends StatelessWidget {
  final String circuitId;
  final String circuitName;
  final int? stationDurationSeconds;
  final CircuitExerciseService circuitExerciseService;
  final VoidCallback onAddExercise;

  const _CircuitExerciseList({
    required this.circuitId,
    required this.circuitName,
    required this.stationDurationSeconds,
    required this.circuitExerciseService,
    required this.onAddExercise,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return StreamBuilder<List<CircuitExercise>>(
      stream: circuitExerciseService.watchForCircuit(circuitId),
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

        final links = snapshot.data!;

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
                        '${links.length} Total',
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
            if (links.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'No exercises yet. Use the button below to add one.',
                  style: GoogleFonts.inter(fontSize: 14, color: cs.outline),
                ),
              )
            else
              FutureBuilder<Map<String, Exercise>>(
                key: ValueKey(links.map((e) => e.id).join(',')),
                future: circuitExerciseService.exerciseMapForIds(
                  links.map((l) => l.exerciseId).toSet(),
                ),
                builder: (context, exSnap) {
                  if (!exSnap.hasData) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final map = exSnap.data!;
                  return Column(
                    children: [
                      for (var i = 0; i < links.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _CircuitExerciseTile(
                            exercise: map[links[i].exerciseId],
                            link: links[i],
                            circuitName: circuitName,
                            stationDurationSeconds: stationDurationSeconds,
                          ),
                        ),
                    ],
                  );
                },
              ),
            _DashedAddCircuitExerciseButton(onPressed: onAddExercise),
          ],
        );
      },
    );
  }
}

class _CircuitExerciseTile extends StatelessWidget {
  final Exercise? exercise;
  final CircuitExercise link;
  final String circuitName;
  final int? stationDurationSeconds;

  const _CircuitExerciseTile({
    required this.exercise,
    required this.link,
    required this.circuitName,
    required this.stationDurationSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final name = exercise?.name ?? 'Unknown exercise';
    final subtitle = _stationSubtitle(stationDurationSeconds);

    return Material(
      color: cs.surfaceContainerLowest,
      child: InkWell(
        onTap: exercise == null
            ? null
            : () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => EditCircuitExerciseScreen(
                      link: link,
                      exercise: exercise!,
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

class _DashedAddCircuitExerciseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _DashedAddCircuitExerciseButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: CustomPaint(
            painter: _DashedBorderPainter(color: cs.surfaceContainerHighest),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_box_outlined, size: 28, color: cs.tertiary),
                  const SizedBox(height: 8),
                  Text(
                    'ADD EXERCISE',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                      color: cs.tertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;

  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(1, 1, size.width - 2, size.height - 2);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dash = 6.0;
    const gap = 4.0;

    void drawDashedLine(Offset from, Offset to) {
      final total = (to - from).distance;
      if (total <= 0) return;
      final dir = (to - from) / total;
      var d = 0.0;
      while (d < total) {
        final end = d + dash > total ? total : d + dash;
        canvas.drawLine(from + dir * d, from + dir * end, paint);
        d = end + gap;
      }
    }

    drawDashedLine(rect.topLeft, rect.topRight);
    drawDashedLine(rect.bottomLeft, rect.bottomRight);
    drawDashedLine(rect.topLeft, rect.bottomLeft);
    drawDashedLine(rect.topRight, rect.bottomRight);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _MetricPill extends StatelessWidget {
  final String label;
  final String value;

  const _MetricPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            color: cs.outline,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}
