import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Animated flame widget using CustomPainter.
///
/// Renders 4 concentric flame layers with gradient fills, 5 spark particles,
/// and an optional radial glow at the base. All layers animate continuously
/// via staggered [AnimationController]s.
///
/// Parameters:
/// - [scale]        — overall flame scale (0.0–1.0+)
/// - [opacity]      — overall widget opacity (0.0–1.0)
/// - [speedSeconds] — base animation period in seconds (shorter = faster)
/// - [glow]         — glow intensity at base (0.0–1.0)
/// - [size]         — bounding box width/height in logical pixels (default 48)
class FlameWidget extends StatefulWidget {
  const FlameWidget({
    required this.scale,
    required this.opacity,
    required this.speedSeconds,
    required this.glow,
    this.size = 48,
    super.key,
  });

  final double scale;
  final double opacity;
  final double speedSeconds;
  final double glow;
  final double size;

  @override
  State<FlameWidget> createState() => _FlameWidgetState();
}

class _FlameWidgetState extends State<FlameWidget>
    with TickerProviderStateMixin {
  // 4 wave controllers for flame layers
  late final List<AnimationController> _waveControllers;

  // 5 spark controllers (one per particle)
  late final List<AnimationController> _sparkControllers;

  @override
  void initState() {
    super.initState();

    _waveControllers = List.generate(4, (i) {
      final speed = widget.speedSeconds + i * 0.05;
      final ctrl = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: (speed * 1000).round()),
      )..repeat(reverse: true);
      return ctrl;
    });

    // Spark controllers — stagger phase by seeding the initial value so
    // particles appear offset without needing real timers (which break tests).
    _sparkControllers = List.generate(5, (i) {
      final speed = widget.speedSeconds * (0.6 + i * 0.15);
      final ctrl = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: (speed * 1000).round()),
        value: i / 5.0, // pre-offset phase
      )..repeat();
      return ctrl;
    });
  }

  @override
  void didUpdateWidget(FlameWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.speedSeconds != widget.speedSeconds) {
      for (var i = 0; i < _waveControllers.length; i++) {
        final speed = widget.speedSeconds + i * 0.05;
        _waveControllers[i].duration =
            Duration(milliseconds: (speed * 1000).round());
      }
    }
  }

  @override
  void dispose() {
    for (final c in _waveControllers) {
      c.dispose();
    }
    for (final c in _sparkControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allControllers = <Listenable>[
      ..._waveControllers,
      ..._sparkControllers,
    ];

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Opacity(
        opacity: widget.opacity.clamp(0.0, 1.0),
        child: AnimatedBuilder(
          animation: Listenable.merge(allControllers),
          builder: (context, _) {
            return CustomPaint(
              painter: _FlamePainter(
                scale: widget.scale,
                glow: widget.glow,
                waveValues: _waveControllers.map((c) => c.value).toList(),
                sparkValues: _sparkControllers.map((c) => c.value).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Painter
// ---------------------------------------------------------------------------

class _FlamePainter extends CustomPainter {
  _FlamePainter({
    required this.scale,
    required this.glow,
    required this.waveValues,
    required this.sparkValues,
  });

  final double scale;
  final double glow;
  final List<double> waveValues;
  final List<double> sparkValues;

  // Layer gradient definitions: [bottomColor, topColor]
  static const _layerColors = [
    [Color(0xFFd84315), Color(0xFFffb74d)], // outer
    [Color(0xFFff5722), Color(0xFFffeb3b)], // middle
    [Color(0xFFff9800), Color(0xFFfff59d)], // inner
    [Color(0xFFffc107), Color(0xFFffffff)], // core
  ];

  // Layer size multipliers (outer → inner → core)
  static const _layerScales = [1.0, 0.78, 0.56, 0.34];

  // Horizontal wobble amplitude per layer (outer wobbles more)
  static const _wobbleAmplitude = [0.18, 0.14, 0.10, 0.06];

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height;

    // --- Glow at base ---
    if (glow > 0) {
      final glowPaint = Paint()
        ..color = const Color(0xFFff6b35).withOpacity(glow * 0.6)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, size.width * 0.35);
      canvas.drawCircle(
        Offset(cx, cy - size.height * 0.05),
        size.width * 0.45 * scale.clamp(0.1, 1.5),
        glowPaint,
      );
    }

    // --- 4 flame layers ---
    for (var i = 0; i < 4; i++) {
      final wave = waveValues.length > i ? waveValues[i] : 0.0;
      _paintFlameLayer(canvas, size, cx, cy, i, wave);
    }

    // --- Sparks (only when scale is large enough) ---
    if (scale > 0.3 && sparkValues.length == 5) {
      _paintSparks(canvas, size, cx, cy);
    }
  }

  void _paintFlameLayer(
    Canvas canvas,
    Size size,
    double cx,
    double cy,
    int layerIndex,
    double wave,
  ) {
    final ls = _layerScales[layerIndex];
    final wobble = _wobbleAmplitude[layerIndex];
    final colors = _layerColors[layerIndex];

    final halfW = size.width * 0.42 * ls * scale.clamp(0.1, 1.5);
    final height = size.height * 0.9 * ls * scale.clamp(0.1, 1.5);

    // Control point horizontal offset animated by wave
    final cpOffsetX = halfW * wobble * (wave * 2 - 1);

    final path = Path();
    // Start at base-left
    path.moveTo(cx - halfW, cy);

    // Left side: curve up to tip
    path.quadraticBezierTo(
      cx - halfW * 0.5 + cpOffsetX,
      cy - height * 0.5,
      cx + cpOffsetX * 0.3,
      cy - height,
    );

    // Right side: curve back down to base-right
    path.quadraticBezierTo(
      cx + halfW * 0.5 + cpOffsetX,
      cy - height * 0.5,
      cx + halfW,
      cy,
    );

    path.close();

    // Build linear gradient from bottom to top
    final gradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: colors,
    );

    final rect = Rect.fromLTWH(cx - halfW, cy - height, halfW * 2, height);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  void _paintSparks(Canvas canvas, Size size, double cx, double cy) {
    final rng = math.Random(42); // deterministic seed for consistent positions

    for (var i = 0; i < 5; i++) {
      final t = sparkValues[i]; // 0→1 rise cycle

      // Base horizontal spread
      final baseX = cx + (rng.nextDouble() - 0.5) * size.width * 0.6;
      // Drift sideways over the rise
      final driftX = (rng.nextDouble() - 0.5) * size.width * 0.2 * t;
      // Rise from bottom of flame
      final riseY = cy - size.height * 0.3 - t * size.height * 0.7;

      // Fade in for first half, fade out for second half
      final alpha = (t < 0.5 ? t * 2 : (1.0 - t) * 2).clamp(0.0, 1.0);

      final sparkPaint = Paint()
        ..color = const Color(0xFFffeb3b).withOpacity(alpha * 0.9)
        ..style = PaintingStyle.fill;

      final radius = 1.5 + rng.nextDouble() * 1.5;
      canvas.drawCircle(Offset(baseX + driftX, riseY), radius, sparkPaint);
    }
  }

  @override
  bool shouldRepaint(_FlamePainter old) => true;
}
