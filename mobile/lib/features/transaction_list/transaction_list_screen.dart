import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/providers/transaction_provider.dart';
import '../../l10n/app_localizations.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  final _searchController = TextEditingController();
  String? _typeFilter;
  final _amountFormat = NumberFormat.decimalPatternDigits(locale: 'zh_CN', decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
    final txnList = ref.watch(transactionListProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: context.canPop() ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()) : null,
        title: Text(l10n.transactionRecords),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchByNote,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(transactionListProvider.notifier).setKeyword(null);
                        },
                      )
                    : null,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (v) {
                ref.read(transactionListProvider.notifier).setKeyword(v.isEmpty ? null : v);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                FilterChip(
                  label: Text(l10n.all),
                  selected: _typeFilter == null,
                  onSelected: (_) {
                    setState(() => _typeFilter = null);
                    ref.read(transactionListProvider.notifier).setTypeFilter(null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(l10n.expense),
                  selected: _typeFilter == 'expense',
                  onSelected: (_) {
                    setState(() => _typeFilter = 'expense');
                    ref.read(transactionListProvider.notifier).setTypeFilter('expense');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(l10n.income),
                  selected: _typeFilter == 'income',
                  onSelected: (_) {
                    setState(() => _typeFilter = 'income');
                    ref.read(transactionListProvider.notifier).setTypeFilter('income');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: txnList.when(
              data: (result) {
                if (result.items.isEmpty) {
                  return Center(child: Text(l10n.noTransactionsFound, style: const TextStyle(color: Colors.grey)));
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.read(transactionListProvider.notifier).load(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: result.items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final txn = result.items[index];
                      final isExpense = txn.type == 'expense';
                      return ListTile(
                        leading: CircleAvatar(
                          child: Icon(isExpense ? Icons.arrow_downward : Icons.arrow_upward),
                        ),
                        title: Text(txn.categoryName ?? 'Unknown'),
                        subtitle: Text([
                          if (txn.note != null && txn.note!.isNotEmpty) txn.note!,
                          DateFormat('yyyy-MM-dd HH:mm').format(txn.occurredAt),
                          if (txn.tags.isNotEmpty) txn.tags.map((t) => '#${t.name}').join(' '),
                        ].join(' · ')),
                        trailing: Text(
                          '${isExpense ? '-' : '+'}${_amountFormat.format(txn.amount)}',
                          style: TextStyle(fontWeight: FontWeight.w600, color: isExpense ? Colors.red : Colors.green),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
          txnList.when(
            data: (result) {
              if (result.total <= result.pageSize) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: result.page > 1 ? () => ref.read(transactionListProvider.notifier).prevPage() : null,
                      child: Text(l10n.previousPage),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Page ${result.page} / ${(result.total / result.pageSize).ceil()}'),
                    ),
                    TextButton(
                      onPressed: result.items.length >= result.pageSize ? () => ref.read(transactionListProvider.notifier).nextPage() : null,
                      child: Text(l10n.nextPage),
                    ),
                  ],
                ),
              );
            },
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }
}
