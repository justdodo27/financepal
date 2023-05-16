import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'category.dart';
import 'payment.dart';

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
}
