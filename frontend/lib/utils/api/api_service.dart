import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:flutter/material.dart';
import 'package:frontend/utils/api/models/payment_proof.dart';
import 'package:frontend/utils/api/models/recurring_payment.dart';
import 'package:http/http.dart' as http;

import 'models/category.dart';
import 'models/payment.dart';

class ApiService {
  /// Server address.
  static const serverUrl = 'http://10.0.2.2:8080/';

  /// Builds uri for the backend request on the specified enpoint.
  static Uri buildUri(String endpoint) => Uri.parse('$serverUrl$endpoint');

  /// Signs the user up.
  Future<void> signUp(String email, String username, String password) async {
    final response = await http.post(
      buildUri('users/'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(
        <String, String>{
          'email': email,
          'username': username,
          'password': password,
        },
      ),
    );

    if (response.statusCode != 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('detail')) {
        throw Exception(data['detail']);
      }
      throw Exception('Failed to create an account.');
    }
  }

  /// Returns the user's token if it exists.
  Future<String> getToken(String username, String password) async {
    final response = await http.post(
      buildUri('token'),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to log in.');
    }

    final data = jsonDecode(response.body);
    return data['access_token'];
  }

  /// Obtains the user's categories from backend API.
  Future<List<Category>> getCategories(String token) async {
    final response = await http.get(
      buildUri('categories/'),
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load categories.');
    }

    final data = jsonDecode(response.body);
    return List<Category>.from(
      data.map((json) => Category.fromJson(json)),
    );
  }

  /// Adds new category.
  Future<Category> createCategory(String token, Category category) async {
    final response = await http.post(
      buildUri('categories/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        <String, dynamic>{'category': category.name, 'user_id': 1},
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create category.');
    }

    return Category.fromJson(jsonDecode(response.body));
  }

  /// Updates the specified category.
  Future<void> updateCategory(String token, Category category) async {
    final response = await http.put(
      buildUri('categories/${category.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        <String, dynamic>{'category': category.name, 'user_id': 1},
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to edit category.');
    }
  }

  /// Deletes the specified category.
  Future<void> deleteCategory(String token, int id) async {
    final response = await http.delete(
      buildUri('categories/$id'),
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete category.');
    }
  }

  /// Obtains the user's payments from backend API.
  Future<List<Payment>> getPayments(String token, DateTimeRange range) async {
    final response = await http.get(
      buildUri(
          'payments/?start_date=${range.start.toIso8601String()}&end_date=${range.end.toIso8601String()}'),
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load payments.');
    }

    final data = jsonDecode(response.body);
    return List<Payment>.from(data.map((json) => Payment.fromJson(json)));
  }

  /// Creates new payment.
  Future<Payment> createPayment(String token, Payment payment) async {
    final response = await http.post(
      buildUri('payments/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'name': payment.name,
        'type': payment.type,
        'category_id': payment.category.id,
        'cost': payment.cost,
        'payment_date': payment.date.toIso8601String(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create payment.');
    }

    return Payment.fromJson(jsonDecode(response.body));
  }

  /// Updates the specified payment.
  Future<void> updatePayment(String token, Payment payment) async {
    final response = await http.put(
      buildUri('payments/${payment.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        <String, dynamic>{
          'name': payment.name,
          'type': payment.type,
          'category_id': payment.category.id,
          'user_id': 1,
          'cost': payment.cost,
          'payment_date': payment.date.toIso8601String(),
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to edit payment.');
    }
  }

  /// Deltes the specified payment.
  Future<void> deletePayment(String token, int id) async {
    final response = await http.delete(
      buildUri('payments/$id'),
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete payment.');
    }
  }

  /// Obtains the user's recurring payments from backend API.
  Future<List<RecurringPayment>> getRecurringPayments(String token) async {
    final response = await http.get(
      buildUri('renewables/awaiting/'),
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load payments.');
    }

    final data = jsonDecode(response.body);
    return List<RecurringPayment>.from(
        data.map((json) => RecurringPayment.fromJson(json)));
  }

  /// Creates new recurring payment.
  Future<RecurringPayment> createRecurringPayment(
      String token, RecurringPayment recurringPayment) async {
    final response = await http.post(
      buildUri('renewables/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'name': recurringPayment.name,
        'type': recurringPayment.type,
        'category_id': recurringPayment.category.id,
        'user_id': 1,
        'cost': recurringPayment.cost,
        'period': recurringPayment.frequency,
        'payment_date': recurringPayment.paymentDate.toIso8601String(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create payment.');
    }

    return RecurringPayment.fromJson(jsonDecode(response.body));
  }

  /// Updates the specified recurring payment.
  Future<void> updateRecurringPayment(
      String token, RecurringPayment recurringPayment) async {
    final response = await http.put(
      buildUri('renewables/${recurringPayment.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        <String, dynamic>{
          'name': recurringPayment.name,
          'type': recurringPayment.type,
          'category_id': recurringPayment.category.id,
          'user_id': 1,
          'cost': recurringPayment.cost,
          'period': recurringPayment.frequency,
          'payment_date': recurringPayment.paymentDate.toIso8601String(),
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to edit recurring payment.');
    }
  }

  /// Deltes the specified recurring payment.
  Future<void> deleteRecurringPayment(String token, int id) async {
    final response = await http.delete(
      buildUri('renewables/$id'),
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete recurring payment.');
    }
  }

  /// Obtains the user's payment proofs from backend API.
  Future<List<PaymentProof>> getPaymentProofs(String token) async {
     final response = await http.get(
      buildUri('payment_proofs/'),
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load payment proofs.');
    }

    final data = jsonDecode(response.body);
    return List<PaymentProof>.from(
        data.map((json) => PaymentProof.fromJson(json)));
  }
}
