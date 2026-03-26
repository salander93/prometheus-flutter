import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:palestra/core/api/api_constants.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/presentation/shared/providers/'
    'body_check_providers.dart';

// ---------------------------------------------------------
// Constants
// ---------------------------------------------------------

const _kBeforeColor = Color(0xFFFF6B6B);
const _kAfterColor = Color(0xFF51CF66);

const _kPositions = <(String, String)>[
  ('FRONT', 'Frontale'),
  ('BACK', 'Posteriore'),
  ('RIGHT', 'Lato DX'),
  ('LEFT', 'Lato SX'),
];

// ---------------------------------------------------------
// Timeline photo model
// ---------------------------------------------------------

class _TimelinePhoto {
  const _TimelinePhoto({
    required this.bodyCheckId,
    required this.photoUrl,
    required this.date,
    this.weightKg,
    this.bodyFatPercent,
  });

  final int bodyCheckId;
  final String photoUrl;
  final String date;
  final double? weightKg;
  final double? bodyFatPercent;
}

// ---------------------------------------------------------
// URL helper
// ---------------------------------------------------------

String _fullUrl(String url) {
  if (url.startsWith('http')) return url;
  return '${ApiConstants.baseUrl}$url';
}

// ---------------------------------------------------------
// Screen
// ---------------------------------------------------------

class BodyCheckCompareScreen extends ConsumerStatefulWidget {
  const BodyCheckCompareScreen({super.key});

  @override
  ConsumerState<BodyCheckCompareScreen> createState() =>
      _BodyCheckCompareScreenState();
}

