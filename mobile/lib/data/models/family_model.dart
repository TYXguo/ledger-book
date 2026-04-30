class FamilyModel {
  final String familyId;
  final String name;
  final String role;
  final bool isDefault;

  const FamilyModel({required this.familyId, required this.name, required this.role, required this.isDefault});

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      familyId: json['familyId'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      isDefault: json['isDefault'] as bool,
    );
  }
}
