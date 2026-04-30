class MemberModel {
  final String id;
  final String displayName;
  final String role;
  final bool isDefault;

  const MemberModel({required this.id, required this.displayName, required this.role, required this.isDefault});

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      role: json['role'] as String,
      isDefault: json['isDefault'] as bool,
    );
  }
}
