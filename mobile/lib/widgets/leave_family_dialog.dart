import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/providers/family_provider.dart';
import '../l10n/app_localizations.dart';

Future<void> showLeaveFamilyConfirmAndExecute(
  BuildContext context,
  WidgetRef ref,
  String familyId,
) async {
  final l10n = AppLocalizations.of(context)!;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.leaveFamilyConfirmTitle),
      content: Text(l10n.leaveFamilyConfirmBody),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l10n.leaveFamilyConfirmAction, style: const TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return;
  try {
    await leaveFamily(ref, familyId);
    if (context.mounted) context.go('/');
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }
}