class _BodyCheckCompareScreenState
    extends ConsumerState<BodyCheckCompareScreen> {
  String _position = 'FRONT';
  String _mode = 'sidebyside';
  _TimelinePhoto? _before;
  _TimelinePhoto? _after;
  double _sliderPosition = 0.5;
  double _overlayOpacity = 0.5;
  List<_TimelinePhoto> _photos = [];

  @override
  void initState() {
    super.initState();
    // Defer first load until provider is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reloadPhotos();
    });
  }

  // ── Build photo list from body checks ──

  void _reloadPhotos() {
    final asyncChecks = ref.read(bodyChecksProvider);
    final checks = asyncChecks.valueOrNull;
    if (checks == null) return;

    final result = <_TimelinePhoto>[];
    for (final bc in checks) {
      for (final p in bc.photos) {
        if (p.position.toUpperCase() == _position) {
          result.add(
            _TimelinePhoto(
              bodyCheckId: bc.id,
              photoUrl: _fullUrl(p.photo),
              date: bc.date,
              weightKg: bc.weightKg,
              bodyFatPercent: bc.bodyFatPercent,
            ),
          );
        }
      }
    }

    // Sort chronologically (oldest first).
    result.sort((a, b) => a.date.compareTo(b.date));

    // Try to preserve selected dates when switching position
    final prevBeforeDate = _before?.date;
    final prevAfterDate = _after?.date;

    setState(() {
      _photos = result;
      _before = null;
      _after = null;

      // Try to match previously selected dates in new position
      if (prevBeforeDate != null) {
        _before = result.cast<_TimelinePhoto?>().firstWhere(
          (p) => p!.date == prevBeforeDate,
          orElse: () => null,
        );
      }
      if (prevAfterDate != null) {
        _after = result.cast<_TimelinePhoto?>().firstWhere(
          (p) => p!.date == prevAfterDate,
          orElse: () => null,
        );
      }

      // Fallback: auto-select last two if no match found
      if (_before == null && _after == null) {
        if (result.length >= 2) {
          _before = result[result.length - 2];
          _after = result[result.length - 1];
        } else if (result.length == 1) {
          _before = result.first;
        }
      }
    });
  }

  void _onPositionChanged(String pos) {
    _position = pos;
    _reloadPhotos();
  }

  void _onTimelineTap(_TimelinePhoto photo) {
    setState(() {
      // Tap on already-selected before: clear it.
      if (_before != null &&
          _before!.bodyCheckId == photo.bodyCheckId &&
          _before!.photoUrl == photo.photoUrl) {
        _before = null;
        return;
      }
      // Tap on already-selected after: clear it.
      if (_after != null &&
          _after!.bodyCheckId == photo.bodyCheckId &&
          _after!.photoUrl == photo.photoUrl) {
        _after = null;
        return;
      }

      // First slot empty → set before.
      if (_before == null) {
        _before = photo;
        _autoSort();
        return;
      }
      // Second slot empty → set after.
      if (_after == null) {
        _after = photo;
        _autoSort();
        return;
      }

      // Both filled: shift before→after, new→before,
      // then auto-sort.
      _before = _after;
      _after = photo;
      _autoSort();
    });
  }

  /// Ensure _before is always the older photo.
  void _autoSort() {
    if (_before == null || _after == null) return;
    if (_before!.date.compareTo(_after!.date) > 0) {
      final tmp = _before;
      _before = _after;
      _after = tmp;
    }
  }

  bool _isBefore(_TimelinePhoto p) =>
      _before != null &&
      _before!.bodyCheckId == p.bodyCheckId &&
      _before!.photoUrl == p.photoUrl;

  bool _isAfter(_TimelinePhoto p) =>
      _after != null &&
      _after!.bodyCheckId == p.bodyCheckId &&
      _after!.photoUrl == p.photoUrl;

  @override
  Widget build(BuildContext context) {
    // Watch provider to rebuild when data arrives.
    final asyncChecks = ref.watch(bodyChecksProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundBase,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundBase,
        title: const Text('Confronto Progressi'),
      ),
      body: asyncChecks.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (_, __) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: AppColors.danger,
              ),
              const SizedBox(height: 12),
              const Text('Errore nel caricamento'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    ref.invalidate(bodyChecksProvider),
                child: const Text('Riprova'),
              ),
            ],
          ),
        ),
        data: (checks) {
          // Ensure photos are loaded on first data.
          if (_photos.isEmpty && checks.isNotEmpty) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) {
              _reloadPhotos();
            });
          }
          return _buildBody(context);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        // Position tabs
        _PositionTabs(
          selected: _position,
          onSelected: _onPositionChanged,
        ),

        // Mode selector
        _ModeSelector(
          mode: _mode,
          onChanged: (m) => setState(() => _mode = m),
        ),

        const SizedBox(height: 8),

        // Comparison area
        Expanded(child: _buildComparison()),

        // Timeline
        _Timeline(
          photos: _photos,
          isBefore: _isBefore,
          isAfter: _isAfter,
          onTap: _onTimelineTap,
        ),
      ],
    );
  }

  Widget _buildComparison() {
    if (_photos.isEmpty) {
      return const _EmptyPositionState();
    }

    switch (_mode) {
      case 'slider':
        return _SliderMode(
          before: _before,
          after: _after,
          position: _sliderPosition,
          onPositionChanged: (v) =>
              setState(() => _sliderPosition = v),
        );
      case 'overlay':
        return _OverlayMode(
          before: _before,
          after: _after,
          opacity: _overlayOpacity,
          onOpacityChanged: (v) =>
              setState(() => _overlayOpacity = v),
        );
      default:
        return _SideBySideMode(
          before: _before,
          after: _after,
        );
    }
  }
}

// ---------------------------------------------------------
// Position tabs
// ---------------------------------------------------------

