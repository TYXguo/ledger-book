class TagModel {
  final String id;
  final String name;

  const TagModel({required this.id, required this.name});

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(id: json['id'] as String, name: json['name'] as String);
  }
}

double _parseDouble(dynamic value, {double fallback = 0}) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}

int _parseInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

class TransactionModel {
  final String id;
  final String type;
  final double amount;
  final String currency;
  final String categoryId;
  final String? categoryName;
  final String? subCategoryId;
  final String? subCategoryName;
  final String? note;
  final DateTime occurredAt;
  final String ownerMemberId;
  final List<TagModel> tags;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    this.currency = 'CNY',
    required this.categoryId,
    this.categoryName,
    this.subCategoryId,
    this.subCategoryName,
    this.note,
    required this.occurredAt,
    required this.ownerMemberId,
    this.tags = const [],
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: _parseDouble(json['amount']),
      currency: json['currency'] as String? ?? 'CNY',
      categoryId: json['categoryId'] as String,
      categoryName: json['category']?['name'] as String?,
      subCategoryId: json['subCategoryId'] as String?,
      subCategoryName: json['subCategory']?['name'] as String?,
      note: json['note'] as String?,
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      ownerMemberId: json['ownerMemberId'] as String,
      tags: (json['transactionTags'] as List<dynamic>?)?.map(
        (t) => TagModel.fromJson(t['tag'] as Map<String, dynamic>),
      ).toList() ?? [],
    );
  }
}

class TransactionListResult {
  final List<TransactionModel> items;
  final int total;
  final int page;
  final int pageSize;

  const TransactionListResult({required this.items, required this.total, required this.page, required this.pageSize});

  factory TransactionListResult.fromJson(Map<String, dynamic> json) {
    return TransactionListResult(
      items: (json['items'] as List<dynamic>).map((e) => TransactionModel.fromJson(e as Map<String, dynamic>)).toList(),
      total: _parseInt(json['total']),
      page: _parseInt(json['page'], fallback: 1),
      pageSize: _parseInt(json['pageSize'], fallback: 20),
    );
  }
}
