import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/budget_model.dart';
import 'family_provider.dart';
import 'api_client_provider.dart';

final budgetSummaryProvider = FutureProvider.family<BudgetSummaryModel?, String>((ref, month) async {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) return null;
  final api = ref.read(apiClientProvider);
  final res = await api.get('/families/$familyId/budgets/summary', query: {'month': month});
  return BudgetSummaryModel.fromJson(res);
});
