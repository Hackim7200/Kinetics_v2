import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressGraph extends StatelessWidget {
  final String title;
  final String subtitle;

  /// e.g. `+12.5`, `-3.0`, or `—` when unknown.
  final String percentChangeDisplay;
  final List<double> series;
  final List<String> xLabels;

  const ProgressGraph({
    super.key,
    required this.title,
    required this.subtitle,
    required this.percentChangeDisplay,
    required this.series,
    required this.xLabels,
  });

  bool get _hasPercent {
    final display = percentChangeDisplay;
    return display != '—' && display != 'Stable' && display.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
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
                        color: colorScheme.onSurface,
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
                        color: colorScheme.tertiary,
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
                          text: percentChangeDisplay,
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (_hasPercent)
                          TextSpan(
                            text: '%',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.tertiary,
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
          SizedBox(
            height: 100,
            child: series.isEmpty
                ? Center(
                    child: Text(
                      'No workout history yet',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.tertiary,
                      ),
                    ),
                  )
                : LineChart(
                    _lineChartData(series, colorScheme.onSurface),
                    duration: Duration.zero,
                  ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                for (var index = 0; index < xLabels.length; index++)
                  Expanded(
                    child: Text(
                      xLabels[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: index == xLabels.length - 1
                            ? colorScheme.primary
                            : colorScheme.tertiary,
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

  LineChartData _lineChartData(List<double> data, Color lineColor) {
    final minValue = data.reduce(min);
    final maxValue = data.reduce(max);
    final range = maxValue - minValue;
    final chartMinY = range == 0 ? minValue - 1 : minValue;
    final chartMaxY = range == 0 ? maxValue + 1 : maxValue;
    final lastIndex = data.length - 1;

    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      clipData: const FlClipData.all(),
      minX: 0,
      maxX: lastIndex == 0 ? 1 : lastIndex.toDouble(),
      minY: chartMinY,
      maxY: chartMaxY,
      lineTouchData: const LineTouchData(enabled: false),
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (var index = 0; index < data.length; index++)
              FlSpot(index.toDouble(), data[index]),
          ],
          isCurved: false,
          color: lineColor,
          barWidth: 3,
          dotData: FlDotData(
            getDotPainter: (spot, percent, barData, index) {
              final isLast = index == lastIndex;
              return FlDotCirclePainter(
                radius: isLast ? 5 : 3,
                color: lineColor,
              );
            },
          ),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }
}
