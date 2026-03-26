import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';

/// PWA-style set input card.
///
/// Shows the current set to complete with reps/weight inputs and a confirm
/// button. Matches the old PWA layout:
/// - Header: "Set N" + "di M" (muted)
/// - Row: Reps input | "x" | Kg input | orange confirm button
/// - Optional note input below
class SetInputCard extends StatelessWidget {
  const SetInputCard({
    required this.setNumber,
    required this.totalSets,
    required this.repsController,
    required this.weightController,
    required this.isCompleted,
    required this.isActive,
    this.onComplete,
    this.onLongPress,
    this.repsPlaceholder,
    this.weightPlaceholder,
    super.key,
  });

  final int setNumber;
  final int totalSets;
  final TextEditingController repsController;
  final TextEditingController weightController;
  final bool isCompleted;
  final bool isActive;
  final VoidCallback? onComplete;
  final VoidCallback? onLongPress;
  final String? repsPlaceholder;
  final String? weightPlaceholder;

  @override
  Widget build(BuildContext context) {
    if (!isActive) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xD916161A), // rgba(22,22,26,0.85)
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "Set N" + "di M"
          Row(
            children: [
              Text(
                'Set $setNumber',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'di $totalSets',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Input row: Reps | x | Kg | Confirm button
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Reps input
              Expanded(
                child: _SetInputField(
                  label: 'REPS',
                  controller: repsController,
                  decimal: false,
                  placeholder: repsPlaceholder,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 14),
                child: Text(
                  '\u00D7',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Weight input
              Expanded(
                child: _SetInputField(
                  label: 'KG',
                  controller: weightController,
                  decimal: true,
                  placeholder: weightPlaceholder,
                ),
              ),
              const SizedBox(width: 12),
              // Orange confirm button (48x48, radius 10)
              SizedBox(
                width: 48,
                height: 48,
                child: Material(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: onComplete,
                    child: const Center(
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Individual input field for reps or weight, PWA-style.
class _SetInputField extends StatelessWidget {
  const _SetInputField({
    required this.label,
    required this.controller,
    required this.decimal,
    this.placeholder,
  });

  final String label;
  final TextEditingController controller;
  final bool decimal;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Uppercase label (0.7rem equivalent)
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          // Input box
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundInput,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: controller,
              keyboardType: decimal
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: InputBorder.none,
                hintText: placeholder,
                hintStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
