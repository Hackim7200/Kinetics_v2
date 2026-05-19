import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressGraph extends StatelessWidget {
  final String title;
  final String subtitle;
  final String currentValue;
  final String unit;
  final List<double> series;
  final List<String> xLabels;

  const ProgressGraph({
    super.key,
    required this.title,
    required this.subtitle,
    required this.currentValue,
    required this.unit,
    this.series = const [],
    this.xLabels = const [],
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: cs.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: currentValue,
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: cs.onSurface,
                          ),
                        ),
                        TextSpan(
                          text: ' $unit',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: cs.tertiary,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Chart — width from parent constraints (avoid infinite CustomPaint size).
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                height: 100,
                width: constraints.maxWidth,
                child: series.isEmpty
                    ? Center(
                        child: Text(
                          'No workout history yet',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: cs.tertiary,
                          ),
                        ),
                      )
                    : CustomPaint(
                        painter: _ChartPainter(
                          data: series,
                          lineColor: cs.onSurface,
                          dotColor: cs.onSurface,
                        ),
                      ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Week Labels
          Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                for (var i = 0; i < xLabels.length; i++)
                  Expanded(
                    child: Text(
                      xLabels[i],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: i == xLabels.length - 1
                            ? cs.primary
                            : cs.tertiary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final Color dotColor;

  _ChartPainter({
    required this.data,
    required this.lineColor,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxVal = data.reduce(max);
    final minVal = data.reduce(min);
    final range = maxVal - minVal;

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final points = <Offset>[];

    for (var i = 0; i < data.length; i++) {
      final x = data.length == 1
          ? size.width / 2
          : i * size.width / (data.length - 1);
      final normalizedY = range == 0 ? 0.5 : (data[i] - minVal) / range;
      final y = size.height - (normalizedY * size.height);
      points.add(Offset(x, y));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);

    for (var i = 0; i < points.length; i++) {
      final radius = i == points.length - 1 ? 5.0 : 3.0;
      canvas.drawCircle(points[i], radius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) =>
      data != oldDelegate.data ||
      lineColor != oldDelegate.lineColor ||
      dotColor != oldDelegate.dotColor;
}
