import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/providers/overview_provider.dart';
import '../../data/providers/transaction_provider.dart';
import '../../data/providers/family_provider.dart';
import '../../data/models/overview_model.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(overviewProvider);
    final txnList = ref.watch(transactionListProvider);
    final currentFamilyId = ref.watch(currentFamilyIdProvider);
    final amountFormat = NumberFormat.decimalPatternDigits(locale: 'zh_CN', decimalDigits: 2);
    final l10n = AppLocalizations.of(context)!;

    if (currentFamilyId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.appTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.family_restroom, size: 64, color: Theme.of(context).colorScheme.outline),
                const SizedBox(height: 16),
                Text(l10n.noFamilyHint, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => context.go('/family'),
                  icon: const Icon(Icons.add_home),
                  label: Text(l10n.createFamily),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.go('/family'),
                  icon: const Icon(Icons.group_add),
                  label: Text(l10n.joinFamily),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(overviewProvider);
          ref.read(transactionListProvider.notifier).load();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            overview.when(
              data: (data) => _OverviewCard(data: data, amountFormat: amountFormat),
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (e, _) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Failed to load overview: $e'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _QuickActions(),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.homeRecentTransactions, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        TextButton(onPressed: () => context.go('/transactions'), child: Text(l10n.homeViewAll)),
                      ],
                    ),
                  ),
                  txnList.when(
                    data: (result) {
                      if (result.items.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(l10n.homeNoTransactions, style: const TextStyle(color: Colors.grey)),
                        );
                      }
                      return Column(
                        children: result.items.take(8).map((txn) {
                          final isExpense = txn.type == 'expense';
                          return ListTile(
                            leading: CircleAvatar(
                              child: Icon(isExpense ? Icons.arrow_downward : Icons.arrow_upward),
                            ),
                            title: Text(txn.categoryName ?? 'Unknown'),
                            subtitle: Text(txn.note ?? DateFormat('MM/dd HH:mm').format(txn.occurredAt)),
                            trailing: Text(
                              '${isExpense ? '-' : '+'}${amountFormat.format(txn.amount)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isExpense ? Colors.red : Colors.green,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('Error: $e'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add'),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: l10n.navHome),
          NavigationDestination(icon: const Icon(Icons.receipt_long_outlined), selectedIcon: const Icon(Icons.receipt_long), label: l10n.navBills),
          NavigationDestination(icon: const Icon(Icons.pie_chart_outline), selectedIcon: const Icon(Icons.pie_chart), label: l10n.navStatistics),
          NavigationDestination(icon: const Icon(Icons.settings_outlined), selectedIcon: const Icon(Icons.settings), label: l10n.navSettings),
        ],
        onDestinationSelected: (i) {
          switch (i) {
            case 0: context.go('/'); break;
            case 1: context.go('/transactions'); break;
            case 2: context.go('/statistics'); break;
            case 3: context.go('/settings'); break;
          }
        },
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final OverviewModel data;
  final NumberFormat amountFormat;
  const _OverviewCard({required this.data, required this.amountFormat});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.overview, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                TextButton(onPressed: () => context.go('/statistics'), child: Text(l10n.details)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _Metric(title: l10n.today, income: data.today.income, expense: data.today.expense, amountFormat: amountFormat),
                _Metric(title: l10n.thisWeek, income: data.week.income, expense: data.week.expense, amountFormat: amountFormat),
                _Metric(title: l10n.thisMonth, income: data.month.income, expense: data.month.expense, amountFormat: amountFormat),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String title;
  final double income;
  final double expense;
  final NumberFormat amountFormat;

  const _Metric({required this.title, required this.income, required this.expense, required this.amountFormat});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.outline)),
          const SizedBox(height: 4),
          Text(
            '-${amountFormat.format(expense)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          Text(
            '+${amountFormat.format(income)}',
            style: const TextStyle(fontSize: 12, color: Colors.green),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      (Icons.account_balance_wallet, l10n.quickBudget, '/budget'),
      (Icons.swap_horiz, l10n.quickTransfer, '/transfer'),
      (Icons.group, l10n.quickFamily, '/family'),
      (Icons.receipt_long, l10n.quickBills, '/transactions'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items.map((item) {
        return GestureDetector(
          onTap: () => context.go(item.$3),
          child: Column(
            children: [
              CircleAvatar(radius: 24, child: Icon(item.$1)),
              const SizedBox(height: 8),
              Text(item.$2, style: const TextStyle(fontSize: 12)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