class _PositionTabs extends StatelessWidget {
  const _PositionTabs({
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      decoration: const BoxDecoration(
        color: AppColors.backgroundCard,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding:
              const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _kPositions.length,
          separatorBuilder: (_, __) =>
              const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final (value, label) = _kPositions[index];
            final active = value == selected;
            return GestureDetector(
              onTap: () => onSelected(value),
              child: AnimatedContainer(
                duration:
                    const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.primary
                      : AppColors.backgroundCardHover,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: active
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: active
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: active
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// Mode selector
// ---------------------------------------------------------

class _ModeSelector extends StatelessWidget {
  const _ModeSelector({
    required this.mode,
    required this.onChanged,
  });

  final String mode;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          _ModeButton(
            label: 'Affiancate',
            icon: Icons.view_column_rounded,
            isActive: mode == 'sidebyside',
            onTap: () => onChanged('sidebyside'),
          ),
          const SizedBox(width: 8),
          _ModeButton(
            label: 'Slider',
            icon: Icons.swap_horiz_rounded,
            isActive: mode == 'slider',
            onTap: () => onChanged('slider'),
          ),
          const SizedBox(width: 8),
          _ModeButton(
            label: 'Overlay',
            icon: Icons.layers_rounded,
            isActive: mode == 'overlay',
            onTap: () => onChanged('overlay'),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                    .withValues(alpha: 0.2)
                : AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive
                  ? AppColors.primary
                      .withValues(alpha: 0.5)
                  : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isActive
                    ? AppColors.primary
                    : AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isActive
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: isActive
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// Side-by-side mode
// ---------------------------------------------------------

class _SideBySideMode extends StatelessWidget {
  const _SideBySideMode({
    required this.before,
    required this.after,
  });

  final _TimelinePhoto? before;
  final _TimelinePhoto? after;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SideBySidePanel(
            photo: before,
            label: 'Prima',
            labelColor: _kBeforeColor,
          ),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: _SideBySidePanel(
            photo: after,
            label: 'Dopo',
            labelColor: _kAfterColor,
          ),
        ),
      ],
    );
  }
}

class _SideBySidePanel extends StatelessWidget {
  const _SideBySidePanel({
    required this.photo,
    required this.label,
    required this.labelColor,
  });

  final _TimelinePhoto? photo;
  final String label;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundDeepest,
        border: Border(
          top: BorderSide(color: labelColor, width: 3),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (photo != null)
            InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: CachedNetworkImage(
                imageUrl: photo!.photoUrl,
                fit: BoxFit.contain,
                placeholder: (_, __) => const ColoredBox(
                  color: AppColors.backgroundCard,
                ),
                errorWidget: (_, __, ___) =>
                    const _NoPhotoPlaceholder(),
              ),
            )
          else
            const _NoPhotoPlaceholder(),

          // Label
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: labelColor
                      .withValues(alpha: 0.85),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),

          // Info at bottom
          if (photo != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _PhotoInfo(photo: photo!),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// Slider mode
// ---------------------------------------------------------

class _SliderMode extends StatelessWidget {
  const _SliderMode({
    required this.before,
    required this.after,
    required this.position,
    required this.onPositionChanged,
  });

  final _TimelinePhoto? before;
  final _TimelinePhoto? after;
  final double position;
  final ValueChanged<double> onPositionChanged;

  @override
  Widget build(BuildContext context) {
    if (before == null && after == null) {
      return const _NoPhotoPlaceholder();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final clipX = width * position;

        return GestureDetector(
          onHorizontalDragUpdate: (d) {
            final newPos =
                (d.localPosition.dx / width)
                    .clamp(0.0, 1.0);
            onPositionChanged(newPos);
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // After image (full, behind)
              if (after != null)
                CachedNetworkImage(
                  imageUrl: after!.photoUrl,
                  fit: BoxFit.contain,
                  placeholder: (_, __) =>
                      const ColoredBox(
                    color:
                        AppColors.backgroundDeepest,
                  ),
                  errorWidget: (_, __, ___) =>
                      const _NoPhotoPlaceholder(),
                )
              else
                const ColoredBox(
                  color: AppColors.backgroundDeepest,
                ),

              // Before image (clipped from left)
              if (before != null)
                ClipRect(
                  clipper: _LeftClipper(clipX),
                  child: CachedNetworkImage(
                    imageUrl: before!.photoUrl,
                    fit: BoxFit.contain,
                    width: width,
                    placeholder: (_, __) =>
                        const ColoredBox(
                      color:
                          AppColors.backgroundDeepest,
                    ),
                    errorWidget: (_, __, ___) =>
                        const _NoPhotoPlaceholder(),
                  ),
                ),

              // Divider line
              Positioned(
                left: clipX - 1,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: Colors.white,
                ),
              ),

              // Handle
              Positioned(
                left: clipX - 22,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: 0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.swap_horiz_rounded,
                      color: Colors.black87,
                      size: 24,
                    ),
                  ),
                ),
              ),

              // Labels
              const Positioned(
                top: 10,
                left: 12,
                child: _ModeLabel(
                  text: 'PRIMA',
                  color: _kBeforeColor,
                ),
              ),
              const Positioned(
                top: 10,
                right: 12,
                child: _ModeLabel(
                  text: 'DOPO',
                  color: _kAfterColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LeftClipper extends CustomClipper<Rect> {
  _LeftClipper(this.clipWidth);

  final double clipWidth;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, clipWidth, size.height);

  @override
  bool shouldReclip(_LeftClipper old) =>
      old.clipWidth != clipWidth;
}

// ---------------------------------------------------------
// Overlay mode
// ---------------------------------------------------------

class _OverlayMode extends StatelessWidget {
  const _OverlayMode({
    required this.before,
    required this.after,
    required this.opacity,
    required this.onOpacityChanged,
  });

  final _TimelinePhoto? before;
  final _TimelinePhoto? after;
  final double opacity;
  final ValueChanged<double> onOpacityChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ColoredBox(
            color: AppColors.backgroundDeepest,
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Before (base)
                  if (before != null)
                    CachedNetworkImage(
                      imageUrl: before!.photoUrl,
                      fit: BoxFit.contain,
                      placeholder: (_, __) =>
                          const SizedBox.shrink(),
                      errorWidget: (_, __, ___) =>
                          const _NoPhotoPlaceholder(),
                    )
                  else
                    const _NoPhotoPlaceholder(),

                  // After (overlay with opacity)
                  if (after != null)
                    Opacity(
                      opacity: opacity,
                      child: CachedNetworkImage(
                        imageUrl: after!.photoUrl,
                        fit: BoxFit.contain,
                        placeholder: (_, __) =>
                            const SizedBox.shrink(),
                      errorWidget: (_, __, ___) =>
                          const SizedBox.shrink(),
                    ),
                  ),
              ],
            ),
          ),
          ),
        ),

        // Opacity slider
        _GradientOpacitySlider(
          value: opacity,
          onChanged: onOpacityChanged,
        ),
      ],
    );
  }
}

