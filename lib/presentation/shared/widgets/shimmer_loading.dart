import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

/// A reusable shimmer placeholder that replaces [CircularProgressIndicator]
/// on full-screen list, grid, card, and profile loading states.
class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    this.itemCount = 5,
    this.type = ShimmerType.list,
    super.key,
  });

  final int itemCount;
  final ShimmerType type;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundCard,
      highlightColor: AppColors.backgroundCardHover,
      child: switch (type) {
        ShimmerType.list => _buildListShimmer(),
        ShimmerType.grid => _buildGridShimmer(),
        ShimmerType.card => _buildCardShimmer(),
        ShimmerType.profile => _buildProfileShimmer(),
      },
    );
  }

  Widget _buildListShimmer() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const _ShimmerCard(height: 80),
    );
  }

  Widget _buildGridShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: itemCount,
      itemBuilder: (_, __) => const _ShimmerCard(height: 150),
    );
  }

  Widget _buildCardShimmer() => const _ShimmerCard(height: 120);

  Widget _buildProfileShimmer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Avatar circle
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // Name bar
          Container(
            width: 150,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle bar
          Container(
            width: 100,
            height: 14,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

enum ShimmerType { list, grid, card, profile }

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
    );
  }
}
