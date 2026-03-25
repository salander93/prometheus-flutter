import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/data/models/body_metric_model.dart';
import 'package:palestra/presentation/shared/providers/user_providers.dart';

// ---------------------------------------------------------------------------
// Domain helpers
// ---------------------------------------------------------------------------

enum _MetricField {
  weight('Peso', 'kg'),
  chest('Petto', 'cm'),
  waist('Vita', 'cm'),
  hips('Fianchi', 'cm'),
  biceps('Bicipite', 'cm');

  const _MetricField(this.label, this.unit);

  final String label;
  final String unit;

  double? extractFrom(BodyMetric m) => switch (this) {
        _MetricField.weight => m.weight,
        _MetricField.chest => m.chest,
        _MetricField.waist => m.waist,
        _MetricField.hips => m.hips,
        _MetricField.biceps => m.bicepsLeft ?? m.bicepsRight,
      };
}

const _timeRanges = <String?, String>{
  '2m': '2M',
  '4m': '4M',
  '6m': '6M',
  '12m': '12M',
  '24m': '24M',
  null: 'Tutto',
};

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class BodyMetricsScreen extends ConsumerStatefulWidget {
  const BodyMetricsScreen({super.key});

  @override
  ConsumerState<BodyMetricsScreen> createState() =>
      _BodyMetricsScreenState();
}

