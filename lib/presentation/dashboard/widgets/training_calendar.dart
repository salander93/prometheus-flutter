import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/presentation/shared/providers/workout_providers.dart';

const _monthNames = [
  'Gennaio',
  'Febbraio',
  'Marzo',
  'Aprile',
  'Maggio',
  'Giugno',
  'Luglio',
  'Agosto',
  'Settembre',
  'Ottobre',
  'Novembre',
  'Dicembre',
];

const _weekdayLabels = ['L', 'M', 'M', 'G', 'V', 'S', 'D'];

class TrainingCalendar extends ConsumerStatefulWidget {
  const TrainingCalendar({super.key});

  @override
  ConsumerState<TrainingCalendar> createState() =>
      _TrainingCalendarState();
}

class _TrainingCalendarState
    extends ConsumerState<TrainingCalendar> {
  late int _year;
  late int _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
  }

  void _previousMonth() {
    setState(() {
      if (_month == 1) {
        _month = 12;
        _year -= 1;
      } else {
        _month -= 1;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_month == 12) {
        _month = 1;
        _year += 1;
      } else {
        _month += 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Calendario Allenamenti',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _MonthNavButton(
                  icon: Icons.arrow_back,
                  onTap: _previousMonth,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${_monthNames[_month - 1]} $_year',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 8),
                _MonthNavButton(
                  icon: Icons.arrow_forward,
                  onTap: _nextMonth,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: _weekdayLabels
                  .map(
                    (label) => Expanded(
                      child: Center(
                        child: Text(
                          label,
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
            _CalendarGrid(year: _year, month: _month),
          ],
        ),
      ),
    );
  }
}

class _MonthNavButton extends StatelessWidget {
  const _MonthNavButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.backgroundInput,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _CalendarGrid extends ConsumerWidget {
  const _CalendarGrid({
    required this.year,
    required this.month,
  });

  final int year;
  final int month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarAsync = ref.watch(
      calendarProvider((year: year, month: month)),
    );
    final textTheme = Theme.of(context).textTheme;

    return calendarAsync.when(
      data: (calendarData) {
        final trainingDays = calendarData.trainingDays;
        final trainingCount = trainingDays.length;

        final firstDay = DateTime(year, month);
        final startOffset = firstDay.weekday - 1;
        final daysInMonth =
            DateTime(year, month + 1, 0).day;
        final today = DateTime.now();
        final totalCells = startOffset + daysInMonth;
        final rows = (totalCells / 7).ceil();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var row = 0; row < rows; row++)
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  children: [
                    for (var col = 0; col < 7; col++)
                      Expanded(
                        child: _buildCell(
                          row * 7 + col,
                          startOffset,
                          daysInMonth,
                          today,
                          trainingDays,
                          textTheme,
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
                children: [
                  TextSpan(
                    text: '$trainingCount',
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(
                    text: ' allenamenti questo mese',
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildCell(
    int index,
    int startOffset,
    int daysInMonth,
    DateTime today,
    Map<String, dynamic> trainingDays,
    TextTheme textTheme,
  ) {
    final dayNum = index - startOffset + 1;
    if (index < startOffset || dayNum > daysInMonth) {
      return Padding(
        padding: const EdgeInsets.all(2),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      );
    }

    final dateStr = '$year'
        '-${month.toString().padLeft(2, '0')}'
        '-${dayNum.toString().padLeft(2, '0')}';
    final isTrained = trainingDays.containsKey(dateStr);
    final isToday = today.year == year &&
        today.month == month &&
        today.day == dayNum;

    BoxDecoration decoration;
    var textColor = AppColors.textSecondary;

    if (isTrained) {
      decoration = BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(6),
      );
      textColor = Colors.black;
    } else if (isToday) {
      decoration = BoxDecoration(
        color: const Color(0xFF131316),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.primary,
          width: 1.5,
        ),
      );
      textColor = AppColors.primary;
    } else {
      decoration = BoxDecoration(
        color: const Color(0xFF131316),
        borderRadius: BorderRadius.circular(6),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(2),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: decoration,
          alignment: Alignment.center,
          child: Text(
            '$dayNum',
            style: textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: isToday
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
