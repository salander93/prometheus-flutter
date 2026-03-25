import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';

/// A row of dot indicators for exercise navigation in a live workout.
///
/// Completed exercises are shown in teal, the current exercise in orange,
/// and upcoming exercises in dimmed white. Each dot is tappable.
class ProgressIndicatorBar extends StatelessWidget {
  const ProgressIndicatorBar({
    required this.total,
    required this.currentIndex,
    required this.completedIndices,
    required this.onTapIndex,
    super.key,
  });

  final int total;
  final int currentIndex;
  final Set<int> completedIndices;
  final ValueChanged<int> onTapIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          ...List.generate(total, (i) {
            final Color color;
            if (completedIndices.contains(i)) {
              color = AppColors.success;
            } else if (i == currentIndex) {
              color = AppColors.primary;
            } else {
              color = Colors.white.withValues(alpha: 0.15);
            }
            return GestureDetector(
              onTap: () => onTapIndex(i),
              child: Container(
                width: 24,
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
          const SizedBox(width: 8),
          Text(
            '${currentIndex + 1}/$total',
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