class _BodyMetricsScreenState extends ConsumerState<BodyMetricsScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedRange = '6m';
  _MetricField _selectedField = _MetricField.weight;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _MetricField.values.length,
      vsync: this,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedField = _MetricField.values[_tabController.index];
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metricsAsync =
        ref.watch(metricsHistoryProvider(_selectedRange));

    return Column(
      children: [
        // ── Time range chips ──────────────────────────────────────────────
        _TimeRangeFilter(
          selected: _selectedRange,
          onChanged: (range) => setState(() => _selectedRange = range),
        ),

        // ── Metric tab bar ────────────────────────────────────────────────
        _MetricTabBar(controller: _tabController),

        // ── Scrollable content ────────────────────────────────────────────
        Expanded(
          child: metricsAsync.when(
            data: (metrics) => _MetricsBody(
              metrics: metrics,
              field: _selectedField,
              timeRange: _selectedRange,
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
            error: (err, _) => _ErrorBody(
              onRetry: () =>
                  ref.invalidate(metricsHistoryProvider(_selectedRange)),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Time range filter
// ---------------------------------------------------------------------------

class _TimeRangeFilter extends StatelessWidget {
  const _TimeRangeFilter({
    required this.selected,
    required this.onChanged,
  });

  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: _timeRanges.entries.map((entry) {
          final isSelected = selected == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(entry.value),
              selected: isSelected,
              onSelected: (_) => onChanged(entry.key),
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
              backgroundColor: AppColors.backgroundCard,
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Metric tab bar
// ---------------------------------------------------------------------------

class _MetricTabBar extends StatelessWidget {
  const _MetricTabBar({required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: TabBar(
        controller: controller,
        tabs: _MetricField.values
            .map((f) => Tab(text: f.label))
            .toList(),
        indicator: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Metrics body
// ---------------------------------------------------------------------------

class _MetricsBody extends StatelessWidget {
  const _MetricsBody({
    required this.metrics,
    required this.field,
    required this.timeRange,
  });

  final List<BodyMetric> metrics;
  final _MetricField field;
  final String? timeRange;

  @override
  Widget build(BuildContext context) {
    // Sort newest-first for history list, oldest-first for chart
    final sorted = [...metrics]
      ..sort(
        (a, b) => DateTime.parse(a.recordedAt)
            .compareTo(DateTime.parse(b.recordedAt)),
      );

    // Filter entries that have a value for the selected field
    final withValue =
        sorted.where((m) => field.extractFrom(m) != null).toList();

    final historyDescending = withValue.reversed.toList();

    if (withValue.isEmpty) {
      return _EmptyState(field: field);
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: [
        const SizedBox(height: 20),

        // ── Chart ──────────────────────────────────────────────────────────
        _TrendChart(data: withValue, field: field),

        const SizedBox(height: 16),

        // ── Change indicator ───────────────────────────────────────────────
        _ChangeIndicator(
          data: withValue,
          field: field,
          timeRange: timeRange,
        ),

        const SizedBox(height: 24),

        // ── History list ───────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Storico misurazioni',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const SizedBox(height: 8),
        _HistoryList(data: historyDescending, field: field),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Trend chart
// ---------------------------------------------------------------------------

class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.data, required this.field});

  final List<BodyMetric> data;
  final _MetricField field;

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[];
    for (var i = 0; i < data.length; i++) {
      final val = field.extractFrom(data[i]);
      if (val != null) {
        spots.add(FlSpot(i.toDouble(), val));
      }
    }

    if (spots.isEmpty) return const SizedBox.shrink();

    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) < 1 ? 1.0 : (maxY - minY) * 0.15;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.fromLTRB(8, 20, 20, 12),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            minY: minY - padding,
            maxY: maxY + padding,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 44,
                  getTitlesWidget: (value, meta) {
                    if (value == meta.min || value == meta.max) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Text(
                        value.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  interval: _bottomInterval(data.length),
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= data.length) {
                      return const SizedBox.shrink();
                    }
                    final dt =
                        DateTime.tryParse(data[idx].recordedAt);
                    if (dt == null) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat('dd/MM').format(dt),
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 9,
                        ),
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.3,
                color: AppColors.primary,
                barWidth: 2.5,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0x4DFF6B35), // primary ~30% opacity
                      Color(0x00FF6B35), // primary 0% opacity
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                dotData: FlDotData(
                  getDotPainter: (spot, percent, bar, index) =>
                      FlDotCirclePainter(
                    radius: 3.5,
                    color: AppColors.primary,
                    strokeWidth: 1.5,
                    strokeColor: AppColors.backgroundCard,
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => AppColors.backgroundCardHover,
                tooltipBorder: const BorderSide(
                  color: AppColors.border,
                ),
                tooltipRoundedRadius: 8,
                getTooltipItems: (spots) => spots.map((spot) {
                  final idx = spot.spotIndex;
                  final dt = idx < data.length
                      ? DateTime.tryParse(data[idx].recordedAt)
                      : null;
                  final dateStr = dt != null
                      ? DateFormat('dd MMM', 'it_IT').format(dt)
                      : '';
                  return LineTooltipItem(
                    '${spot.y.toStringAsFixed(1)} ${field.unit}\n',
                    const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                    children: [
                      TextSpan(
                        text: dateStr,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.normal,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _bottomInterval(int count) {
    if (count <= 5) return 1;
    if (count <= 10) return 2;
    if (count <= 20) return 4;
    return (count / 5).floorToDouble();
  }
}

// ---------------------------------------------------------------------------
// Change indicator
// ---------------------------------------------------------------------------

class _ChangeIndicator extends StatelessWidget {
  const _ChangeIndicator({
    required this.data,
    required this.field,
    required this.timeRange,
  });

  final List<BodyMetric> data;
  final _MetricField field;
  final String? timeRange;

  @override
  Widget build(BuildContext context) {
    final latest = field.extractFrom(data.last);
    final oldest = field.extractFrom(data.first);

    if (latest == null || oldest == null) return const SizedBox.shrink();

    final delta = latest - oldest;
    final isIncrease = delta > 0.05;
    final isDecrease = delta < -0.05;

    final (icon, color, sign) = isIncrease
        ? (Icons.trending_up_rounded, AppColors.danger, '+')
        : isDecrease
            ? (Icons.trending_down_rounded, AppColors.success, '')
            : (Icons.trending_flat_rounded, AppColors.textSecondary, '');

    final rangeLabel = _rangeLabel(timeRange);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ultimo: ${latest.toStringAsFixed(1)} ${field.unit}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$sign${delta.toStringAsFixed(1)} ${field.unit}'
                    '$rangeLabel',
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _rangeLabel(String? range) {
    if (range == null) return ' nel periodo';
    return switch (range) {
      '2m' => ' negli ultimi 2 mesi',
      '4m' => ' negli ultimi 4 mesi',
      '6m' => ' negli ultimi 6 mesi',
      '12m' => " nell'ultimo anno",
      '24m' => ' negli ultimi 2 anni',
      _ => ' nel periodo',
    };
  }
}

// ---------------------------------------------------------------------------
// History list
// ---------------------------------------------------------------------------

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.data, required this.field});

  final List<BodyMetric> data;
  final _MetricField field;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: data.asMap().entries.map((entry) {
            final idx = entry.key;
            final metric = entry.value;
            final value = field.extractFrom(metric);
            final dt = DateTime.tryParse(metric.recordedAt);
            final dateStr = dt != null
                ? DateFormat('dd MMM yyyy', 'it_IT').format(dt)
                : metric.recordedAt;

            final isLast = idx == data.length - 1;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        value != null
                            ? '${value.toStringAsFixed(1)} ${field.unit}'
                            : '—',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: AppColors.border,
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.field});

  final _MetricField field;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.show_chart_rounded,
              size: 64,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              'Nessun dato disponibile',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Non ci sono misurazioni per "${field.label}" '
              'nel periodo selezionato.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error body
// ---------------------------------------------------------------------------

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: AppColors.danger,
          ),
          const SizedBox(height: 12),
          const Text(
            'Errore nel caricamento',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onRetry,
            child: const Text('Riprova'),
          ),
        ],
      ),
    );
  }
}
