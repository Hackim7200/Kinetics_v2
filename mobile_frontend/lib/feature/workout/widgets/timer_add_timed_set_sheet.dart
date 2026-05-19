import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_frontend/common/utils/timer_routine_target.dart';
import 'package:mobile_frontend/feature/exercise/models/exercise.dart';

/// `mm:ss` (total minutes, 0–59 seconds within the minute remainder).
String formatTimerMinutesSeconds(Duration d) {
  final sec = d.inSeconds.clamp(0, 1 << 30);
  final m = sec ~/ 60;
  final s = sec % 60;
  return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
}

/// Modal bottom sheet: run stopwatch, tap **COMPLETE** to return [Duration],
/// or cancel to return `null`.
Future<Duration?> showTimerAddTimedSetSheet({
  required BuildContext context,
  required Exercise exercise,
  required int setNumber,
  required int maxSets,
  Duration? personalBestDuration,
}) {
  return showModalBottomSheet<Duration>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => _TimerAddTimedSetSheetBody(
      exercise: exercise,
      setNumber: setNumber,
      maxSets: maxSets,
      personalBestDuration: personalBestDuration,
    ),
  );
}

class _TimerAddTimedSetSheetBody extends StatefulWidget {
  final Exercise exercise;
  final int setNumber;
  final int maxSets;
  final Duration? personalBestDuration;

  const _TimerAddTimedSetSheetBody({
    required this.exercise,
    required this.setNumber,
    required this.maxSets,
    required this.personalBestDuration,
  });

  @override
  State<_TimerAddTimedSetSheetBody> createState() =>
      _TimerAddTimedSetSheetBodyState();
}

class _TimerAddTimedSetSheetBodyState extends State<_TimerAddTimedSetSheetBody> {
  Timer? _uiTick;
  bool _isRunning = false;
  DateTime? _startedAt;
  Duration _accumulated = Duration.zero;

  Duration get _displayElapsed {
    if (_isRunning && _startedAt != null) {
      return _accumulated + DateTime.now().difference(_startedAt!);
    }
    return _accumulated;
  }

  /// Fills once per minute, then resets (outline = progress through current minute).
  double get _progress {
    const periodMs = 60000;
    final ms = _displayElapsed.inMilliseconds % periodMs;
    return (ms / periodMs).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _uiTick?.cancel();
    super.dispose();
  }

  void _beginUiTick() {
    _uiTick?.cancel();
    _uiTick = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) setState(() {});
    });
  }

  void _stopUiTick() {
    _uiTick?.cancel();
    _uiTick = null;
  }

  void _toggleRun() {
    if (_isRunning) {
      if (_startedAt != null) {
        _accumulated += DateTime.now().difference(_startedAt!);
        _startedAt = null;
      }
      _stopUiTick();
      setState(() => _isRunning = false);
    } else {
      setState(() {
        _isRunning = true;
        _startedAt = DateTime.now();
      });
      _beginUiTick();
    }
  }

  void _reset() {
    if (_isRunning) {
      if (_startedAt != null) {
        _accumulated += DateTime.now().difference(_startedAt!);
        _startedAt = null;
      }
      _stopUiTick();
      setState(() => _isRunning = false);
    }
    setState(() => _accumulated = Duration.zero);
  }

  void _complete() {
    final elapsed = _displayElapsed;
    if (elapsed.inSeconds < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hold for at least 1 second before completing.'),
        ),
      );
      return;
    }
    if (_isRunning) {
      if (_startedAt != null) {
        _accumulated += DateTime.now().difference(_startedAt!);
        _startedAt = null;
      }
      _stopUiTick();
      setState(() => _isRunning = false);
    }
    Navigator.of(context).pop(elapsed);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final pb = widget.personalBestDuration;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 16 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: cs.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'SET ${widget.setNumber.toString().padLeft(2, '0')} · ${widget.maxSets}',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: cs.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.exercise.name.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'TARGET: ${TimerRoutineTarget.label(widget.exercise.timerTarget).toUpperCase()}',
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: cs.tertiary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 260,
            height: 260,
            child: CustomPaint(
              painter: _TimerRingPainter(
                progress: _progress,
                trackColor: cs.surfaceContainerHigh,
                progressColor: cs.primary,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatTimerMinutesSeconds(_displayElapsed),
                      style: GoogleFonts.inter(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -2,
                        color: cs.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      pb != null
                          ? 'PB: ${formatTimerMinutesSeconds(pb)}'
                          : 'PB: —',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: cs.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _SheetControlButton(
                  icon: Icons.refresh,
                  label: 'RESET',
                  isPrimary: false,
                  onTap: _reset,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SheetControlButton(
                  icon: _isRunning ? Icons.pause : Icons.play_arrow,
                  label: _isRunning ? 'PAUSE' : 'START',
                  isPrimary: true,
                  onTap: _toggleRun,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SheetControlButton(
                  icon: Icons.check,
                  label: 'COMPLETE',
                  isPrimary: false,
                  onTap: _complete,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'CANCEL',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                color: cs.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _SheetControlButton({
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: isPrimary
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [cs.primary, cs.primaryContainer],
                  )
                : null,
            color: isPrimary ? null : cs.surfaceContainer,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: isPrimary ? 24 : 20,
                color: isPrimary ? cs.onPrimary : cs.onSurface,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  color: isPrimary ? cs.onPrimary : cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;

  _TimerRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 4;
    const strokeWidth = 3.0;

    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    canvas.drawCircle(center, radius, trackPaint);

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerRingPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      trackColor != oldDelegate.trackColor ||
      progressColor != oldDelegate.progressColor;
}
