import 'package:frontend/utils/api/category.dart';
import 'package:frontend/utils/api/payment.dart';

class RecurringPayment {
  final int? id;
  final String name;
  final String type;
  final Category category;
  final double cost;
  final String frequency;
  final DateTime paymentDate;
  final List<Payment>? payments;

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
    this.payments = const [],
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
        payments: json['payments'] != null
            ? List<Payment>.from(
                json['payments'].map((payment) => Payment.fromJson(payment)))
            : [],
      );
}
