import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/execution_models.dart';
import 'package:palestra/presentation/shared/providers/workout_providers.dart';

class StartWorkoutSheet extends ConsumerStatefulWidget {
  final int planId;
  const StartWorkoutSheet({super.key, required this.planId});
  @override
  ConsumerState<StartWorkoutSheet> createState() => _StartWorkoutSheetState();
}

class _StartWorkoutSheetState extends ConsumerState<StartWorkoutSheet> {
  int? _selectedSessionId;
  int _weekNumber = 1;
  bool _isStarting = false;
  bool _defaultsSet = false;

  void _setDefaults(SessionSuggestionResponse suggestion) {
    if (_defaultsSet) return;
    _defaultsSet = true;
    _selectedSessionId = suggestion.suggestedSession.id;
    _weekNumber = suggestion.suggestedWeek ?? 1;
  }

  Future<void> _start() async {
    if (_selectedSessionId == null || _isStarting) return;
    setState(() => _isStarting = true);
    try {
      final repo = ref.read(workoutRepositoryProvider);
      final execution = await repo.startExecution(planId: widget.planId, sessionId: _selectedSessionId!, weekNumber: _weekNumber);
      if (mounted) {
        Navigator.of(context).pop();
        context.go('/workout/${execution.id}');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isStarting = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Errore: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final suggestionAsync = ref.watch(sessionSuggestionProvider(widget.planId));
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: suggestionAsync.when(
        loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
        error: (e, _) => SizedBox(height: 200, child: Center(child: Text('Errore: $e'))),
        data: (suggestion) {
          _setDefaults(suggestion);
          final sessions = suggestion.allSessions;
          final maxWeeks = suggestion.workoutPlan.durationWeeks;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textMuted, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              const Text('Inizia Allenamento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              Text(suggestion.workoutPlan.name, style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              Text('Sessione', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedSessionId,
                dropdownColor: AppColors.backgroundCard,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.textMuted)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: sessions.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name ?? 'Sessione ${s.id}'))).toList(),
                onChanged: (v) => setState(() => _selectedSessionId = v),
              ),
              const SizedBox(height: 16),
              Text('Settimana', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _weekNumber,
                dropdownColor: AppColors.backgroundCard,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.textMuted)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: List.generate(maxWeeks, (i) => DropdownMenuItem(value: i + 1, child: Text('Settimana ${i + 1}'))),
                onChanged: (v) => setState(() => _weekNumber = v ?? 1),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isStarting ? null : _start,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isStarting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Inizia', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          );
        },
      ),
    );
  }
}
