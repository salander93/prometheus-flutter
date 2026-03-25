import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';

/// A card-based input widget for a single workout set.
///
/// Three visual states:
/// - **Completed** — teal check, muted values, long-press to edit.
/// - **Active** — orange border, editable inputs, swipe or button to complete.
/// - **Pending** — dimmed, non-interactive.
class SetInputCard extends StatelessWidget {
  const SetInputCard({
    required this.setNumber,
    required this.repsController,
    required this.weightController,
    required this.isCompleted,
    required this.isActive,
    this.onComplete,
    this.onLongPress,
    super.key,
  });

  final int setNumber;
  final TextEditingController repsController;
  final TextEditingController weightController;
  final bool isCompleted;
  final bool isActive;
  final VoidCallback? onComplete;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return _CompletedCard(
        setNumber: setNumber,
        repsController: repsController,
        weightController: weightController,
        onLongPress: onLongPress,
      );
    }

    if (isActive) {
      return _ActiveCard(
        setNumber: setNumber,
        repsController: repsController,
        weightController: weightController,
        onComplete: onComplete,
      );
    }

    // Pending state
    return Opacity(
      opacity: 0.5,
      child: _PendingCard(
        setNumber: setNumber,
        repsController: repsController,
        weightController: weightController,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Completed state
// ---------------------------------------------------------------------------

class _CompletedCard extends StatelessWidget {
  const _CompletedCard({
    required this.setNumber,
    required this.repsController,
    required this.weightController,
    required this.onLongPress,
  });

  final int setNumber;
  final TextEditingController repsController;
  final TextEditingController weightController;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.success.withValues(alpha: 0.20),
          ),
        ),
        child: Row(
          children: [
            // Check circle
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.success,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Serie $setNumber',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
            ),
            const Spacer(),
            _ValueDisplay(label: 'RIP', value: repsController.text),
            const SizedBox(width: 16),
            _ValueDisplay(label: 'KG', value: weightController.text),
            const SizedBox(width: 16),
            const Text(
              'Fatto',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Active state
// ---------------------------------------------------------------------------

class _ActiveCard extends StatelessWidget {
  const _ActiveCard({
    required this.setNumber,
    required this.repsController,
    required this.weightController,
    required this.onComplete,
  });

  final int setNumber;
  final TextEditingController repsController;
  final TextEditingController weightController;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Row(
        children: [
          // Set number badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$setNumber',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _CompactInput(
              label: 'RIP',
              controller: repsController,
              decimal: false,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CompactInput(
              label: 'KG',
              controller: weightController,
              decimal: true,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            child: FilledButton(
              onPressed: onComplete,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              child: const Text('Completa ✓', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pending state
// ---------------------------------------------------------------------------

class _PendingCard extends StatelessWidget {
  const _PendingCard({
    required this.setNumber,
    required this.repsController,
    required this.weightController,
  });

  final int setNumber;
  final TextEditingController repsController;
  final TextEditingController weightController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Gray circle
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.textMuted.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$setNumber',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Serie $setNumber',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          _ValueDisplay(label: 'RIP', value: repsController.text),
          const SizedBox(width: 16),
          _ValueDisplay(label: 'KG', value: weightController.text),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helper widgets
// ---------------------------------------------------------------------------

class _ValueDisplay extends StatelessWidget {
  const _ValueDisplay({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
        const SizedBox(height: 2),
        Text(
          value.isEmpty ? '—' : value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _CompactInput extends StatelessWidget {
  const _CompactInput({
    required this.label,
    required this.controller,
    required this.decimal,
  });

  final String label;
  final TextEditingController controller;
  final bool decimal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundBase,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
              ),
            ),
            TextField(
              controller: controller,
              keyboardType: decimal
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.number,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
