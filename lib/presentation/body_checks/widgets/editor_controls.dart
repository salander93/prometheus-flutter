import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';

/// Display modes for the reference photo overlay.
enum ReferenceMode {
  /// Solid silhouette overlay.
  silhouette,

  /// Edge/outline overlay.
  outline,

  /// Original photo overlay.
  original,
}

/// Bottom bar with zoom controls: minus button, slider, plus button.
class ZoomControls extends StatelessWidget {
  const ZoomControls({
    required this.zoom,
    required this.onZoomChanged,
    this.min = 0.3,
    this.max = 3.0,
    super.key,
  });

  final double zoom;
  final ValueChanged<double> onZoomChanged;
  final double min;
  final double max;

  static const _buttonSize = 44.0;
  static const _sliderWidth = 150.0;
  static const _step = 0.1;
  static const _bgColor = Color(0xCC000000);
  static const _buttonBg = Color(0x33FFFFFF);
  static const _inactiveTrack = Color(0x33FFFFFF);
  static const _borderRadius = 24.0;
  static const _padding = 8.0;

  void _decrement() {
    final next = (zoom - _step).clamp(min, max);
    onZoomChanged(next);
  }

  void _increment() {
    final next = (zoom + _step).clamp(min, max);
    onZoomChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(_padding),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CircleIconButton(
              icon: Icons.remove,
              onPressed: _decrement,
              size: _buttonSize,
              background: _buttonBg,
            ),
            SizedBox(
              width: _sliderWidth,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: _inactiveTrack,
                  thumbColor: AppColors.primary,
                  overlayColor: AppColors.primary.withValues(alpha: 0.2),
                ),
                child: Slider(
                  value: zoom,
                  min: min,
                  max: max,
                  onChanged: onZoomChanged,
                ),
              ),
            ),
            _CircleIconButton(
              icon: Icons.add,
              onPressed: _increment,
              size: _buttonSize,
              background: _buttonBg,
            ),
          ],
        ),
      ),
    );
  }
}

/// Controls for the reference photo overlay.
///
/// Shows a toggle, mode chips, and opacity slider.
class ReferenceControls extends StatelessWidget {
  const ReferenceControls({
    required this.showReference,
    required this.onShowReferenceChanged,
    required this.mode,
    required this.onModeChanged,
    required this.opacity,
    required this.onOpacityChanged,
    super.key,
  });

  final bool showReference;
  final ValueChanged<bool> onShowReferenceChanged;
  final ReferenceMode mode;
  final ValueChanged<ReferenceMode> onModeChanged;
  final double opacity;
  final ValueChanged<double> onOpacityChanged;

  static const _bgColor = Color(0xCC000000);
  static const _borderRadius = 16.0;
  static const _padding = 12.0;
  static const _opacityMin = 0.1;
  static const _opacityMax = 0.9;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(_padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ToggleRow(
              value: showReference,
              onChanged: onShowReferenceChanged,
            ),
            const SizedBox(height: 8),
            _ModeRow(
              selected: mode,
              onChanged: onModeChanged,
            ),
            const SizedBox(height: 8),
            _OpacityRow(
              opacity: opacity,
              onChanged: onOpacityChanged,
              min: _opacityMin,
              max: _opacityMax,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private sub-widgets
// ---------------------------------------------------------------------------

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onPressed,
    required this.size,
    required this.background,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: background,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Icon(icon, color: Colors.white, size: size * 0.5),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            activeColor: AppColors.primary,
            side: const BorderSide(color: Colors.white54),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Mostra riferimento',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _ModeRow extends StatelessWidget {
  const _ModeRow({
    required this.selected,
    required this.onChanged,
  });

  final ReferenceMode selected;
  final ValueChanged<ReferenceMode> onChanged;

  static const _modes = [
    (ReferenceMode.silhouette, 'Silhouette'),
    (ReferenceMode.outline, 'Contorno'),
    (ReferenceMode.original, 'Originale'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: _modes.map((entry) {
        final (modeValue, label) = entry;
        final isSelected = selected == modeValue;
        return ChoiceChip(
          label: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 12,
            ),
          ),
          selected: isSelected,
          onSelected: (_) => onChanged(modeValue),
          selectedColor: AppColors.primary,
          backgroundColor: const Color(0x33FFFFFF),
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 8),
        );
      }).toList(),
    );
  }
}

class _OpacityRow extends StatelessWidget {
  const _OpacityRow({
    required this.opacity,
    required this.onChanged,
    required this.min,
    required this.max,
  });

  final double opacity;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Opacità',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: const Color(0x33FFFFFF),
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: opacity,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
