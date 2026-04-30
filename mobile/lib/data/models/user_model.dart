class UserModel {
  final String id;
  final String nickname;
  final String? email;
  final String? avatarUrl;

  const UserModel({required this.id, required this.nickname, this.email, this.avatarUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? json;
    return UserModel(
      id: user['id'] as String,
      nickname: user['nickname'] as String,
      email: user['email'] as String?,
      avatarUrl: user['avatarUrl'] as String?,
    );
  }
}

class AuthResult {
  final UserModel user;
  final String token;

  const AuthResult({required this.user, required this.token});

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      user: UserModel.fromJson(json),
      token: json['token'] as String,
    );
  }
}
