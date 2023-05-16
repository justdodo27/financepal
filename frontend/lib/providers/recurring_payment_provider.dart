import 'package:flutter/material.dart';

import '../utils/api/recurring_payment.dart';
import '../utils/helpers.dart';
import 'auth_provider.dart';

class RecurringPaymentProvider extends ChangeNotifier {
  final Auth? auth;
  RecurringPaymentProvider(this.auth);

  /// List of the user's recurring payments.
  List<RecurringPayment>? recurringPayments;

  /// Obtains the user's recurring payments from backend API.
  Future<void> getRecurringPayments() async {
    handleIfNotLoggedIn(auth);
    try {
      recurringPayments =
          await auth!.apiService.getRecurringPayments(auth!.token!);
    } catch (_) {
      throw Exception('Failed to load the recurring payments.');
    }
    notifyListeners();
  }

  /// Adds new recurring payment.
  Future<void> addRecurringPayment(RecurringPayment recurringPayment) async {
    handleIfNotLoggedIn(auth);
    try {
      final created = await auth!.apiService.createRecurringPayment(
        auth!.token!,
        recurringPayment,
      );
      if (recurringPayments == null) return;
      recurringPayments!.add(created);
    } catch (_) {
      throw Exception('Failed to add the recurring payment.');
    }
    notifyListeners();
  }

  /// Updates the recurring payment.
  Future<void> updateRecurringPayment(RecurringPayment recurringPayment) async {
    handleIfNotLoggedIn(auth);
    try {
      await auth!.apiService.updateRecurringPayment(
        auth!.token!,
        recurringPayment,
      );
      if (recurringPayments == null) return;
      final index = recurringPayments!.indexWhere(
        (element) => element.id == recurringPayment.id,
      );
      if (index == -1) return;
      recurringPayments![index] = recurringPayment;
    } catch (_) {
      throw Exception('Failed to update the recurring payment.');
    }
    notifyListeners();
  }

  /// Deletes the recurring payment.
  Future<void> deleteRecurringPayment(int id) async {
    handleIfNotLoggedIn(auth);
    try {
      await auth!.apiService.deleteRecurringPayment(auth!.token!, id);
      if (recurringPayments == null) return;
      recurringPayments!.removeWhere(
        (element) => element.id == id,
      );
    } catch (_) {
      throw Exception('Failed to delete the recurring payment.');
    }
    notifyListeners();
  }
}
