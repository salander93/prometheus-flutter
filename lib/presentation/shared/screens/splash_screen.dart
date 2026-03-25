import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';

/// Full-screen splash shown while the app resolves auth state.
///
/// Features a pulsing logo with a gradient "Prometheus" title and a
/// subtle linear progress indicator at the bottom.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBase,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pulsing logo
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    'assets/images/prometheus_logo.png',
                    width: 150,
                    height: 150,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                const SizedBox(height: 24),
                // Gradient title
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ).createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: const Text(
                    'Prometheus',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Subtle linear progress at bottom
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: AppColors.backgroundCard,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
