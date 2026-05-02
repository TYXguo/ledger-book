import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/providers/overview_provider.dart';
import '../../l10n/app_localizations.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  String _selectedMonth = DateFormat('yyyy-MM-01').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final breakdown = ref.watch(categoryBreakdownProvider(_selectedMonth));
    final trend = ref.watch(monthlyTrendProvider);
    final l10n = AppLocalizations.of(context)!;
    final amountFormat = NumberFormat.decimalPatternDigits(locale: 'zh_CN', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        leading: context.canPop() ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()) : null,
        title: Text(l10n.statistics),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_month),
              title: Text(DateFormat('yyyy年MM月').format(DateTime.parse(_selectedMonth))),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      final d = DateTime.parse(_selectedMonth);
                      setState(() => _selectedMonth = DateFormat('yyyy-MM-01').format(DateTime(d.year, d.month - 1, 1)));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      final d = DateTime.parse(_selectedMonth);
                      setState(() => _selectedMonth = DateFormat('yyyy-MM-01').format(DateTime(d.year, d.month + 1, 1)));
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.expenseCategories, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          breakdown.when(
            data: (items) {
              final expenseItems = items.where((i) => i.type == 'expense').toList();
              if (expenseItems.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(child: Text(l10n.noExpenseData)),
                  ),
                );
              }
              final colors = [
                Colors.blue, Colors.red, Colors.green, Colors.orange,
                Colors.purple, Colors.teal, Colors.pink, Colors.amber,
              ];
              final total = expenseItems.fold(0.0, (s, i) => s + i.totalAmount);

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: expenseItems.asMap().entries.map((e) {
                              final i = e.key;
                              final item = e.value;
                              return PieChartSectionData(
                                value: item.totalAmount,
                                color: colors[i % colors.length],
                                title: '${(item.totalAmount / total * 100).toStringAsFixed(0)}%',
                                titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                radius: 80,
                              );
                            }).toList(),
                            sectionsSpace: 2,
                            centerSpaceRadius: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...expenseItems.asMap().entries.map((e) {
                        final i = e.key;
                        final item = e.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              CircleAvatar(radius: 6, backgroundColor: colors[i % colors.length]),
                              const SizedBox(width: 8),
                              Expanded(child: Text(item.categoryName)),
                              Text(amountFormat.format(item.totalAmount)),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Card(child: Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator()))),
            error: (e, _) => Card(child: Padding(padding: const EdgeInsets.all(20), child: Text('Error: $e'))),
          ),
          const SizedBox(height: 24),
          Text(l10n.monthlyTrend, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          trend.when(
            data: (items) {
              if (items.isEmpty) return Card(child: Padding(padding: const EdgeInsets.all(20), child: Text(l10n.noTrendData)));
              final maxVal = items.fold(0.0, (s, i) {
                final m = i.income > i.expense ? i.income : i.expense;
                return m > s ? m : s;
              });

              return Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 24, 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _Legend(color: Colors.red, label: l10n.expense),
                          const SizedBox(width: 16),
                          _Legend(color: Colors.green, label: l10n.income),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            minY: 0,
                            maxY: maxVal * 1.2,
                            titlesData: FlTitlesData(
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (v, _) {
                                    final i = v.toInt();
                                    if (i < 0 || i >= items.length) return const SizedBox();
                                    final parts = items[i].month.split('-');
                                    return Text(l10n.monthSuffix(int.parse(parts[1])), style: const TextStyle(fontSize: 10));
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: const FlGridData(show: true, drawVerticalLine: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: items.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.expense)).toList(),
                                isCurved: true,
                                color: Colors.red,
                                barWidth: 2,
                                dotData: const FlDotData(show: true),
                              ),
                              LineChartBarData(
                                spots: items.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.income)).toList(),
                                isCurved: true,
                                color: Colors.green,
                                barWidth: 2,
                                dotData: const FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Card(child: Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator()))),
            error: (e, _) => Card(child: Padding(padding: const EdgeInsets.all(20), child: Text('Error: $e'))),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
