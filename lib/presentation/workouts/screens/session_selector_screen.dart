import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/execution_models.dart';
import 'package:palestra/presentation/shared/providers/workout_providers.dart';

/// Screen where the user picks which session and week to start.
class SessionSelectorScreen extends ConsumerStatefulWidget {
  const SessionSelectorScreen({
    required this.planId,
    super.key,
  });

  final int planId;

  @override
  ConsumerState<SessionSelectorScreen> createState() =>
      _SessionSelectorScreenState();
}

class _SessionSelectorScreenState
    extends ConsumerState<SessionSelectorScreen> {
  int? _selectedSessionId;
  int _weekNumber = 1;
  bool _isStarting = false;

  @override
  Widget build(BuildContext context) {
    final suggestionAsync =
        ref.watch(sessionSuggestionProvider(widget.planId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleziona Sessione'),
        leading: const BackButton(),
      ),
      body: suggestionAsync.when(
        data: (suggestion) {
          _initDefaults(suggestion);
          return _Body(
            suggestion: suggestion,
            selectedSessionId: _selectedSessionId,
            weekNumber: _weekNumber,
            isStarting: _isStarting,
            onSessionChanged: (id) =>
                setState(() => _selectedSessionId = id),
            onWeekChanged: (w) =>
                setState(() => _weekNumber = w),
            onStart: () => _startExecution(suggestion),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => _ErrorView(
          onRetry: () => ref.invalidate(
            sessionSuggestionProvider(widget.planId),
          ),
        ),
      ),
    );
  }

  void _initDefaults(SessionSuggestionResponse s) {
    _selectedSessionId ??= s.suggestedSession.id;
    if (_weekNumber == 1 && s.suggestedWeek > 0) {
      _weekNumber = s.suggestedWeek;
    }
  }

  Future<void> _startExecution(
    SessionSuggestionResponse suggestion,
  ) async {
    final sessionId = _selectedSessionId;
    if (sessionId == null) return;

    setState(() => _isStarting = true);

    try {
      final repo = ref.read(workoutRepositoryProvider);
      final execution = await repo.startExecution(
        planId: widget.planId,
        sessionId: sessionId,
        weekNumber: _weekNumber,
      );

      if (mounted) {
        context.go('/workout/${execution.id}');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isStarting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Errore nell'avvio: $e",
            ),
          ),
        );
      }
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Body
// ─────────────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  const _Body({
    required this.suggestion,
    required this.selectedSessionId,
    required this.weekNumber,
    required this.isStarting,
    required this.onSessionChanged,
    required this.onWeekChanged,
    required this.onStart,
  });

  final SessionSuggestionResponse suggestion;
  final int? selectedSessionId;
  final int weekNumber;
  final bool isStarting;
  final ValueChanged<int?> onSessionChanged;
  final ValueChanged<int> onWeekChanged;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final plan = suggestion.workoutPlan;
    final sessions = suggestion.allSessions;
    final weeks = List.generate(
      plan.durationWeeks,
      (i) => i + 1,
    );

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Plan name
          Text(
            plan.name,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            '${plan.durationWeeks} settimane',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 28),

          // Suggested badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Suggerito: '
                    '${suggestion.suggestedSession.name ?? '-'}'
                    ' — Settimana ${suggestion.suggestedWeek}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Session selector
          Text(
            'Sessione',
            style: textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            initialValue: selectedSessionId,
            decoration: const InputDecoration(
              hintText: 'Scegli sessione',
            ),
            dropdownColor: AppColors.backgroundCard,
            items: sessions
                .where((s) => s.id != null)
                .map(
                  (s) => DropdownMenuItem(
                    value: s.id,
                    child: Text(s.name ?? 'Sessione ${s.id}'),
                  ),
                )
                .toList(),
            onChanged: onSessionChanged,
          ),
          const SizedBox(height: 20),

          // Week selector
          Text(
            'Settimana',
            style: textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            initialValue: weekNumber,
            decoration: const InputDecoration(
              hintText: 'Scegli settimana',
            ),
            dropdownColor: AppColors.backgroundCard,
            items: weeks
                .map(
                  (w) => DropdownMenuItem(
                    value: w,
                    child: Text('Settimana $w'),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) onWeekChanged(v);
            },
          ),

          const Spacer(),

          // Start button
          FilledButton.icon(
            onPressed: isStarting ? null : onStart,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimary,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: isStarting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textPrimary,
                    ),
                  )
                : const Icon(Icons.play_arrow_rounded),
            label: Text(
              isStarting ? 'Avvio in corso...' : 'Inizia',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error view
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 56,
              color: AppColors.danger,
            ),
            const SizedBox(height: 16),
            Text(
              'Errore nel caricamento',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Riprova'),
            ),
          ],
        ),
      ),
    );
  }
}
