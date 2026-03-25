import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/presentation/workouts/providers/rest_timer_provider.dart';

/// Glassmorphic mini timer shown bottom-right when the user navigates away
/// from the current exercise while a rest timer is still running.
class FloatingTimerWidget extends StatelessWidget {
  const FloatingTimerWidget({
    required this.state,
    required this.exerciseName,
    required this.onTap,
    super.key,
  });

  final RestTimerState state;
  final String exerciseName;
  final VoidCallback onTap;

  Color get _stateColor {
    switch (state.status) {
      case RestTimerStatus.urgent:
        return AppColors.danger;
      case RestTimerStatus.overtime:
        return AppColors.success;
      case RestTimerStatus.idle:
      case RestTimerStatus.counting:
        return AppColors.primary;
    }
  }

  bool get _isUrgent => state.status == RestTimerStatus.urgent;

  @override
  Widget build(BuildContext context) {
    final color = _stateColor;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundCard.withValues(alpha: 0.95),
              border: Border.all(color: color.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 12,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isUrgent ? 'SBRIGATI!' : 'RECUPERO',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: _isUrgent ? AppColors.danger : AppColors.textMuted,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: CustomPaint(
                        painter: _MiniRingPainter(
                          progress: state.progressFraction,
                          color: color,
                        ),
                        child: Center(
                          child: Text(
                            state.formattedTime,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          exerciseName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tap per tornare',
                          style: TextStyle(
                            fontSize: 10,
                            color: _isUrgent
                                ? AppColors.danger
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniRingPainter extends CustomPainter {
  _MiniRingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  static const double _strokeWidth = 3;
  static const double _radius = 15;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Background ring
    final bgPaint = Paint()
      ..color = AppColors.backgroundCardHover
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;
    canvas.drawCircle(center, _radius, bgPaint);

    // Progress arc
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: _radius),
      -math.pi / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_MiniRingPainter old) =>
      old.progress != progress || old.color != color;
}
