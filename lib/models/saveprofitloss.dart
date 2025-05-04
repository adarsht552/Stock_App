class SaveProfitLoss {
  String? id;
  String? profitLoss;
  String? amount;
  String? date;

  SaveProfitLoss({
    required this.id,
    required this.profitLoss,
    required this.amount,
    required this.date,
  });

  // Add these methods for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profitLoss': profitLoss,
      'amount': amount,
      'date': date,
    };
  }

  factory SaveProfitLoss.fromJson(Map<String, dynamic> json) {
    return SaveProfitLoss(
      id: json['id'],
      profitLoss: json['profitLoss'],
      amount: json['amount'],
      date: json['date'],
    );
  }
}
