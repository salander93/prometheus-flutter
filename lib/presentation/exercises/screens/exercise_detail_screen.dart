import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/exercise_model.dart';
import 'package:palestra/presentation/exercises/providers/exercise_providers.dart';
import 'package:shimmer/shimmer.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  const ExerciseDetailScreen({required this.exerciseId, super.key});

  final int exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseAsync = ref.watch(exerciseDetailProvider(exerciseId));

    return Scaffold(
      backgroundColor: AppColors.backgroundBase,
      body: exerciseAsync.when(
        data: (exercise) => _ExerciseDetailBody(exercise: exercise),
        loading: () => _buildShimmer(context),
        error: (err, _) => _buildError(context, err),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundCard,
      highlightColor: AppColors.backgroundCardHover,
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: 300,
            backgroundColor: AppColors.backgroundCard,
            flexibleSpace: FlexibleSpaceBar(),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  height: 28,
                  width: 200,
                  color: AppColors.backgroundCard,
                ),
                const SizedBox(height: 12),
                Container(height: 20, color: AppColors.backgroundCard),
                const SizedBox(height: 24),
                Container(height: 80, color: AppColors.backgroundCard),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, Object err) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: AppColors.backgroundBase,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        SliverFillRemaining(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
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
                  const SizedBox(height: 4),
                  Text(
                    err.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Detail body
// ---------------------------------------------------------------------------

class _ExerciseDetailBody extends StatelessWidget {
  const _ExerciseDetailBody({required this.exercise});

  final ExerciseModel exercise;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildTitle(context),
              const SizedBox(height: 12),
              _buildInfoChips(context),
              if (exercise.description != null &&
                  exercise.description!.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  title: 'Descrizione',
                  icon: Icons.info_outline_rounded,
                  content: exercise.description!,
                ),
              ],
              if (exercise.instructions != null &&
                  exercise.instructions!.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  title: 'Istruzioni',
                  icon: Icons.list_alt_rounded,
                  content: exercise.instructions!,
                ),
              ],
              if (exercise.secondaryMuscles != null &&
                  exercise.secondaryMuscles!.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  title: 'Muscoli secondari',
                  icon: Icons.accessibility_new_rounded,
                  content: exercise.secondaryMuscles!,
                ),
              ],
              if (exercise.videoUrl != null) ...[
                const SizedBox(height: 28),
                _buildVideoButton(context),
              ],
            ]),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Sliver app bar with hero image
  // ---------------------------------------------------------------------------

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.backgroundBase,
      surfaceTintColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundColor: AppColors.backgroundCard.withValues(alpha: 0.85),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: exercise.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: exercise.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => _heroPlaceholder(),
                errorWidget: (context, url, error) => _heroPlaceholder(),
              )
            : _heroPlaceholder(),
      ),
    );
  }

  Widget _heroPlaceholder() {
    return ColoredBox(
      color: AppColors.backgroundCard,
      child: Center(
        child: Icon(
          _muscleGroupIcon(exercise.muscleGroup),
          size: 80,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Title
  // ---------------------------------------------------------------------------

  Widget _buildTitle(BuildContext context) {
    return Text(
      exercise.nameIt ?? exercise.name,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  // ---------------------------------------------------------------------------
  // Info chips row
  // ---------------------------------------------------------------------------

  Widget _buildInfoChips(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _InfoChip(
          label: exercise.muscleGroupDisplay,
          icon: Icons.accessibility_new_rounded,
          color: _muscleGroupColor(exercise.muscleGroup),
        ),
        _InfoChip(
          label: exercise.levelDisplay,
          icon: Icons.bar_chart_rounded,
          color: _levelColor(exercise.level),
        ),
        _InfoChip(
          label: exercise.categoryDisplay,
          icon: Icons.category_outlined,
          color: AppColors.secondary,
        ),
        if (exercise.equipment != null && exercise.equipment!.isNotEmpty)
          _InfoChip(
            label: exercise.equipment!,
            icon: Icons.sports_gymnastics_rounded,
            color: AppColors.accent,
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Section (description / instructions)
  // ---------------------------------------------------------------------------

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Video button
  // ---------------------------------------------------------------------------

  Widget _buildVideoButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _showVideoDialog(context),
      icon: const Icon(Icons.play_circle_outline_rounded, size: 20),
      label: const Text('Guarda il video'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showVideoDialog(BuildContext context) {
    final url = exercise.videoUrl ?? '';
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Video esercizio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Copia il link e aprilo nel browser:',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            SelectableText(
              url,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: url));
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Link copiato negli appunti')),
              );
            },
            child: const Text('Copia link'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Chiudi'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Info chip widget
// ---------------------------------------------------------------------------

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Color _muscleGroupColor(String group) {
  return switch (group.toLowerCase()) {
    'chest' => const Color(0xFFFF6B6B),
    'back' => const Color(0xFF4ECDC4),
    'shoulders' => const Color(0xFFFFD93D),
    'arms' => const Color(0xFF6C63FF),
    'legs' => const Color(0xFF48BB78),
    'core' => const Color(0xFFED8936),
    'cardio' => const Color(0xFFFC5C7D),
    _ => AppColors.textSecondary,
  };
}

Color _levelColor(String level) {
  return switch (level.toLowerCase()) {
    'beginner' => const Color(0xFF48BB78),
    'intermediate' => const Color(0xFFED8936),
    'advanced' => const Color(0xFFFC5C7D),
    _ => AppColors.textSecondary,
  };
}

IconData _muscleGroupIcon(String group) {
  return switch (group.toLowerCase()) {
    'chest' => Icons.self_improvement_rounded,
    'back' => Icons.accessibility_new_rounded,
    'shoulders' => Icons.sports_gymnastics_rounded,
    'arms' => Icons.fitness_center_rounded,
    'legs' => Icons.directions_run_rounded,
    'core' => Icons.rotate_right_rounded,
    'cardio' => Icons.monitor_heart_outlined,
    _ => Icons.fitness_center_outlined,
  };
}
