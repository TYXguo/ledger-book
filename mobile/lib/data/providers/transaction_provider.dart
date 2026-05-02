import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import 'family_provider.dart';
import 'api_client_provider.dart';

final transactionListProvider = StateNotifierProvider<TransactionListState, AsyncValue<TransactionListResult>>((ref) {
  final notifier = TransactionListState(ref);
  ref.listen<String?>(currentFamilyIdProvider, (previous, next) {
    if (previous != next) {
      notifier.onFamilyChanged();
    }
  });
  return notifier;
});

class TransactionListState extends StateNotifier<AsyncValue<TransactionListResult>> {
  final Ref _ref;
  int _page = 1;
  final int _pageSize = 20;
  String? _keyword;
  String? _type;
  String? _categoryId;

  TransactionListState(this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  /// 当前家庭 ID 变化时重新拉取（例如登录后异步 `_autoSelectFamily` 才写入 ID，避免首次 `load` 在 null 上结束后再无刷新）。
  void onFamilyChanged() {
    _page = 1;
    load();
  }

  Future<void> load() async {
    final familyId = _ref.read(currentFamilyIdProvider);
    if (familyId == null) { state = const AsyncValue.data(TransactionListResult(items: [], total: 0, page: 1, pageSize: 20)); return; }

    state = const AsyncValue.loading();
    try {
      final api = _ref.read(apiClientProvider);
      final query = <String, String>{
        'page': '$_page',
        'pageSize': '$_pageSize',
        if (_keyword != null && _keyword!.isNotEmpty) 'keyword': _keyword!,
        if (_type != null) 'type': _type!,
        if (_categoryId != null) 'categoryId': _categoryId!,
      };
      final res = await api.get('/families/$familyId/transactions', query: query);
      state = AsyncValue.data(TransactionListResult.fromJson(res));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void setKeyword(String? keyword) {
    _keyword = keyword;
    _page = 1;
    load();
  }

  void setTypeFilter(String? type) {
    _type = type;
    _page = 1;
    load();
  }

  void setCategoryFilter(String? categoryId) {
    _categoryId = categoryId;
    _page = 1;
    load();
  }

  void nextPage() { _page++; load(); }
  void prevPage() { if (_page > 1) { _page--; load(); } }
}
