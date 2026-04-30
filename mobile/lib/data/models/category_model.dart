class CategoryModel {
  final String id;
  final String name;
  final String type;
  final String? parentId;
  final String? icon;
  final String? color;
  final List<CategoryModel> children;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    this.parentId,
    this.icon,
    this.color,
    this.children = const [],
  });

  bool get isParent => parentId == null;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      parentId: json['parentId'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
    );
  }
}
