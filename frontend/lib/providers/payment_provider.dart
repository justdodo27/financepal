import 'package:flutter/material.dart';
import 'package:frontend/utils/api/payment.dart';

import '../utils/helpers.dart';
import 'auth_provider.dart';

class PaymentProvider extends ChangeNotifier {
  final Auth? auth;
  PaymentProvider(this.auth);

  /// List of the user's payments.
  List<Payment>? payments;

  /// Date time rage of obtained payments.
  DateTimeRange? range;

  /// Obtains the user's payments from backend API.
  Future<void> getPayments(DateTimeRange dateTimeRange) async {
    handleIfNotLoggedIn(auth);
    range = dateTimeRange;
    try {
      payments = await auth!.apiService.getPayments(auth!.token!, range!);
    } catch (_) {
      throw Exception('Failed to load the payments.');
    }
    notifyListeners();
  }

  /// Adds new payment.
  Future<void> addPayment(Payment payment) async {
    handleIfNotLoggedIn(auth);
    try {
      final created =
          await auth!.apiService.createPayment(auth!.token!, payment);
      if (payments == null) return;
      payments!.add(created);
    } catch (_) {
      throw Exception('Failed to add the payment.');
    }
    notifyListeners();
  }
}
