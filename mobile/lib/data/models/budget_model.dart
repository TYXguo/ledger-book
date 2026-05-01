class BudgetSummaryModel {
  final String budgetMonth;
  final double totalBudget;
  final double totalExpense;
  final double remaining;
  final double usagePercent;

  const BudgetSummaryModel({
    required this.budgetMonth,
    required this.totalBudget,
    required this.totalExpense,
    required this.remaining,
    required this.usagePercent,
  });

  static double _parseDouble(dynamic value, {double fallback = 0}) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  factory BudgetSummaryModel.fromJson(Map<String, dynamic> json) {
    return BudgetSummaryModel(
      budgetMonth: json['budgetMonth'] as String,
      totalBudget: _parseDouble(json['totalBudget']),
      totalExpense: _parseDouble(json['totalExpense']),
      remaining: _parseDouble(json['remaining']),
      usagePercent: _parseDouble(json['usagePercent']),
    );
  }
}
