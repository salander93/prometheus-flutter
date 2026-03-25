import 'package:flutter/material.dart';

enum BodyPosition { front, back, right, left }

class BodySilhouette extends StatelessWidget {
  const BodySilhouette({
    required this.position,
    this.opacity = 0.6,
    super.key,
  });

  final BodyPosition position;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SilhouettePainter(
        position: position,
        opacity: opacity,
      ),
      size: Size.infinite,
    );
  }
}

class _SilhouettePainter extends CustomPainter {
  const _SilhouettePainter({
    required this.position,
    required this.opacity,
  });

  final BodyPosition position;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF6B35).withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    // Match the crop frame dimensions (80% width, 3:4 aspect)
    final cropWidth = size.width * 0.80;
    final cropHeight = cropWidth / (3 / 4);
    // Use 90% of crop frame height for the silhouette
    final targetHeight = cropHeight * 0.90;
    final scale = targetHeight / _kNaturalHeight;
    final cx = size.width / 2;
    final cy = (size.height - targetHeight) / 2;

    canvas
      ..save()
      ..translate(cx, cy);

    if (position == BodyPosition.left) {
      canvas.scale(-1, 1);
    }

    final path = position == BodyPosition.right ||
            position == BodyPosition.left
        ? _buildSideProfile(scale)
        : _buildFrontProfile(scale);

    canvas
      ..drawPath(path, paint)
      ..restore();
  }

  // Natural coordinate space height (logical units before scaling).
  static const double _kNaturalHeight = 320;

  Path _buildFrontProfile(double s) {
    final path = Path();

    // ── Head ──────────────────────────────────────────────────────────────
    // Oval: center (0, 26), rx=18, ry=22
    final headRect = Rect.fromCenter(
      center: Offset(0, 26 * s),
      width: 36 * s,
      height: 44 * s,
    );
    path
      ..addOval(headRect)

      // ── Neck ────────────────────────────────────────────────────────────
      ..moveTo(-7 * s, 46 * s)
      ..lineTo(-7 * s, 60 * s)
      ..moveTo(7 * s, 46 * s)
      ..lineTo(7 * s, 60 * s);

    // ── Shoulders, torso and hips ─────────────────────────────────────────
    // Left side: shoulder out, down arm side, waist, hip
    // Right side: mirrored
    final torso = Path()
      ..moveTo(-7 * s, 60 * s) // left neck base
      ..cubicTo(
        -28 * s, 62 * s, // left shoulder control
        -38 * s, 68 * s, // left shoulder edge
        -42 * s, 78 * s, // left armpit
      )
      ..cubicTo(
        -36 * s, 80 * s, // waist left upper
        -32 * s, 116 * s, // waist left
        -28 * s, 128 * s, // hip left
      )
      ..cubicTo(
        -30 * s, 132 * s,
        -32 * s, 136 * s,
        -30 * s, 140 * s,
      ) // hip flare
      ..lineTo(-20 * s, 140 * s) // groin left
      ..lineTo(20 * s, 140 * s) // groin right
      ..cubicTo(
        32 * s, 136 * s,
        30 * s, 132 * s,
        28 * s, 128 * s,
      )
      ..cubicTo(
        32 * s, 116 * s,
        36 * s, 80 * s,
        42 * s, 78 * s,
      )
      ..cubicTo(
        38 * s, 68 * s,
        28 * s, 62 * s,
        7 * s, 60 * s,
      );
    path.addPath(torso, Offset.zero);

    // ── Left arm ──────────────────────────────────────────────────────────
    final leftArm = Path()
      ..moveTo(-42 * s, 78 * s) // armpit
      ..cubicTo(
        -52 * s, 90 * s,
        -56 * s, 110 * s,
        -54 * s, 130 * s,
      )
      ..cubicTo(
        -53 * s, 138 * s,
        -52 * s, 144 * s,
        -50 * s, 150 * s,
      ) // elbow area
      ..cubicTo(
        -49 * s, 162 * s,
        -48 * s, 178 * s,
        -46 * s, 188 * s,
      ) // forearm
      ..cubicTo(
        -45 * s, 194 * s,
        -43 * s, 198 * s,
        -40 * s, 200 * s,
      ) // wrist/hand top
      // hand
      ..lineTo(-38 * s, 202 * s)
      ..cubicTo(
        -36 * s, 208 * s,
        -35 * s, 212 * s,
        -36 * s, 216 * s,
      )
      ..cubicTo(
        -37 * s, 220 * s,
        -40 * s, 221 * s,
        -42 * s, 218 * s,
      )
      ..cubicTo(
        -44 * s, 215 * s,
        -44 * s, 210 * s,
        -43 * s, 204 * s,
      )
      ..cubicTo(
        -46 * s, 202 * s,
        -49 * s, 198 * s,
        -50 * s, 193 * s,
      );
    path.addPath(leftArm, Offset.zero);

    // ── Right arm (mirror of left) ────────────────────────────────────────
    final rightArm = Path()
      ..moveTo(42 * s, 78 * s)
      ..cubicTo(
        52 * s, 90 * s,
        56 * s, 110 * s,
        54 * s, 130 * s,
      )
      ..cubicTo(
        53 * s, 138 * s,
        52 * s, 144 * s,
        50 * s, 150 * s,
      )
      ..cubicTo(
        49 * s, 162 * s,
        48 * s, 178 * s,
        46 * s, 188 * s,
      )
      ..cubicTo(
        45 * s, 194 * s,
        43 * s, 198 * s,
        40 * s, 200 * s,
      )
      ..lineTo(38 * s, 202 * s)
      ..cubicTo(
        36 * s, 208 * s,
        35 * s, 212 * s,
        36 * s, 216 * s,
      )
      ..cubicTo(
        37 * s, 220 * s,
        40 * s, 221 * s,
        42 * s, 218 * s,
      )
      ..cubicTo(
        44 * s, 215 * s,
        44 * s, 210 * s,
        43 * s, 204 * s,
      )
      ..cubicTo(
        46 * s, 202 * s,
        49 * s, 198 * s,
        50 * s, 193 * s,
      );
    path.addPath(rightArm, Offset.zero);

    // ── Left leg ──────────────────────────────────────────────────────────
    final leftLeg = Path()
      ..moveTo(-20 * s, 140 * s) // inner groin
      ..cubicTo(
        -22 * s, 160 * s,
        -26 * s, 185 * s,
        -26 * s, 210 * s,
      ) // thigh
      ..cubicTo(
        -26 * s, 225 * s,
        -24 * s, 238 * s,
        -24 * s, 252 * s,
      ) // knee
      ..cubicTo(
        -24 * s, 270 * s,
        -22 * s, 290 * s,
        -22 * s, 305 * s,
      ) // shin
      ..lineTo(-22 * s, 312 * s)
      ..cubicTo(
        -22 * s, 316 * s,
        -26 * s, 318 * s,
        -32 * s, 318 * s,
      )
      ..lineTo(-38 * s, 318 * s); // foot
    path.addPath(leftLeg, Offset.zero);

    // ── Right leg ─────────────────────────────────────────────────────────
    final rightLeg = Path()
      ..moveTo(20 * s, 140 * s)
      ..cubicTo(
        22 * s, 160 * s,
        26 * s, 185 * s,
        26 * s, 210 * s,
      )
      ..cubicTo(
        26 * s, 225 * s,
        24 * s, 238 * s,
        24 * s, 252 * s,
      )
      ..cubicTo(
        24 * s, 270 * s,
        22 * s, 290 * s,
        22 * s, 305 * s,
      )
      ..lineTo(22 * s, 312 * s)
      ..cubicTo(
        22 * s, 316 * s,
        26 * s, 318 * s,
        32 * s, 318 * s,
      )
      ..lineTo(38 * s, 318 * s);
    path.addPath(rightLeg, Offset.zero);

    // ── Outer left leg line ───────────────────────────────────────────────
    final leftLegOuter = Path()
      ..moveTo(-30 * s, 140 * s)
      ..cubicTo(
        -34 * s, 160 * s,
        -38 * s, 185 * s,
        -38 * s, 210 * s,
      )
      ..cubicTo(
        -38 * s, 230 * s,
        -36 * s, 248 * s,
        -36 * s, 264 * s,
      )
      ..cubicTo(
        -36 * s, 285 * s,
        -34 * s, 300 * s,
        -34 * s, 312 * s,
      );
    path.addPath(leftLegOuter, Offset.zero);

    final rightLegOuter = Path()
      ..moveTo(30 * s, 140 * s)
      ..cubicTo(
        34 * s, 160 * s,
        38 * s, 185 * s,
        38 * s, 210 * s,
      )
      ..cubicTo(
        38 * s, 230 * s,
        36 * s, 248 * s,
        36 * s, 264 * s,
      )
      ..cubicTo(
        36 * s, 285 * s,
        34 * s, 300 * s,
        34 * s, 312 * s,
      );
    path.addPath(rightLegOuter, Offset.zero);

    return path;
  }

  Path _buildSideProfile(double s) {
    final path = Path();

    // ── Head (side oval, slightly forward) ───────────────────────────────
    final headRect = Rect.fromCenter(
      center: Offset(6 * s, 26 * s),
      width: 30 * s,
      height: 36 * s,
    );
    path
      ..addOval(headRect)

      // ── Neck ──────────────────────────────────────────────────────────
      ..moveTo(2 * s, 43 * s)
      ..lineTo(0 * s, 60 * s)
      ..moveTo(12 * s, 43 * s)
      ..lineTo(14 * s, 60 * s);

    // ── Torso (back curve + front chest) ─────────────────────────────────
    // Back line (right side = posterior)
    final back = Path()
      ..moveTo(14 * s, 60 * s)
      ..cubicTo(
        20 * s, 68 * s, // upper back
        22 * s, 90 * s, // mid back
        18 * s, 120 * s,
      ) // lower back
      ..cubicTo(
        16 * s, 130 * s,
        18 * s, 135 * s,
        22 * s, 140 * s,
      ); // buttocks
    path.addPath(back, Offset.zero);

    // Front chest / stomach line
    final front = Path()
      ..moveTo(0 * s, 60 * s)
      ..cubicTo(
        -10 * s, 68 * s, // chest protrusion
        -12 * s, 80 * s, // sternum
        -8 * s, 100 * s,
      ) // abdomen
      ..cubicTo(
        -4 * s, 112 * s,
        0 * s, 124 * s,
        -2 * s, 140 * s,
      ); // groin/hip front
    path.addPath(front, Offset.zero);

    // ── Arm (side, slightly behind front line) ────────────────────────────
    final arm = Path()
      ..moveTo(16 * s, 74 * s) // shoulder
      ..cubicTo(
        24 * s, 86 * s,
        26 * s, 110 * s,
        24 * s, 130 * s,
      )
      ..cubicTo(
        23 * s, 144 * s,
        22 * s, 158 * s,
        20 * s, 172 * s,
      )
      ..cubicTo(
        19 * s, 182 * s,
        18 * s, 190 * s,
        16 * s, 196 * s,
      )
      ..lineTo(14 * s, 200 * s)
      ..cubicTo(
        12 * s, 206 * s,
        12 * s, 212 * s,
        14 * s, 216 * s,
      )
      ..cubicTo(
        16 * s, 220 * s,
        18 * s, 218 * s,
        18 * s, 213 * s,
      )
      ..cubicTo(
        18 * s, 208 * s,
        17 * s, 202 * s,
        16 * s, 198 * s,
      );
    path.addPath(arm, Offset.zero);

    // ── Buttock close / hip base ──────────────────────────────────────────
    final hip = Path()
      ..moveTo(22 * s, 140 * s) // buttock back
      ..cubicTo(
        20 * s, 148 * s,
        16 * s, 152 * s,
        10 * s, 152 * s,
      )
      ..lineTo(-2 * s, 152 * s) // crotch
      ..lineTo(-2 * s, 140 * s); // groin front close
    path.addPath(hip, Offset.zero);

    // ── Leg (thigh → shin → foot) ─────────────────────────────────────────
    // Front of leg
    final legFront = Path()
      ..moveTo(-2 * s, 152 * s)
      ..cubicTo(
        -4 * s, 175 * s,
        -4 * s, 205 * s,
        -2 * s, 230 * s,
      ) // thigh front
      ..cubicTo(
        0 * s, 250 * s,
        0 * s, 270 * s,
        -2 * s, 295 * s,
      ) // shin
      ..lineTo(-2 * s, 312 * s)
      ..cubicTo(
        -2 * s, 316 * s,
        -4 * s, 318 * s,
        -16 * s, 318 * s,
      )
      ..lineTo(-22 * s, 318 * s); // foot tip
    path.addPath(legFront, Offset.zero);

    // Back of leg
    final legBack = Path()
      ..moveTo(10 * s, 152 * s) // buttock base
      ..cubicTo(
        14 * s, 175 * s,
        16 * s, 205 * s,
        14 * s, 230 * s,
      )
      ..cubicTo(
        12 * s, 250 * s,
        12 * s, 270 * s,
        12 * s, 295 * s,
      )
      ..lineTo(12 * s, 318 * s); // heel
    path.addPath(legBack, Offset.zero);

    return path;
  }

  @override
  bool shouldRepaint(_SilhouettePainter oldDelegate) =>
      oldDelegate.position != position || oldDelegate.opacity != opacity;
}

/// Converts a [BodyPosition] enum to a display label.
extension BodyPositionLabel on BodyPosition {
  String get label => switch (this) {
        BodyPosition.front => 'Fronte',
        BodyPosition.back => 'Retro',
        BodyPosition.right => 'Destra',
        BodyPosition.left => 'Sinistra',
      };

  /// Maps the string value stored in the API to [BodyPosition].
  static BodyPosition fromString(String value) {
    final v = value.toUpperCase().replaceAll('_SIDE', '');
    return switch (v) {
      'BACK' => BodyPosition.back,
      'RIGHT' => BodyPosition.right,
      'LEFT' => BodyPosition.left,
      _ => BodyPosition.front,
    };
  }
}