class _GradientOpacitySlider extends StatelessWidget {
  const _GradientOpacitySlider({
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          const Text(
            'Prima',
            style: TextStyle(
              color: _kBeforeColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: _kAfterColor,
                inactiveTrackColor: _kBeforeColor,
                thumbColor: Colors.white,
                overlayColor:
                    Colors.white.withValues(alpha: 0.15),
                trackHeight: 4,
              ),
              child: Slider(
                value: value,
                onChanged: onChanged,
              ),
            ),
          ),
          const Text(
            'Dopo',
            style: TextStyle(
              color: _kAfterColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// Mode label (used in slider/overlay)
// ---------------------------------------------------------

class _ModeLabel extends StatelessWidget {
  const _ModeLabel({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundDeepest
            .withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.6),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// Photo info overlay (date, weight, body fat)
// ---------------------------------------------------------

class _PhotoInfo extends StatelessWidget {
  const _PhotoInfo({required this.photo});

  final _TimelinePhoto photo;

  @override
  Widget build(BuildContext context) {
    final dateStr = _fmtDate(photo.date);
    final parts = <String>[dateStr];
    if (photo.weightKg != null) {
      parts.add(
        '${photo.weightKg!.toStringAsFixed(1)} kg',
      );
    }
    if (photo.bodyFatPercent != null) {
      parts.add(
        '${photo.bodyFatPercent!.toStringAsFixed(1)}%',
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.backgroundDeepest
                .withValues(alpha: 0.9),
            Colors.transparent,
          ],
        ),
      ),
      child: Text(
        parts.join(' | '),
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String _fmtDate(String d) {
    try {
      final dt = DateTime.parse(d);
      return DateFormat('d MMM yy', 'it').format(dt);
    } catch (_) {
      return d;
    }
  }
}

// ---------------------------------------------------------
// Timeline
// ---------------------------------------------------------

class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.photos,
    required this.isBefore,
    required this.isAfter,
    required this.onTap,
  });

  final List<_TimelinePhoto> photos;
  final bool Function(_TimelinePhoto) isBefore;
  final bool Function(_TimelinePhoto) isAfter;
  final void Function(_TimelinePhoto) onTap;

  @override
  Widget build(BuildContext context) {
    final bottomPad =
        MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        0,
        10,
        0,
        8 + bottomPad,
      ),
      decoration: const BoxDecoration(
        color: AppColors.backgroundCard,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title + badges
          const Padding(
            padding:
                EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Seleziona due foto '
                    'da confrontare',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _SelectionBadge(
                  label: '1. Prima',
                  color: _kBeforeColor,
                ),
                SizedBox(width: 8),
                _SelectionBadge(
                  label: '2. Dopo',
                  color: _kAfterColor,
                ),
              ],
            ),
          ),

          // Thumbnails
          if (photos.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Text(
                'Nessuna foto per questa '
                'posizione',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            )
          else
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                itemCount: photos.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final p = photos[i];
                  final before = isBefore(p);
                  final after = isAfter(p);
                  return _TimelineThumbnail(
                    photo: p,
                    isBefore: before,
                    isAfter: after,
                    onTap: () => onTap(p),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _SelectionBadge extends StatelessWidget {
  const _SelectionBadge({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TimelineThumbnail extends StatelessWidget {
  const _TimelineThumbnail({
    required this.photo,
    required this.isBefore,
    required this.isAfter,
    required this.onTap,
  });

  final _TimelinePhoto photo;
  final bool isBefore;
  final bool isAfter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = isBefore || isAfter;
    final borderColor = isBefore
        ? _kBeforeColor
        : isAfter
            ? _kAfterColor
            : AppColors.border;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
            width: selected ? 2.5 : 1,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: photo.photoUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => const ColoredBox(
                color: AppColors.backgroundCardHover,
              ),
              errorWidget: (_, __, ___) =>
                  const ColoredBox(
                color: AppColors.backgroundCardHover,
                child: Icon(
                  Icons.broken_image_rounded,
                  color: AppColors.textMuted,
                  size: 20,
                ),
              ),
            ),

            // Selection marker
            if (selected)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: borderColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: 0.4),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      isBefore ? '1' : '2',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),

            // Date label at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 2,
                ),
                color: AppColors.backgroundDeepest
                    .withValues(alpha: 0.75),
                child: Text(
                  _fmtDate(photo.date),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmtDate(String d) {
    try {
      final dt = DateTime.parse(d);
      return DateFormat('d/M/yy').format(dt);
    } catch (_) {
      return d;
    }
  }
}

// ---------------------------------------------------------
// Empty state (no photos for current position)
// ---------------------------------------------------------

class _EmptyPositionState extends StatelessWidget {
  const _EmptyPositionState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hide_image_outlined,
            size: 56,
            color: AppColors.textMuted,
          ),
          SizedBox(height: 12),
          Text(
            'Nessuna foto per\n'
            'questa posizione',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// No photo placeholder
// ---------------------------------------------------------

class _NoPhotoPlaceholder extends StatelessWidget {
  const _NoPhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.backgroundDeepest,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hide_image_outlined,
              size: 40,
              color: AppColors.textMuted,
            ),
            SizedBox(height: 8),
            Text(
              'Foto non\ndisponibile',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
