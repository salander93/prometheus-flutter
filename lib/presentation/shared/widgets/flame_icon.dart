import 'package:flutter/material.dart';

/// Custom flame icon matching the exact SVG from the PWA navbar.
class FlameIcon extends StatelessWidget {
  const FlameIcon({
    this.size = 24,
    this.color,
    super.key,
  });

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _FlamePainter(
        color: color ?? IconTheme.of(context).color ?? Colors.white,
      ),
    );
  }
}

class _FlamePainter extends CustomPainter {
  _FlamePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(13.5 * scale, 0.67 * scale)
      ..cubicTo(
        13.5 * scale,
        0.67 * scale,
        14.24 * scale,
        3.32 * scale,
        14.24 * scale,
        5.47 * scale,
      )
      ..cubicTo(
        14.24 * scale,
        7.53 * scale,
        12.89 * scale,
        9.2 * scale,
        10.83 * scale,
        9.2 * scale,
      )
      ..cubicTo(
        8.76 * scale,
        9.2 * scale,
        7.2 * scale,
        7.53 * scale,
        7.2 * scale,
        5.47 * scale,
      )
      ..lineTo(7.23 * scale, 5.11 * scale)
      ..cubicTo(
        5.21 * scale,
        7.51 * scale,
        4 * scale,
        10.62 * scale,
        4 * scale,
        14 * scale,
      )
      ..cubicTo(
        4 * scale,
        18.42 * scale,
        7.58 * scale,
        22 * scale,
        12 * scale,
        22 * scale,
      )
      ..cubicTo(
        16.42 * scale,
        22 * scale,
        20 * scale,
        18.42 * scale,
        20 * scale,
        14 * scale,
      )
      ..cubicTo(
        20 * scale,
        8.61 * scale,
        17.41 * scale,
        3.8 * scale,
        13.5 * scale,
        0.67 * scale,
      )
      ..close()
      ..moveTo(11.71 * scale, 19 * scale)
      ..cubicTo(
        9.93 * scale,
        19 * scale,
        8.49 * scale,
        17.6 * scale,
        8.49 * scale,
        15.86 * scale,
      )
      ..cubicTo(
        8.49 * scale,
        14.24 * scale,
        9.54 * scale,
        13.1 * scale,
        11.3 * scale,
        12.74 * scale,
      )
      ..cubicTo(
        13.07 * scale,
        12.38 * scale,
        14.9 * scale,
        11.53 * scale,
        15.92 * scale,
        10.16 * scale,
      )
      ..cubicTo(
        16.31 * scale,
        11.45 * scale,
        16.51 * scale,
        12.81 * scale,
        16.51 * scale,
        14.2 * scale,
      )
      ..cubicTo(
        16.51 * scale,
        16.85 * scale,
        14.36 * scale,
        19 * scale,
        11.71 * scale,
        19 * scale,
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_FlamePainter oldDelegate) =>
      color != oldDelegate.color;
}
