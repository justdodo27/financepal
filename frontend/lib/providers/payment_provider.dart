import 'package:flutter/material.dart';
import 'package:frontend/utils/api/models/payment.dart';

import '../utils/helpers.dart';
import 'auth_provider.dart';

class PaymentProvider extends ChangeNotifier {
  final Auth? auth;
  PaymentProvider(this.auth);

  /// List of the user's payments.
  List<Payment>? payments;

  /// Date time rage of obtained payments.
  DateTimeRange? range;

  bool requestInProgress = false;

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
    requestInProgress = true;
    notifyListeners();
    try {
      final created =
          await auth!.apiService.createPayment(auth!.token!, payment);
      requestInProgress = false;
      payments?.add(created);
    } catch (_) {
      throw Exception('Failed to add the payment.');
    }
    notifyListeners();
  }

  /// Updates the specified payment.
  Future<void> updatePayment(Payment payment) async {
    handleIfNotLoggedIn(auth);
    requestInProgress = true;
    notifyListeners();
    try {
      await auth!.apiService.updatePayment(auth!.token!, payment);
      requestInProgress = false;

      final index = payments?.indexWhere((element) => element.id == payment.id);
      if (index != null) {
        payments![index] = payment;
      }
    } catch (_) {
      throw Exception('Failed to update the payment.');
    }
    notifyListeners();
  }

  /// Deletes the specified payment.
  Future<void> deletePayment(int id) async {
    handleIfNotLoggedIn(auth);
    try {
      await auth!.apiService.deletePayment(auth!.token!, id);
      payments?.removeWhere((element) => element.id == id);
    } catch (_) {
      throw Exception('Failed to delete the payment.');
    }
    notifyListeners();
  }

  Future<void> reloadPayments(DateTimeRange dateTimeRange) async {
    await getPayments(dateTimeRange);
  }
}
