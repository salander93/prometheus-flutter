import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/exercise_model.dart';
import 'package:palestra/presentation/exercises/providers/exercise_providers.dart';
import 'package:shimmer/shimmer.dart';

// ---------------------------------------------------------------------------
// Muscle group filter model
// ---------------------------------------------------------------------------

class _MuscleFilter {
  const _MuscleFilter({required this.label, required this.value});

  final String label;
  final String? value; // null means "Tutti"
}

const _muscleFilters = [
  _MuscleFilter(label: 'Tutti', value: null),
  _MuscleFilter(label: 'Petto', value: 'chest'),
  _MuscleFilter(label: 'Schiena', value: 'back'),
  _MuscleFilter(label: 'Spalle', value: 'shoulders'),
  _MuscleFilter(label: 'Braccia', value: 'arms'),
  _MuscleFilter(label: 'Gambe', value: 'legs'),
  _MuscleFilter(label: 'Core', value: 'core'),
  _MuscleFilter(label: 'Cardio', value: 'cardio'),
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class ExerciseListScreen extends ConsumerStatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  ConsumerState<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends ConsumerState<ExerciseListScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  String _searchQuery = '';
  String? _selectedMuscleGroup;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _searchQuery = value.trim());
      }
    });
  }

  void _selectMuscleGroup(String? value) {
    setState(() => _selectedMuscleGroup = value);
  }

  @override
  Widget build(BuildContext context) {
    final params = (
      search: _searchQuery.isEmpty ? null : _searchQuery,
      muscleGroup: _selectedMuscleGroup,
    );

    final exercisesAsync = ref.watch(exercisesProvider(params));

    return Scaffold(
      backgroundColor: AppColors.backgroundBase,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildSearchBar(),
            _buildMuscleGroupFilter(),
            const SizedBox(height: 4),
            Expanded(
              child: exercisesAsync.when(
                data: _buildExerciseList,
                loading: _buildShimmer,
                error: (err, _) => _buildError(err),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        'Libreria Esercizi',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Search bar
  // ---------------------------------------------------------------------------

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: const InputDecoration(
          hintText: 'Cerca esercizio…',
          prefixIcon: Icon(Icons.search_rounded),
        ),
        textInputAction: TextInputAction.search,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Muscle group horizontal chips
  // ---------------------------------------------------------------------------

  Widget _buildMuscleGroupFilter() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: _muscleFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _muscleFilters[index];
          final isSelected = _selectedMuscleGroup == filter.value;
          return FilterChip(
            label: Text(filter.label),
            selected: isSelected,
            onSelected: (_) => _selectMuscleGroup(filter.value),
            selectedColor: AppColors.primary.withValues(alpha: 0.2),
            checkmarkColor: AppColors.primary,
            labelStyle: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 12,
            ),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
            backgroundColor: AppColors.backgroundCard,
            padding: const EdgeInsets.symmetric(horizontal: 4),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Exercise list
  // ---------------------------------------------------------------------------

  Widget _buildExerciseList(List<ExerciseModel> exercises) {
    if (exercises.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: exercises.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) =>
          _ExerciseCard(exercise: exercises[index]),
    );
  }

  // ---------------------------------------------------------------------------
  // Empty state
  // ---------------------------------------------------------------------------

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.fitness_center_outlined,
            size: 64,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'Nessun esercizio trovato',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Prova a modificare la ricerca o il filtro',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Shimmer loading
  // ---------------------------------------------------------------------------

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundCard,
      highlightColor: AppColors.backgroundCardHover,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: 8,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, __) => Container(
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Error state
  // ---------------------------------------------------------------------------

  Widget _buildError(Object err) {
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
          const SizedBox(height: 4),
          Text(
            err.toString(),
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => setState(() {}),
            child: const Text('Riprova'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Exercise Card
// ---------------------------------------------------------------------------

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({required this.exercise});

  final ExerciseModel exercise;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/exercises/${exercise.id}'),
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            _buildThumbnail(),
            const SizedBox(width: 12),
            Expanded(child: _buildInfo(context)),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
      child: SizedBox(
        width: 88,
        height: 88,
        child: exercise.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: exercise.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => _imagePlaceholder(),
                errorWidget: (context, url, error) => _imagePlaceholder(),
              )
            : _imagePlaceholder(),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return ColoredBox(
      color: AppColors.backgroundCardHover,
      child: Center(
        child: Icon(
          _muscleGroupIcon(exercise.muscleGroup),
          color: AppColors.textMuted,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            exercise.nameIt ?? exercise.name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              _MuscleGroupChip(muscleGroup: exercise.muscleGroup),
              const SizedBox(width: 6),
              _LevelIndicator(level: exercise.level),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared small widgets (also used in detail screen via export)
// ---------------------------------------------------------------------------

class _MuscleGroupChip extends StatelessWidget {
  const _MuscleGroupChip({required this.muscleGroup});

  final String muscleGroup;

  @override
  Widget build(BuildContext context) {
    final (label, color) = _muscleGroupInfo(muscleGroup);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _LevelIndicator extends StatelessWidget {
  const _LevelIndicator({required this.level});

  final String level;

  @override
  Widget build(BuildContext context) {
    final (label, color) = _levelInfo(level);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

(String, Color) _muscleGroupInfo(String group) {
  return switch (group.toLowerCase()) {
    'chest' => ('Petto', const Color(0xFFFF6B6B)),
    'back' => ('Schiena', const Color(0xFF4ECDC4)),
    'shoulders' => ('Spalle', const Color(0xFFFFD93D)),
    'arms' => ('Braccia', const Color(0xFF6C63FF)),
    'legs' => ('Gambe', const Color(0xFF48BB78)),
    'core' => ('Core', const Color(0xFFED8936)),
    'cardio' => ('Cardio', const Color(0xFFFC5C7D)),
    _ => (group, AppColors.textSecondary),
  };
}

(String, Color) _levelInfo(String level) {
  return switch (level.toLowerCase()) {
    'beginner' => ('Principiante', const Color(0xFF48BB78)),
    'intermediate' => ('Intermedio', const Color(0xFFED8936)),
    'advanced' => ('Avanzato', const Color(0xFFFC5C7D)),
    _ => (level, AppColors.textSecondary),
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
