import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/family_model.dart';
import '../models/member_model.dart';
import 'api_client_provider.dart';

final currentFamilyIdProvider = StateProvider<String?>((ref) => null);

final familiesProvider = FutureProvider<List<FamilyModel>>((ref) async {
  final api = ref.read(apiClientProvider);
  final res = await api.get('/families');
  final list = res is List ? res : (res['data'] ?? []);
  if (list is List) {
    return list.map((e) => FamilyModel.fromJson(e as Map<String, dynamic>)).toList();
  }
  return [];
});

final membersProvider = FutureProvider<List<MemberModel>>((ref) async {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) return [];
  final api = ref.read(apiClientProvider);
  final res = await api.get('/families/$familyId/members');
  final list = res as List;
  return list.map((e) => MemberModel.fromJson(e as Map<String, dynamic>)).toList();
});
