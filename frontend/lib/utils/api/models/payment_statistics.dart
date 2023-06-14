class PaymentStatistics {
  final int id;
  final String name;
  final double value;
  final int count;

  PaymentStatistics({
    required this.id,
    required this.name,
    required this.value,
    required this.count,
  });

  factory PaymentStatistics.fromJson(Map<String, dynamic> json) {
    return PaymentStatistics(
      id: json['category_id'],
      name: json['name'],
      value: json['value'],
      count: json['count'],
    );
  }
}
