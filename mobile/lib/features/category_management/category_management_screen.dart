import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/category_model.dart';
import '../../data/providers/category_provider.dart';
import '../../l10n/app_localizations.dart';

class CategoryManagementScreen extends ConsumerStatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  ConsumerState<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends ConsumerState<CategoryManagementScreen> {
  String _type = 'expense';
  final Set<String> _expandedParents = {};

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(parentCategoriesProvider(_type));
    final allCategories = ref.watch(categoriesProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: context.canPop() ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()) : null,
        title: Text(l10n.categoryManagement),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'expense', label: Text(l10n.expense)),
                ButtonSegment(value: 'income', label: Text(l10n.income)),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() {
                _type = s.first;
                _expandedParents.clear();
              }),
            ),
          ),
          Expanded(
            child: categories.when(
              data: (cats) {
                if (cats.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.category_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
                        const SizedBox(height: 16),
                        Text(l10n.noTransactionsFound, style: TextStyle(color: Theme.of(context).colorScheme.outline)),
                      ],
                    ),
                  );
                }
                return allCategories.when(
                  data: (allCats) => ListView.builder(
                    itemCount: cats.length,
                    itemBuilder: (context, index) {
                      final parent = cats[index];
                      final children = allCats.where((c) => c.parentId == parent.id).toList();
                      final isExpanded = _expandedParents.contains(parent.id);
                      return ExpansionTile(
                        key: ValueKey(parent.id),
                        title: Text(parent.name),
                        subtitle: children.isNotEmpty ? Text('${children.length} ${l10n.category}') : null,
                        initiallyExpanded: isExpanded,
                        onExpansionChanged: (expanded) {
                          setState(() {
                            if (expanded) {
                              _expandedParents.add(parent.id);
                            } else {
                              _expandedParents.remove(parent.id);
                            }
                          });
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          onPressed: () => _confirmDelete(context, parent),
                        ),
                        children: children.map((child) => ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(child.name),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20),
                            onPressed: () => _confirmDelete(context, child),
                          ),
                        )).toList(),
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, CategoryModel category) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteCategoryConfirm),
        content: Text(category.name),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await deleteCategory(ref, categoryId: category.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.categoryDeleted)));
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    String? selectedParentId;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final parentCats = ref.read(parentCategoriesProvider(_type)).valueOrNull ?? [];
          return AlertDialog(
            title: Text(l10n.addCategory),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: l10n.categoryName,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedParentId,
                  decoration: InputDecoration(
                    labelText: l10n.parentCategory,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.noParent)),
                    ...parentCats.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
                  ],
                  onChanged: (value) => setDialogState(() => selectedParentId = value),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
              FilledButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  if (name.isEmpty) return;
                  Navigator.pop(ctx);
                  try {
                    await createCategory(ref, name: name, type: _type, parentId: selectedParentId);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.categoryCreated)));
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
                child: Text(l10n.save),
              ),
            ],
          );
        },
      ),
    );
  }
}
