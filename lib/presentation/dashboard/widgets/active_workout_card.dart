import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/workout_models.dart';

class ActiveWorkoutCard extends StatefulWidget {
  const ActiveWorkoutCard({
    required this.execution,
    required this.onResume,
    super.key,
  });

  final WorkoutExecution execution;
  final VoidCallback onResume;

  @override
  State<ActiveWorkoutCard> createState() => _ActiveWorkoutCardState();
}

class _ActiveWorkoutCardState extends State<ActiveWorkoutCard>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _updateElapsed();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateElapsed());
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  void _updateElapsed() {
    final startedAt = widget.execution.startedAt;
    if (startedAt == null) return;
    final start = DateTime.tryParse(startedAt);
    if (start == null) return;
    if (mounted) setState(() => _elapsed = DateTime.now().difference(start));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _glowController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final m = _elapsed.inMinutes.toString().padLeft(2, '0');
    final s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final glowOpacity = 0.3 + (_glowController.value * 0.4);
        return GestureDetector(
          onTap: widget.onResume,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: glowOpacity),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: glowOpacity * 0.5),
                  blurRadius: 20 + (_glowController.value * 12),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: glowOpacity * 0.2),
                  blurRadius: 40 + (_glowController.value * 16),
                  spreadRadius: -4,
                ),
              ],
              gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF3D2417), // warm dark brown
              Color(0xFF2A1810), // deeper brown
              Color(0xFF1C1310), // darkest
            ],
          ),
        ),
        child: Stack(
          children: [
            // Decorative circle (top-right, like old PWA)
            Positioned(
              top: -30,
              right: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.12),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 20,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        'ALLENAMENTO IN CORSO',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Session name — large bold
                  Text(
                    widget.execution.sessionName ?? 'Sessione',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Plan name
                  if (widget.execution.planName != null)
                    Text(
                      widget.execution.planName!,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  const SizedBox(height: 18),

                  // Badges row
                  Row(
                    children: [
                      if (widget.execution.weekNumber != null)
                        _Badge(
                          text: 'Settimana ${widget.execution.weekNumber}',
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          textColor: AppColors.textSecondary,
                        ),
                      if (widget.execution.weekNumber != null)
                        const SizedBox(width: 10),
                      // Timer badge — larger, bordered, monospace like old PWA
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.6),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          _formattedTime,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            fontFamily: 'monospace',
                            fontFeatures: [FontFeature.tabularFigures()],
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Resume button — right aligned, white outlined like old PWA
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.white,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: widget.onResume,
                          borderRadius: BorderRadius.circular(24),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 12,
                            ),
                            child: Text(
                              'Riprendi →',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
        },
      );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.bold = false,
    this.tabularFigures = false,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final bool bold;
  final bool tabularFigures;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
          color: textColor,
          fontFeatures: tabularFigures ? const [FontFeature.tabularFigures()] : null,
        ),
      ),
    );
  }
}

class NextWorkoutCard extends StatelessWidget {
  const NextWorkoutCard({
    required this.plan,
    required this.onStart,
    super.key,
  });

  final WorkoutPlanSummary plan;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.backgroundCard,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROSSIMO ALLENAMENTO',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            plan.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Settimana ${plan.currentWeek} di ${plan.durationWeeks}',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onStart,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Inizia Allenamento →',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
