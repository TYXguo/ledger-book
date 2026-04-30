import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../models/user_model.dart';
import 'api_client_provider.dart';

final authStateProvider = StateNotifierProvider<AuthState, UserModel?>((ref) {
  return AuthState(ref.read(apiClientProvider));
});

class AuthState extends StateNotifier<UserModel?> {
  final ApiClient _api;

  AuthState(this._api) : super(null);

  bool get isLoggedIn => state != null;

  Future<void> login(String account, String password) async {
    _api.setToken(null);
    final isEmail = account.contains('@');
    final body = {
      if (isEmail) 'email': account else 'phone': account,
      'password': password,
    };
    final res = await _api.post('/auth/login', body: body);
    final result = AuthResult.fromJson(res);
    _api.setToken(result.token);
    state = result.user;
  }

  Future<void> register(String nickname, String password, {String? email, String? phone}) async {
    _api.setToken(null);
    final body = {
      'nickname': nickname,
      'password': password,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
    };
    final res = await _api.post('/auth/register', body: body);
    final result = AuthResult.fromJson(res);
    _api.setToken(result.token);
    state = result.user;
  }

  void logout() {
    _api.setToken(null);
    state = null;
  }
}
