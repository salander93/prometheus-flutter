import 'package:flutter/material.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/workout_models.dart';

class ClientRecentActivityList extends StatelessWidget {
  const ClientRecentActivityList({
    required this.logs,
    required this.onViewAll,
    super.key,
  });

  final List<ActivityLogSummary> logs;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Storico Recente',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: const Text(
                  'Vedi tutto →',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...logs.take(5).map((log) => _ActivityTile(log: log)),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.log});

  final ActivityLogSummary log;

  String get _feelingEmoji {
    final feeling = log.feelingDisplay?.toLowerCase() ?? '';
    if (feeling.contains('ottim') || feeling.contains('excel')) return '🔥';
    if (feeling.contains('grande') || feeling.contains('bene')) return '💪';
    if (feeling.contains('normal')) return '😊';
    if (feeling.contains('fatica') || feeling.contains('diff')) return '😮‍💨';
    if (feeling.isEmpty) return '';
    return '😐';
  }

  String get _relativeDate {
    final dateStr = log.date.isNotEmpty ? log.date : log.createdAt;
    final date = DateTime.tryParse(dateStr);
    if (date == null) return dateStr;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final diff = today.difference(dateOnly).inDays;
    if (diff == 0) return 'Oggi';
    if (diff == 1) return 'Ieri';
    if (diff < 30) return '$diff giorni fa';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final sessionName = log.sessionName;
    final title = (sessionName != null && sessionName.isNotEmpty)
        ? sessionName
        : (log.clientName.isNotEmpty ? log.clientName : 'Allenamento');

    final metaParts = <String>[_relativeDate];
    if (log.durationMinutes != null) {
      metaParts.add('${log.durationMinutes}min');
    }
    if (log.setCount != null) {
      metaParts.add('${log.setCount} set');
    }

    final emoji = _feelingEmoji;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  metaParts.join(' · '),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (emoji.isNotEmpty || log.feelingDisplay != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (emoji.isNotEmpty)
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 18),
                  ),
                if (log.feelingDisplay != null)
                  Text(
                    log.feelingDisplay!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
