import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/overview_model.dart';
import '../models/statistic_model.dart';
import 'family_provider.dart';
import 'api_client_provider.dart';

final overviewProvider = FutureProvider<OverviewModel>((ref) async {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) return const OverviewModel(
    today: PeriodSummary(income: 0, expense: 0),
    week: PeriodSummary(income: 0, expense: 0),
    month: PeriodSummary(income: 0, expense: 0),
  );
  final api = ref.read(apiClientProvider);
  final res = await api.get('/families/$familyId/statistics/overview');
  return OverviewModel.fromJson(res);
});

final categoryBreakdownProvider = FutureProvider.family<List<CategoryBreakdown>, String>((ref, month) async {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) return [];
  final api = ref.read(apiClientProvider);
  final res = await api.get('/families/$familyId/statistics/category-breakdown', query: {'month': month});
  final list = res is List ? res : (res['data'] ?? res['items'] ?? []);
  if (list is List) {
    return list.map((e) => CategoryBreakdown.fromJson(e as Map<String, dynamic>)).toList();
  }
  return [];
});

final monthlyTrendProvider = FutureProvider<List<MonthlyTrend>>((ref) async {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) return [];
  final api = ref.read(apiClientProvider);
  final res = await api.get('/families/$familyId/statistics/monthly-trend');
  final list = res is List ? res : (res['data'] ?? res['items'] ?? []);
  if (list is List) {
    return list.map((e) => MonthlyTrend.fromJson(e as Map<String, dynamic>)).toList();
  }
  return [];
});
