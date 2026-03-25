import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/presentation/body_checks/widgets/body_silhouette.dart';
import 'package:palestra/presentation/body_checks/widgets/editor_controls.dart';

class PhotoEditorScreen extends StatefulWidget {
  const PhotoEditorScreen({
    required this.imageBytes,
    required this.position,
    required this.positionLabel,
    this.referenceImageBytes,
    super.key,
  });

  final Uint8List imageBytes;
  final String position;
  final String positionLabel;
  final Uint8List? referenceImageBytes;

  @override
  State<PhotoEditorScreen> createState() =>
      _PhotoEditorScreenState();
}

class _PhotoEditorScreenState
    extends State<PhotoEditorScreen> {
  double _scale = 1;
  Offset _offset = Offset.zero;
  bool _showRef = true;
  ReferenceMode _refMode = ReferenceMode.silhouette;
  double _refOpacity = 0.5;
  bool _isCropping = false;

  BodyPosition get _bodyPos =>
      BodyPositionLabel.fromString(widget.position);

  // ── Color filters ─────────────────────────────────

  static const _grayscale = <double>[
    0.33, 0.33, 0.33, 0, 0,
    0.33, 0.33, 0.33, 0, 0,
    0.33, 0.33, 0.33, 0, 0,
    0, 0, 0, 1, 0,
  ];
  static const _outline = <double>[
    -0.33, -0.33, -0.33, 0, 255,
    -0.33, -0.33, -0.33, 0, 255,
    -0.33, -0.33, -0.33, 0, 255,
    0, 0, 0, 1, 0,
  ];

  ColorFilter? get _refFilter => switch (_refMode) {
        ReferenceMode.silhouette =>
          const ColorFilter.matrix(_grayscale),
        ReferenceMode.outline =>
          const ColorFilter.matrix(_outline),
        ReferenceMode.original => null,
      };

  // ── Actions ───────────────────────────────────────

  void _cancel() =>
      Navigator.of(context).pop<Uint8List?>();

  Future<void> _confirm() async {
    setState(() => _isCropping = true);
    try {
      final result = await _cropMath();
      if (mounted) {
        Navigator.of(context).pop<Uint8List?>(result);
      }
    } catch (e) {
      debugPrint('Crop error: $e');
      if (mounted) {
        Navigator.of(context)
            .pop<Uint8List?>(widget.imageBytes);
      }
    }
  }

  /// Pure math crop — fast, no screenshot needed.
  ///
  /// The photo is displayed with BoxFit.contain inside
  /// the crop frame (cropW × cropH). The user can zoom
  /// (_scale) and pan (_offset) relative to the center
  /// of the crop frame. We map the crop frame back to
  /// original image pixels.
  Future<Uint8List> _cropMath() async {
    final original = img.decodeImage(widget.imageBytes);
    if (original == null) return widget.imageBytes;

    final screen = MediaQuery.sizeOf(context);
    final cropW = screen.width * 0.80;
    final cropH = cropW / (3 / 4);

    // How the image fits inside the crop frame with
    // BoxFit.contain (before any user zoom/pan).
    final imgAspect = original.width / original.height;
    final cropAspect = cropW / cropH;

    double fitW, fitH;
    if (imgAspect > cropAspect) {
      // Image is wider than crop frame
      fitW = cropW;
      fitH = cropW / imgAspect;
    } else {
      // Image is taller than crop frame
      fitH = cropH;
      fitW = cropH * imgAspect;
    }

    // After user zoom
    final scaledW = fitW * _scale;
    final scaledH = fitH * _scale;

    // Image center in crop-frame space (0,0 = center)
    // _offset is relative to crop frame center
    final imgCx = cropW / 2 + _offset.dx;
    final imgCy = cropH / 2 + _offset.dy;

    // Image top-left in crop frame space
    final imgL = imgCx - scaledW / 2;
    final imgT = imgCy - scaledH / 2;

    // Pixels per screen pixel
    final pxPerSp = original.width / scaledW;

    // Map crop frame (0,0,cropW,cropH) to image pixels
    final srcX = (-imgL * pxPerSp).round();
    final srcY = (-imgT * pxPerSp).round();
    final srcW = (cropW * pxPerSp).round();
    final srcH = (cropH * pxPerSp).round();

    // Clamp to image bounds
    final x = srcX.clamp(0, original.width - 1);
    final y = srcY.clamp(0, original.height - 1);
    final w = srcW.clamp(1, original.width - x);
    final h = srcH.clamp(1, original.height - y);

    var cropped = img.copyCrop(
      original,
      x: x,
      y: y,
      width: w,
      height: h,
    );

    cropped = img.copyResize(
      cropped,
      width: 800,
      height: 1067,
    );

    return Uint8List.fromList(
      img.encodeJpg(cropped, quality: 90),
    );
  }

  // ── Build ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final hasRef = widget.referenceImageBytes != null;
    final screen = MediaQuery.sizeOf(context);
    final cropW = screen.width * 0.80;
    final cropH = cropW / (3 / 4);

    // The photo and reference are BOTH rendered inside
    // the crop frame with BoxFit.contain. This is the
    // key — same container, same fit, same coordinates.
    // The reference (800x1067) fills the frame exactly.
    // The new photo is fitted and then user adjusts.

    Widget photoInFrame = Image.memory(
      widget.imageBytes,
      fit: BoxFit.contain,
    );

    // Apply user transform
    photoInFrame = Transform(
      transform: Matrix4.identity()
        ..translate(_offset.dx, _offset.dy)
        ..scale(_scale),
      alignment: Alignment.center,
      child: photoInFrame,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Dark background
          const ColoredBox(color: Colors.black),

          // Photo visible everywhere (for context)
          IgnorePointer(
            child: Opacity(
              opacity: 0.3,
              child: SizedBox.expand(
                child: ClipRect(
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(
                        _offset.dx,
                        _offset.dy,
                      )
                      ..scale(_scale),
                    alignment: Alignment.center,
                    child: Image.memory(
                      widget.imageBytes,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Crop frame area — this is THE view
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                width: cropW,
                height: cropH,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(
                      color: Colors.black,
                    ),
                    // New photo (user can move)
                    ClipRect(child: photoInFrame),
                    // Reference on top
                    if (hasRef && _showRef)
                      Opacity(
                        opacity: _refOpacity,
                        child: _filtered(
                          widget.referenceImageBytes!,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Silhouette guide
          IgnorePointer(
            child: BodySilhouette(position: _bodyPos),
          ),

          // Crop frame border
          IgnorePointer(
            child: CustomPaint(
              painter: const _FramePainter(),
              size: Size.infinite,
            ),
          ),

          // Gesture layer
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            child: const SizedBox.expand(),
          ),

          // Header
          _buildHeader(),

          // Instruction
          _buildInstruction(),

          // Bottom controls
          _buildControls(hasRef),

          // Cropping overlay
          if (_isCropping) _buildCroppingOverlay(),
        ],
      ),
    );
  }

  // ── Gesture handling ──────────────────────────────

  double _baseScale = 1;
  Offset _lastFocal = Offset.zero;

  void _onScaleStart(ScaleStartDetails d) {
    _baseScale = _scale;
    _lastFocal = d.focalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails d) {
    final newScale =
        (_baseScale * d.scale).clamp(0.3, 3.0);
    final delta = d.focalPoint - _lastFocal;
    _lastFocal = d.focalPoint;
    setState(() {
      _scale = newScale;
      _offset = Offset(
        _offset.dx + delta.dx,
        _offset.dy + delta.dy,
      );
    });
  }

  // ── Sub-builds ────────────────────────────────────

  Widget _filtered(Uint8List bytes) {
    Widget child = Image.memory(
      bytes,
      fit: BoxFit.contain,
    );
    if (_refFilter != null) {
      child = ColorFiltered(
        colorFilter: _refFilter!,
        child: child,
      );
    }
    return child;
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          children: [
            _Btn(
              bg: const Color(0x33FFFFFF),
              onTap: _cancel,
              icon: Icons.close,
            ),
            Expanded(
              child: Text(
                'Allinea - ${widget.positionLabel}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _Btn(
              bg: AppColors.primary,
              onTap: _confirm,
              icon: Icons.check,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstruction() {
    return IgnorePointer(
      child: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 68),
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0x33FF6B35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Allinea il corpo alla silhouette',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls(bool hasRef) {
    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasRef)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    12,
                  ),
                  child: ReferenceControls(
                    showReference: _showRef,
                    onShowReferenceChanged: (v) =>
                        setState(() => _showRef = v),
                    mode: _refMode,
                    onModeChanged: (v) =>
                        setState(() => _refMode = v),
                    opacity: _refOpacity,
                    onOpacityChanged: (v) =>
                        setState(() => _refOpacity = v),
                  ),
                ),
              ZoomControls(
                zoom: _scale,
                onZoomChanged: (v) =>
                    setState(() => _scale = v),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCroppingOverlay() {
    return const ColoredBox(
      color: Color(0xAA000000),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              'Elaborazione…',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Small widgets ────────────────────────────────────

class _Btn extends StatelessWidget {
  const _Btn({
    required this.bg,
    required this.onTap,
    required this.icon,
  });

  final Color bg;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Material(
        color: bg,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _FramePainter extends CustomPainter {
  const _FramePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final cropW = size.width * 0.80;
    final cropH = cropW / (3 / 4);
    final l = (size.width - cropW) / 2;
    final t = (size.height - cropH) / 2;
    final rect = Rect.fromLTWH(l, t, cropW, cropH);
    final rrect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(4),
    );

    final overlay = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(rrect);
    canvas.drawPath(
      overlay,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.55),
    );

    final bp = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    _dash(canvas, rect.topLeft, rect.topRight, bp);
    _dash(canvas, rect.topRight, rect.bottomRight, bp);
    _dash(canvas, rect.bottomRight, rect.bottomLeft, bp);
    _dash(canvas, rect.bottomLeft, rect.topLeft, bp);
  }

  void _dash(Canvas c, Offset a, Offset b, Paint p) {
    final total = (b - a).distance;
    final dir = (b - a) / total;
    var d = 0.0;
    var on = true;
    while (d < total) {
      final s = on ? 10.0 : 6.0;
      final e = (d + s).clamp(0.0, total);
      if (on) c.drawLine(a + dir * d, a + dir * e, p);
      d = e;
      on = !on;
    }
  }

  @override
  bool shouldRepaint(_FramePainter old) => false;
}
