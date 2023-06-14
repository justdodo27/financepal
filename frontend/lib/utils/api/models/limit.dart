class Limit {
  final int? id;
  final double amount;
  final String period;
  bool isActive;

  Limit({
    this.id,
    required this.amount,
    required this.period,
    required this.isActive,
  });

  factory Limit.fromJson(Map<String, dynamic> json) {
    return Limit(
      id: json['id'],
      amount: json['value'],
      period: json['period'],
      isActive: json['is_active'],
    );
  }
}
