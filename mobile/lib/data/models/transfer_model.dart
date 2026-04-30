class TransferModel {
  final String id;
  final String debtorMemberId;
  final String creditorMemberId;
  final String direction;
  final double amount;
  final String? note;
  final DateTime occurredAt;
  final String status;
  final String referenceNo;

  const TransferModel({
    required this.id,
    required this.debtorMemberId,
    required this.creditorMemberId,
    required this.direction,
    required this.amount,
    this.note,
    required this.occurredAt,
    required this.status,
    required this.referenceNo,
  });

  factory TransferModel.fromJson(Map<String, dynamic> json) {
    return TransferModel(
      id: json['id'] as String,
      debtorMemberId: json['debtorMemberId'] as String,
      creditorMemberId: json['creditorMemberId'] as String,
      direction: json['direction'] as String,
      amount: (json['amount'] as num).toDouble(),
      note: json['note'] as String?,
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      status: json['status'] as String,
      referenceNo: json['referenceNo'] as String,
    );
  }
}

class BalanceModel {
  final String peerMemberId;
  final double balance;

  const BalanceModel({required this.peerMemberId, required this.balance});

  factory BalanceModel.fromJson(Map<String, dynamic> json) {
    return BalanceModel(
      peerMemberId: json['peerMemberId'] as String,
      balance: (json['balance'] as num).toDouble(),
    );
  }
}
