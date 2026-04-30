class PeriodSummary {
  final double income;
  final double expense;

  const PeriodSummary({required this.income, required this.expense});
  double get net => income - expense;

  factory PeriodSummary.fromJson(Map<String, dynamic> json) {
    return PeriodSummary(
      income: (json['income'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
    );
  }
}

class OverviewModel {
  final PeriodSummary today;
  final PeriodSummary week;
  final PeriodSummary month;

  const OverviewModel({required this.today, required this.week, required this.month});

  factory OverviewModel.fromJson(Map<String, dynamic> json) {
    return OverviewModel(
      today: PeriodSummary.fromJson(json['today'] as Map<String, dynamic>),
      week: PeriodSummary.fromJson(json['week'] as Map<String, dynamic>),
      month: PeriodSummary.fromJson(json['month'] as Map<String, dynamic>),
    );
  }
}
