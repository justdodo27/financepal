import 'package:flutter/material.dart';
import 'package:frontend/utils/api/payment.dart';

import 'auth_provider.dart';

class PaymentProvider extends ChangeNotifier {
  final Auth? auth;
  PaymentProvider(this.auth);

  /// List of the user's payments.
  List<Payment>? payments;

  /// Date time rage of obtained payments.
  DateTimeRange? range;

  void _handleIfNotLoggedIn() {
    if (auth == null) throw Exception('User is not logged in.');
    if (!auth!.isUserLoggedIn) throw Exception('User is not logged in.');
  }

  /// Obtains the user's payments from backend API.
  Future<void> getPayments(DateTimeRange range) async {
    _handleIfNotLoggedIn();
    try {
      payments = await auth!.apiService.getPayments(auth!.token!, range);
    } catch (_) {
      throw Exception('Failed to load the payments.');
    }
    notifyListeners();
  }
}
