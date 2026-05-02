import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/family_provider.dart';
import '../../data/providers/locale_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/leave_family_dialog.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);
    final families = ref.watch(familiesProvider);
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: context.canPop() ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()) : null,
        title: Text(l10n.navSettings),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  child: Text(
                    user?.nickname.isNotEmpty == true ? user!.nickname[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.nickname ?? 'Guest', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    if (user?.email != null) Text(user!.email!, style: TextStyle(color: Theme.of(context).colorScheme.outline)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(l10n.familyTitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, letterSpacing: 1)),
          ),
          families.when(
            data: (list) => Column(
              children: [
                ...list.map((f) => ListTile(
                  leading: const Icon(Icons.family_restroom),
                  title: Text(f.name),
                  subtitle: Text(l10n.roleLabel(f.role)),
                  trailing: const Icon(Icons.chevron_right),
                )),
                if (list.isEmpty) ...[
                  ListTile(
                    leading: const Icon(Icons.add_home),
                    title: Text(l10n.createFamily),
                    onTap: () => context.go('/family'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.group_add),
                    title: Text(l10n.joinFamily),
                    onTap: () => context.go('/family'),
                  ),
                ] else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => showLeaveFamilyConfirmAndExecute(context, ref, list.first.familyId),
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: Text(l10n.leaveFamily, style: const TextStyle(color: Colors.red)),
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                      ),
                    ),
                  ),
              ],
            ),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(l10n.settingsGeneral, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, letterSpacing: 1)),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(locale.languageCode == 'zh' ? l10n.simplifiedChinese : l10n.english),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context, ref, l10n),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.about),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: l10n.appTitle,
                applicationVersion: '0.1.0',
                children: [Text(l10n.aboutDescription)],
              );
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: () {
                ref.read(authStateProvider.notifier).logout();
                context.go('/login');
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final currentLocale = ref.read(localeProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Locale>(
              title: Text(l10n.simplifiedChinese),
              value: const Locale('zh'),
              groupValue: currentLocale,
              onChanged: (value) {
                if (value != null) {
                  ref.read(localeProvider.notifier).setLocale(value);
                }
                Navigator.pop(ctx);
              },
            ),
            RadioListTile<Locale>(
              title: Text(l10n.english),
              value: const Locale('en'),
              groupValue: currentLocale,
              onChanged: (value) {
                if (value != null) {
                  ref.read(localeProvider.notifier).setLocale(value);
                }
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}
