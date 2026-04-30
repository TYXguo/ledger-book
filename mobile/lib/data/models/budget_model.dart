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

  factory BudgetSummaryModel.fromJson(Map<String, dynamic> json) {
    return BudgetSummaryModel(
      budgetMonth: json['budgetMonth'] as String,
      totalBudget: (json['totalBudget'] as num).toDouble(),
      totalExpense: (json['totalExpense'] as num).toDouble(),
      remaining: (json['remaining'] as num).toDouble(),
      usagePercent: (json['usagePercent'] as num).toDouble(),
    );
  }
}
