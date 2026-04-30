import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../models/category_model.dart';
import 'family_provider.dart';
import 'api_client_provider.dart';

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) return [];
  final api = ref.read(apiClientProvider);
  final res = await api.get('/families/$familyId/categories');
  final list = res as List;
  return list.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
});

final parentCategoriesProvider = Provider.family<AsyncValue<List<CategoryModel>>, String>((ref, type) {
  return ref.watch(categoriesProvider).whenData(
    (cats) => cats.where((c) => c.isParent && c.type == type).toList(),
  );
});

final childCategoriesProvider = Provider.family<AsyncValue<List<CategoryModel>>, ({String parentId})>((ref, params) {
  return ref.watch(categoriesProvider).whenData(
    (cats) => cats.where((c) => c.parentId == params.parentId).toList(),
  );
});
