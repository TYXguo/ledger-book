import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/api/api_client.dart';
import '../../data/providers/transfer_provider.dart';
import '../../data/providers/family_provider.dart';
import '../../data/providers/api_client_provider.dart';
import '../../l10n/app_localizations.dart';

class TransferScreen extends ConsumerStatefulWidget {
  const TransferScreen({super.key});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen> {
  final _amountFormat = NumberFormat.decimalPatternDigits(locale: 'zh_CN', decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
    final transfers = ref.watch(transfersProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: context.canPop() ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()) : null,
        title: Text(l10n.transferTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTransferDialog(context, ref),
          ),
        ],
      ),
      body: transfers.when(
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.swap_horiz, size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(l10n.noTransfers, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(l10n.clickToAddTransfer, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(transfersProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final t = list[index];
                final isPositive = t.direction == 'repayment' || t.direction == 'withdrawal';
                final icon = switch (t.direction) {
                  'loan' || 'deposit' => Icons.arrow_upward,
                  'repayment' || 'withdrawal' => Icons.arrow_downward,
                  _ => Icons.swap_horiz,
                };
                final color = isPositive ? Colors.green : Colors.blue;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withOpacity(0.1),
                    child: Icon(icon, color: color),
                  ),
                  title: Text(switch (t.direction) {
                    'deposit' => l10n.transferDeposit,
                    'withdrawal' => l10n.transferWithdrawal,
                    'loan' => l10n.transferLoan,
                    'repayment' => l10n.transferRepayment,
                    _ => t.direction,
                  }),
                  subtitle: Text([
                    if (t.note != null && t.note!.isNotEmpty) t.note!,
                    DateFormat('yyyy-MM-dd HH:mm').format(t.occurredAt),
                    t.referenceNo,
                  ].join(' · ')),
                  trailing: Text(
                    _amountFormat.format(t.amount),
                    style: TextStyle(fontWeight: FontWeight.w600, color: color),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showAddTransferDialog(BuildContext context, WidgetRef ref) {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    String direction = 'deposit';
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.recordTransfer),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'deposit', label: Text(l10n.transferDeposit)),
                    ButtonSegment(value: 'withdrawal', label: Text(l10n.transferWithdrawal)),
                    ButtonSegment(value: 'loan', label: Text(l10n.transferLoan)),
                    ButtonSegment(value: 'repayment', label: Text(l10n.transferRepayment)),
                  ],
                  selected: {direction},
                  onSelectionChanged: (s) => setDialogState(() => direction = s.first),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: l10n.amount),
                ),
                const SizedBox(height: 8),
                TextField(controller: noteCtrl, decoration: InputDecoration(labelText: l10n.note)),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
            FilledButton(
              onPressed: () async {
                final amount = double.tryParse(amountCtrl.text);
                if (amount == null || amount <= 0) return;

                final familyId = ref.read(currentFamilyIdProvider);
                if (familyId == null) return;

                final memberList = await ref.read(membersProvider.future);
                if (memberList.length < 2) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(l10n.needTwoMembers)));
                  }
                  return;
                }

                try {
                  final api = ref.read(apiClientProvider);
                  await api.post('/families/$familyId/transfers', body: {
                    'debtorMemberId': memberList[0].id,
                    'creditorMemberId': memberList[1].id,
                    'direction': direction,
                    'amount': amount,
                    'occurredAt': DateTime.now().toUtc().toIso8601String(),
                    if (noteCtrl.text.isNotEmpty) 'note': noteCtrl.text,
                  });
                  ref.invalidate(transfersProvider);
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
      ),
    );
  }
}
