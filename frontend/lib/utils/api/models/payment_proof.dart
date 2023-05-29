import 'package:frontend/utils/api/models/payment.dart';

class PaymentProof {
  final int id;
  final String name;
  final String url;
  final List<Payment> payments;

  PaymentProof({
    required this.id,
    required this.name,
    required this.url,
    required this.payments,
  });

  factory PaymentProof.fromJson(Map<String, dynamic> json) {
    return PaymentProof(
      id: json['id'],
      name: json['filename'],
      url: json['url'],
      payments: List<Payment>.from(
        json['payments'].map(
          (payment) => Payment.fromJson(payment),
        ),
      ),
    );
  }
}
