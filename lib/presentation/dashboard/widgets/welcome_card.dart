import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({
    required this.title,
    required this.subtitle,
    this.isTrainer = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool isTrainer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (isTrainer) {
      return _TrainerWelcomeCard(
        title: title,
        subtitle: subtitle,
        textTheme: textTheme,
      );
    }
    return _ClientWelcomeCard(
      title: title,
      subtitle: subtitle,
      textTheme: textTheme,
    );
  }
}

// ---------------------------------------------------------------------------
// Client welcome — orange gradient with dot pattern overlay
// ---------------------------------------------------------------------------

class _ClientWelcomeCard extends StatelessWidget {
  const _ClientWelcomeCard({
    required this.title,
    required this.subtitle,
    required this.textTheme,
  });

  final String title;
  final String subtitle;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Stack(
        children: [
          // Decorative dot pattern overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _DotPatternPainter(),
            ),
          ),
          // Decorative large circle (top-right)
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          // Decorative small circle (bottom-left)
          Positioned(
            bottom: -12,
            left: 40,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Trainer welcome — dark card with orange accent border
// ---------------------------------------------------------------------------

class _TrainerWelcomeCard extends StatelessWidget {
  const _TrainerWelcomeCard({
    required this.title,
    required this.subtitle,
    required this.textTheme,
  });

  final String title;
  final String subtitle;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.backgroundCard,
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dot pattern painter for welcome card overlay
// ---------------------------------------------------------------------------

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    const spacing = 18.0;
    const dotRadius = 1.5;

    final cols = (size.width / spacing).ceil() + 1;
    final rows = (size.height / spacing).ceil() + 1;

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        canvas.drawCircle(
          Offset(col * spacing, row * spacing),
          dotRadius,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DotPatternPainter oldDelegate) => false;
}
