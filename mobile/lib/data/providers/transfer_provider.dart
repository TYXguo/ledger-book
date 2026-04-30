import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../models/transfer_model.dart';
import 'family_provider.dart';
import 'api_client_provider.dart';

final transfersProvider = FutureProvider<List<TransferModel>>((ref) async {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) return [];
  final api = ref.read(apiClientProvider);
  final res = await api.get('/families/$familyId/transfers');
  final list = res['items'] ?? res;
  if (list is List) {
    return list.map((e) => TransferModel.fromJson(e as Map<String, dynamic>)).toList();
  }
  return [];
});

final memberBalanceProvider = FutureProvider.family<List<BalanceModel>, String>((ref, memberId) async {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) return [];
  final api = ref.read(apiClientProvider);
  final res = await api.get('/families/$familyId/members/$memberId/balance');
  final list = res['data'] ?? res['items'] ?? res;
  if (list is List) {
    return list.map((e) => BalanceModel.fromJson(e as Map<String, dynamic>)).toList();
  }
  return [];
});
