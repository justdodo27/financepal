import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/api/payment.dart';

import '../utils/api/api_settings.dart';
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
    range = dateTimeRange;
    final response = await http.get(
      ApiSettings.buildUri(
          'payments/?start_date=${range!.start.toIso8601String()}&end_date=${range!.end.toIso8601String()}'),
      headers: <String, String>{'Authorization': 'Bearer ${auth!.token}'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load payments.');
    }

    final data = jsonDecode(response.body);
    payments = List<Payment>.from(data.map((json) => Payment.fromJson(json)));
    notifyListeners();
  }
}
