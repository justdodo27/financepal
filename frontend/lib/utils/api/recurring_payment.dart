import 'package:frontend/utils/api/category.dart';

class RecurringPayment {
  final int? id;
  final String name;
  final String type;
  final Category category;
  final double cost;
  final String frequency;
  final DateTime paymentDate;
  DateTime? lastPaymentDate;

  String get date {
    switch (frequency) {
      case 'YEARLY':
        return 'Every year on ${paymentDate.day}/${paymentDate.month}';
      case 'MONTHLY':
        return 'Every month on ${paymentDate.day}';
      case 'WEEKLY':
        return 'Every week on ${paymentDate.weekday}';
      default:
        return 'Every day';
    }
  }

  RecurringPayment({
    this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.cost,
    required this.frequency,
    required this.paymentDate,
  });

  factory RecurringPayment.fromJson(Map<String, dynamic> json) =>
      RecurringPayment(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        category: json['category'] != null
            ? Category.fromJson(json['category'])
            : Category(name: 'Other'),
        cost: json['cost'],
        frequency: json['period'],
        paymentDate: DateTime.parse(json['payment_date']),
        // lastPaymentDate: json['last_payment_date'] != null
        //     ? DateTime.parse(json['last_payment_date'])
        //     : null,
      );
}
