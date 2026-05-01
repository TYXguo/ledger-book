import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/api/api_client.dart';
import '../../data/providers/family_provider.dart';
import '../../data/providers/api_client_provider.dart';
import '../../l10n/app_localizations.dart';

class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final families = ref.watch(familiesProvider);
    final members = ref.watch(membersProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: context.canPop() ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()) : null,
        title: Text(l10n.familyTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showJoinFamilyDialog(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.add_home),
            onPressed: () => _showCreateFamilyDialog(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.myFamily, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          families.when(
            data: (list) {
              if (list.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(child: Text(l10n.noFamily, style: const TextStyle(color: Colors.grey))),
                  ),
                );
              }
              final currentId = ref.watch(currentFamilyIdProvider);
              return Column(
                children: list.map((f) => Card(
                  color: currentId == f.familyId ? Theme.of(context).colorScheme.primaryContainer : null,
                  child: ListTile(
                    leading: Icon(
                      f.isDefault ? Icons.home : Icons.family_restroom,
                      color: currentId == f.familyId ? Theme.of(context).colorScheme.primary : null,
                    ),
                    title: Text(f.name),
                    subtitle: Text(l10n.roleLabel(f.role)),
                    trailing: currentId == f.familyId ? const Icon(Icons.check_circle) : null,
                    onTap: () => ref.read(currentFamilyIdProvider.notifier).state = f.familyId,
                  ),
                )).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
          ),
          const SizedBox(height: 24),
          Text(l10n.members, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          members.when(
            data: (list) {
              if (list.isEmpty) return Text(l10n.selectFamilyToViewMembers, style: const TextStyle(color: Colors.grey));
              return Column(
                children: list.map((m) => Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(m.displayName.isNotEmpty ? m.displayName[0].toUpperCase() : '?')),
                    title: Text(m.displayName),
                    subtitle: Text(m.role),
                    trailing: m.isDefault ? const Icon(Icons.star, color: Colors.amber) : null,
                  ),
                )).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
          ),
        ],
      ),
    );
  }

  void _showCreateFamilyDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.createFamily),
        content: TextField(controller: nameCtrl, decoration: InputDecoration(labelText: l10n.familyName)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () async {
              if (nameCtrl.text.isEmpty) return;
              try {
                final api = ref.read(apiClientProvider);
                await api.post('/families', body: {'name': nameCtrl.text});
                ref.invalidate(familiesProvider);
                if (ctx.mounted) Navigator.pop(ctx);
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: Text(l10n.create),
          ),
        ],
      ),
    );
  }

  void _showJoinFamilyDialog(BuildContext context, WidgetRef ref) {
    final codeCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.joinFamily),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: codeCtrl, decoration: InputDecoration(labelText: l10n.inviteCode)),
            const SizedBox(height: 8),
            TextField(controller: nameCtrl, decoration: InputDecoration(labelText: l10n.displayName)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () async {
              if (codeCtrl.text.isEmpty || nameCtrl.text.isEmpty) return;
              try {
                final api = ref.read(apiClientProvider);
                await api.post('/families/join', body: {
                  'inviteCode': codeCtrl.text,
                  'displayName': nameCtrl.text,
                });
                ref.invalidate(familiesProvider);
                if (ctx.mounted) Navigator.pop(ctx);
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: Text(l10n.join),
          ),
        ],
      ),
    );
  }
}
