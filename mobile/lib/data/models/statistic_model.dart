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

  factory CategoryBreakdown.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdown(
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      type: json['type'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      count: json['count'] as int,
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
      income: (json['income'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
    );
  }
}
