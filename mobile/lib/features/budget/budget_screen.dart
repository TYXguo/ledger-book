import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/providers/budget_provider.dart';
import '../../data/providers/family_provider.dart';
import '../../data/api/api_client.dart';
import '../../data/providers/api_client_provider.dart';
import '../../l10n/app_localizations.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  late String _month;
  final _currency = NumberFormat.currency(locale: 'zh_CN', symbol: '¥');

  @override
  void initState() {
    super.initState();
    _month = DateFormat('yyyy-MM-01').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final budget = ref.watch(budgetSummaryProvider(_month));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: context.canPop() ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()) : null,
        title: Text(l10n.budgetTitle),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _showAddBudgetDialog(context)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_month),
              title: Text(DateFormat('yyyy年MM月').format(DateTime.parse(_month))),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      final d = DateTime.parse(_month);
                      setState(() => _month = DateFormat('yyyy-MM-01').format(DateTime(d.year, d.month - 1, 1)));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      final d = DateTime.parse(_month);
                      setState(() => _month = DateFormat('yyyy-MM-01').format(DateTime(d.year, d.month + 1, 1)));
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          budget.when(
            data: (data) {
              if (data == null) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.account_balance_wallet, size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(l10n.noBudgetThisMonth, style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 8),
                          Text(l10n.clickToSetBudget, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                );
              }
              final progress = data.usagePercent / 100;
              final isOver = data.usagePercent > 100;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(l10n.monthlyBudget, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          if (isOver) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
                              child: Text(l10n.overBudget, style: const TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          minHeight: 12,
                          backgroundColor: Colors.grey.shade200,
                          color: isOver ? Colors.red : (progress > 0.8 ? Colors.orange : Colors.green),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.budgetSpent(_currency.format(data.totalExpense)), style: TextStyle(color: Theme.of(context).colorScheme.outline)),
                          Text(l10n.budgetAmount(_currency.format(data.totalBudget)), style: TextStyle(color: Theme.of(context).colorScheme.outline)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.budgetRemaining(_currency.format(data.remaining)),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isOver ? Colors.red : Colors.green),
                      ),
                      const SizedBox(height: 4),
                      Text(l10n.budgetUsedPercent(data.usagePercent.toStringAsFixed(1)), style: TextStyle(color: Theme.of(context).colorScheme.outline)),
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

  void _showAddBudgetDialog(BuildContext context) {
    final amountCtrl = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.setBudget),
        content: TextField(
          controller: amountCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: l10n.budgetAmountLabel, prefixText: '¥ '),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () async {
              final amount = double.tryParse(amountCtrl.text);
              if (amount == null || amount < 0) return;
              final familyId = ref.read(currentFamilyIdProvider);
              if (familyId == null) return;
              try {
                final api = ref.read(apiClientProvider);
                await api.post('/families/$familyId/budgets', body: {
                  'budgetMonth': _month,
                  'amount': amount,
                  'alertThresholdPercent': 80,
                });
                ref.invalidate(budgetSummaryProvider(_month));
                if (ctx.mounted) Navigator.pop(ctx);
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
