import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/api/api_client.dart';
import '../../data/providers/family_provider.dart';
import '../../data/providers/category_provider.dart';
import '../../data/providers/transaction_provider.dart';
import '../../data/providers/api_client_provider.dart';
import '../../data/providers/overview_provider.dart';
import '../../l10n/app_localizations.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  String _type = 'expense';
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedCategoryId;
  String? _selectedSubCategoryId;
  DateTime _selectedDate = DateTime.now();
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(parentCategoriesProvider(_type));
    final members = ref.watch(membersProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addTransaction)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'expense', label: Text(l10n.expense), icon: const Icon(Icons.arrow_downward)),
                ButtonSegment(value: 'income', label: Text(l10n.income), icon: const Icon(Icons.arrow_upward)),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() {
                _type = s.first;
                _selectedCategoryId = null;
                _selectedSubCategoryId = null;
              }),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '0.00',
                prefixText: '¥ ',
                prefixStyle: TextStyle(fontSize: 36, color: Theme.of(context).colorScheme.outline),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 16),
            Text(l10n.category, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            categories.when(
              data: (cats) => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: cats.map((cat) => ChoiceChip(
                  label: Text(cat.name),
                  selected: _selectedCategoryId == cat.id,
                  onSelected: (_) => setState(() {
                    _selectedCategoryId = cat.id;
                    _selectedSubCategoryId = null;
                  }),
                )).toList(),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
            if (_selectedCategoryId != null) ...[
              const SizedBox(height: 8),
              ref.watch(childCategoriesProvider((parentId: _selectedCategoryId!))).when(
                data: (children) {
                  if (children.isEmpty) return const SizedBox();
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: children.map((c) => ChoiceChip(
                      label: Text(c.name),
                      selected: _selectedSubCategoryId == c.id,
                      onSelected: (_) => setState(() => _selectedSubCategoryId = c.id),
                    )).toList(),
                  );
                },
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            ],
            const SizedBox(height: 20),
            TextField(
              controller: _noteController,
              maxLines: 2,
              decoration: InputDecoration(labelText: l10n.note, hintText: l10n.noteHint, border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 1)),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _submit,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: _saving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(l10n.saveTransaction, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.invalidAmount)));
      return;
    }
    if (_selectedCategoryId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.selectCategory)));
      return;
    }

    final familyId = ref.read(currentFamilyIdProvider);
    if (familyId == null) return;

    setState(() => _saving = true);
    try {
      final api = ref.read(apiClientProvider);
      final memberList = await ref.read(membersProvider.future);
      final memberId = memberList.isNotEmpty ? memberList.first.id : '';

      await api.post('/families/$familyId/transactions', body: {
        'ownerMemberId': memberId,
        'type': _type,
        'amount': amount,
        'categoryId': _selectedCategoryId!,
        'subCategoryId': _selectedSubCategoryId,
        'occurredAt': _selectedDate.toUtc().toIso8601String(),
        'note': _noteController.text.isEmpty ? null : _noteController.text,
      });

      ref.invalidate(overviewProvider);
      ref.read(transactionListProvider.notifier).load();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.transactionSaved)));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
