import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_client.dart';
import '../models/user_model.dart';
import 'api_client_provider.dart';
import 'family_provider.dart';

const _kTokenKey = 'auth_token';
const _kUserKey = 'auth_user';
const _kExpireKey = 'auth_expire';
const _kExpireDuration = Duration(days: 7);

final authStateProvider = StateNotifierProvider<AuthState, UserModel?>((ref) {
  return AuthState(ref.read(apiClientProvider), ref);
});

class AuthState extends StateNotifier<UserModel?> {
  final ApiClient _api;
  final Ref? _ref;

  AuthState(this._api, [this._ref]) : super(null) {
    _loadFromCache();
  }

  bool get isLoggedIn => state != null;

  Future<void> _autoSelectFamily() async {
    if (_ref == null) return;
    try {
      final res = await _api.get('/families');
      final list = res is List ? res : (res['data'] ?? []);
      if (list is List && list.isNotEmpty) {
        final first = list.first as Map<String, dynamic>;
        _ref!.read(currentFamilyIdProvider.notifier).state = first['familyId'] as String;
      }
    } catch (_) {}
  }

  Future<void> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_kTokenKey);
    final userJson = prefs.getString(_kUserKey);
    final expireAt = prefs.getInt(_kExpireKey);

    if (token == null || userJson == null || expireAt == null) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    if (now > expireAt) {
      await _clearCache(prefs);
      return;
    }

    _api.setToken(token);
    state = UserModel.fromJson(jsonDecode(userJson));
    _autoSelectFamily();
  }

  Future<void> _saveToCache(String token, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTokenKey, token);
    await prefs.setString(_kUserKey, jsonEncode({
      'id': user.id,
      'nickname': user.nickname,
      'email': user.email,
      'avatarUrl': user.avatarUrl,
    }));
    await prefs.setInt(_kExpireKey,
        DateTime.now().add(_kExpireDuration).millisecondsSinceEpoch);
  }

  Future<void> _clearCache([SharedPreferences? prefs]) async {
    final p = prefs ?? await SharedPreferences.getInstance();
    await p.remove(_kTokenKey);
    await p.remove(_kUserKey);
    await p.remove(_kExpireKey);
  }

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
    await _saveToCache(result.token, result.user);
    _autoSelectFamily();
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
    await _saveToCache(result.token, result.user);
  }

  Future<void> logout() async {
    _api.setToken(null);
    state = null;
    await _clearCache();
  }
}
