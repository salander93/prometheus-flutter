import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Interactive photo widget with pan (drag) and pinch-to-zoom.
class PhotoCanvas extends StatefulWidget {
  const PhotoCanvas({
    required this.imageBytes,
    required this.scale,
    required this.offset,
    required this.onScaleChanged,
    required this.onOffsetChanged,
    this.minScale = 0.3,
    this.maxScale = 3.0,
    super.key,
  });

  final Uint8List imageBytes;
  final double scale;
  final Offset offset;
  final ValueChanged<double> onScaleChanged;
  final ValueChanged<Offset> onOffsetChanged;
  final double minScale;
  final double maxScale;

  @override
  State<PhotoCanvas> createState() => _PhotoCanvasState();
}

class _PhotoCanvasState extends State<PhotoCanvas> {
  double _baseScale = 1;
  Offset _baseOffset = Offset.zero;
  Offset _lastFocalPoint = Offset.zero;

  void _onScaleStart(ScaleStartDetails details) {
    _baseScale = widget.scale;
    _baseOffset = widget.offset;
    _lastFocalPoint = details.focalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final newScale = (_baseScale * details.scale)
        .clamp(widget.minScale, widget.maxScale);
    final delta = details.focalPoint - _lastFocalPoint;
    final newOffset = Offset(
      widget.offset.dx + delta.dx,
      widget.offset.dy + delta.dy,
    );
    _lastFocalPoint = details.focalPoint;

    widget.onScaleChanged(newScale);
    widget.onOffsetChanged(newOffset);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      behavior: HitTestBehavior.opaque,
      child: SizedBox.expand(
        child: ClipRect(
          child: Transform(
            transform: Matrix4.identity()
              ..translate(
                widget.offset.dx,
                widget.offset.dy,
              )
              ..scale(widget.scale),
            alignment: Alignment.center,
            child: Image.memory(
              widget.imageBytes,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
