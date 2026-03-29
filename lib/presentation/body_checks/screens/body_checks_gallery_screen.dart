import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/body_check_model.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';
import 'package:palestra/presentation/shared/providers/body_check_providers.dart';
import 'package:shimmer/shimmer.dart';

// ---------------------------------------------------------------------------
// Gallery screen
// ---------------------------------------------------------------------------

class BodyChecksGalleryScreen extends ConsumerWidget {
  const BodyChecksGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final isTrainer =
        userAsync.valueOrNull?.role == 'TRAINER';
    final bodyChecksAsync = ref.watch(bodyChecksProvider);

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(isTrainer: isTrainer),
            Expanded(
              child: bodyChecksAsync.when(
                data: (checks) => RefreshIndicator(
                  onRefresh: () async =>
                      ref.invalidate(bodyChecksProvider),
                  child: _BodyCheckGrid(
                    checks: checks,
                    isTrainer: isTrainer,
                  ),
                ),
                loading: _GridShimmer.new,
                error: (err, _) => _ErrorBody(
                  onRetry: () => ref.invalidate(bodyChecksProvider),
                ),
              ),
            ),
          ],
        ),
        if (!isTrainer)
          Positioned(
            right: 16,
            bottom: 96,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if ((bodyChecksAsync.valueOrNull?.length ??
                        0) >=
                    2)
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 12),
                    child: FloatingActionButton.small(
                      heroTag: 'compare',
                      onPressed: () => context
                          .push('/body-checks/compare'),
                      backgroundColor:
                          AppColors.backgroundCard,
                      foregroundColor:
                          AppColors.textPrimary,
                      child: const Icon(
                        Icons.compare_rounded,
                      ),
                    ),
                  ),
                FloatingActionButton.extended(
                  heroTag: 'create',
                  onPressed: () =>
                      context.push('/body-checks/new'),
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textPrimary,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Nuovo Body Check'),
                ),
              ],
            ),
          ),
      ],
    );
  }

}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.isTrainer});

  final bool isTrainer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        isTrainer ? 'Body Check Clienti' : 'I Miei Body Check',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Grid
// ---------------------------------------------------------------------------

class _BodyCheckGrid extends StatelessWidget {
  const _BodyCheckGrid({
    required this.checks,
    required this.isTrainer,
  });

  final List<BodyCheckModel> checks;
  final bool isTrainer;

  @override
  Widget build(BuildContext context) {
    if (checks.isEmpty) {
      return const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: _EmptyState(),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      itemCount: checks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _BodyCheckRow(
        bodyCheck: checks[index],
        showClientName: isTrainer,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Row layout (PWA-style: date + horizontal photo strip + info)
// ---------------------------------------------------------------------------

class _BodyCheckRow extends StatelessWidget {
  const _BodyCheckRow({
    required this.bodyCheck,
    required this.showClientName,
  });

  final BodyCheckModel bodyCheck;
  final bool showClientName;

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(bodyCheck.date);
    final commentCount = bodyCheck.commentCount;

    return GestureDetector(
      onTap: () => context.push('/body-checks/${bodyCheck.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (showClientName && bodyCheck.clientName.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Text(
                    bodyCheck.clientName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Horizontal photo strip
          SizedBox(
            height: 160,
            child: bodyCheck.photos.isEmpty
                ? Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCard,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.accessibility_new_rounded,
                        size: 48,
                        color: AppColors.textMuted,
                      ),
                    ),
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: bodyCheck.photos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (context, index) {
                      final photo = bodyCheck.photos[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          photo.photo,
                          width: 130,
                          height: 160,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              width: 130,
                              height: 160,
                              color: AppColors.backgroundCardHover,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => Container(
                            width: 130,
                            height: 160,
                            color: AppColors.backgroundCardHover,
                            child: const Icon(
                              Icons.broken_image_rounded,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Info row: photo count + comments
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              '${bodyCheck.photoCount} foto   $commentCount commenti',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMMM yyyy', 'en').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}

// ---------------------------------------------------------------------------
// Photo thumbnail
// ---------------------------------------------------------------------------

class _PhotoThumbnail extends StatelessWidget {
  const _PhotoThumbnail({
    required this.photo,
    required this.photoCount,
  });

  final BodyCheckPhoto? photo;
  final int photoCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (photo != null)
          Image.network(
            photo!.photo,
            fit: BoxFit.cover,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return const ColoredBox(
                color: AppColors.backgroundCardHover,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              );
            },
            errorBuilder: (_, __, ___) => const _PhotoPlaceholder(),
          )
        else
          const _PhotoPlaceholder(),
        if (photoCount > 0)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.backgroundDeepest.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.photo_library_rounded,
                    size: 12,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$photoCount',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.backgroundCardHover,
      child: Center(
        child: Icon(
          Icons.accessibility_new_rounded,
          size: 48,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card info
// ---------------------------------------------------------------------------

class _CardInfo extends StatelessWidget {
  const _CardInfo({
    required this.bodyCheck,
    required this.showClientName,
  });

  final BodyCheckModel bodyCheck;
  final bool showClientName;

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(bodyCheck.date);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showClientName && bodyCheck.clientName.isNotEmpty) ...[
            Text(
              bodyCheck.clientName,
              style: const TextStyle(
                color: AppColors.secondary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
          ],
          Text(
            bodyCheck.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            dateStr,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
          ),
          if (bodyCheck.weightKg != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.monitor_weight_outlined,
                  size: 12,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  '${bodyCheck.weightKg!.toStringAsFixed(1)} kg',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('d MMM yyyy', 'it').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.accessibility_new_rounded,
            size: 72,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 20),
          Text(
            'Nessun body check',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Inizia a tracciare i tuoi progressi',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shimmer loading
// ---------------------------------------------------------------------------

class _GridShimmer extends StatelessWidget {
  const _GridShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundCard,
      highlightColor: AppColors.backgroundCardHover,
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error body
// ---------------------------------------------------------------------------

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: AppColors.danger,
          ),
          const SizedBox(height: 12),
          Text(
            'Errore nel caricamento',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onRetry,
            child: const Text('Riprova'),
          ),
        ],
      ),
    );
  }
}
