import 'category.dart';

class Payment {
  final int id;
  final String name;
  final String type;
  final DateTime date;
  final double cost;
  final Category category;

  bool get isRecurring => type != 'BILL';

  Payment({
    required this.id,
    required this.name,
    required this.type,
    required this.date,
    required this.cost,
    required this.category,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        date: DateTime.parse(json['payment_date']),
        cost: json['cost'],
        category: json['category'] != null
            ? Category.fromJson(json['category'])
            : Category(name: 'Other'),
      );
}
