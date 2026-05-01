class CategoryBreakdown {
  final String categoryId;
  final String categoryName;
  final String type;
  final double totalAmount;
  final int count;

  const CategoryBreakdown({
    required this.categoryId,
    required this.categoryName,
    required this.type,
    required this.totalAmount,
    required this.count,
  });

  static double _parseDouble(dynamic value, {double fallback = 0}) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  static int _parseInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  factory CategoryBreakdown.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdown(
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      type: json['type'] as String,
      totalAmount: _parseDouble(json['totalAmount']),
      count: _parseInt(json['count']),
    );
  }
}

class MonthlyTrend {
  final String month;
  final double income;
  final double expense;

  const MonthlyTrend({required this.month, required this.income, required this.expense});

  factory MonthlyTrend.fromJson(Map<String, dynamic> json) {
    return MonthlyTrend(
      month: json['month'] as String,
      income: CategoryBreakdown._parseDouble(json['income']),
      expense: CategoryBreakdown._parseDouble(json['expense']),
    );
  }
}
