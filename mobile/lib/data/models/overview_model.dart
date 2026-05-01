class PeriodSummary {
  final double income;
  final double expense;

  const PeriodSummary({required this.income, required this.expense});
  double get net => income - expense;

  static double _parseDouble(dynamic value, {double fallback = 0}) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  factory PeriodSummary.fromJson(Map<String, dynamic> json) {
    return PeriodSummary(
      income: _parseDouble(json['income']),
      expense: _parseDouble(json['expense']),
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
