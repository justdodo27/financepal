import 'dart:convert' show jsonDecode, jsonEncode, utf8;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/category.dart';
import 'models/group.dart';
import 'models/limit.dart';
import 'models/payment.dart';
import 'models/payment_proof.dart';
import 'models/recurring_payment.dart';
import 'models/statistics.dart';

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
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));
      if (data.containsKey('detail')) {
        throw Exception(data['detail']);
      }
      throw Exception('Failed to create an account.');
    }
  }

  /// Returns the user's token if it exists.
  Future<String> getToken(
      String username, String password, String? fcmToken) async {
    final response = await http.post(
      buildUri('token'),
      body: {
        'username': username,
        'password': password,
        'token': fcmToken,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to log in.');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));
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

    final data = jsonDecode(utf8.decode(response.bodyBytes));
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

    return Category.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  /// Updates the specified category.
  Future<void> updateCategory(String token, Category category) async {
    final response = await http.put(
      buildUri('categories/${category.id}/'),
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
      buildUri('categories/$id/'),
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

    final data = jsonDecode(utf8.decode(response.bodyBytes));
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
      body: jsonEncode(
        <String, dynamic>{
          'name': payment.name,
          'type': payment.type,
          'category_id': payment.category.id,
          'cost': payment.cost,
          'payment_date': payment.date.toIso8601String(),
          'renewable_id': payment.recurringPaymentId,
          'payment_proof_id': payment.proof?.id,
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create payment.');
    }

    return Payment.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  /// Updates the specified payment.
  Future<void> updatePayment(String token, Payment payment) async {
    final response = await http.put(
      buildUri('payments/${payment.id}/'),
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
          'renewable_id': payment.recurringPaymentId,
          'payment_proof_id': payment.proof?.id,
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
      buildUri('payments/$id/'),
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete payment.');
    }
  }

  /// Obtains the user's recurring payments from backend API.
  Future<List<RecurringPayment>> getRecurringPayments(String token) async {
    final response = await http.get(
      buildUri('renewables/'),
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load payments.');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));
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

    return RecurringPayment.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)));
  }

  /// Updates the specified recurring payment.
  Future<void> updateRecurringPayment(
      String token, RecurringPayment recurringPayment) async {
    final response = await http.put(
      buildUri('renewables/${recurringPayment.id}/'),
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
      buildUri('renewables/$id/'),
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

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return List<PaymentProof>.from(
        data.map((json) => PaymentProof.fromJson(json)));
  }

  /// Creates new payment proof.
  Future<PaymentProof> createPaymentProof(
    String token, {
    required String proofName,
    required String filePath,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      buildUri('payment_proofs/?payment_proof_name=$proofName'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to create payment proof. Response body:\n'
          '${String.fromCharCodes(await response.stream.toBytes())}');
    }

    final data = jsonDecode(await response.stream.bytesToString());
    return PaymentProof.fromJson(data);
  }

  /// Deletes the specified payment proof.
  Future<void> deletePaymentProof(String token, int id) async {
    final response = await http.delete(
      buildUri('payment_proofs/$id/'),
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete payment proof.');
    }
  }

  /// Obtains list of user's group from the API.
  Future<List<Group>> getGroups(String token) async {
    final response = await http.get(
      buildUri('groups/'),
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load groups.');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return List<Group>.from(data.map((json) => Group.fromJson(json)));
  }

  /// Creates new group.
  Future<Group> createGroup(String token, {required String groupName}) async {
    final response = await http.post(
      buildUri('groups/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'name': groupName,
        'user_id': 0,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create group.');
    }

    return Group.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  /// Joins the group with the specified code.
  Future<void> joinGroup(String token, {required String groupCode}) async {
    final response = await http.put(
      buildUri('groups/join/$groupCode/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to join the group.');
    }
  }

  /// Deletes the specified group.
  Future<void> deleteGroup(String token, {required int groupId}) async {
    final response = await http.delete(
      buildUri('groups/$groupId/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete the group.');
    }
  }

  /// Get statistics for the specified period.
  Future<Statistics> getStatistics(
    String token, {
    required DateTimeRange dateTimeRange,
  }) async {
    final response = await http.get(
      buildUri(
        'statistics/?'
        'start_date=${dateTimeRange.start.toIso8601String()}&'
        'end_date=${dateTimeRange.end.toIso8601String()}',
      ),
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load statistics.');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return Statistics.fromJson(data);
  }

  Future<String> getReportUrl(
    String token, {
    required DateTimeRange dateTimeRange,
  }) async {
    final response = await http.get(
      buildUri(
        'report/?'
        'start_date=${dateTimeRange.start.toIso8601String()}&'
        'end_date=${dateTimeRange.end.toIso8601String()}',
      ),
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to download report.');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return data.toString();
  }

  Future<List<Limit>> getLimits(String token) async {
    final response = await http.get(
      buildUri('limits/'),
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load limits.');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return List<Limit>.from(data.map((json) => Limit.fromJson(json)));
  }

  Future<Limit> createLimit(String token, {required Limit limit}) async {
    final response = await http.post(
      buildUri('limits/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'user_id': 0,
        'value': limit.amount,
        'is_active': true,
        'period': limit.period,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create limit.');
    }

    return Limit.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  Future<void> updateLimit(String token, {required Limit limit}) async {
    final response = await http.put(
      buildUri('limits/${limit.id}/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'user_id': 0,
        'value': limit.amount,
        'is_active': limit.isActive,
        'period': limit.period,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create limit.');
    }
  }

  Future<void> deleteLimit(String token, {required int id}) async {
    final response = await http.delete(
      buildUri('limits/$id/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete the limit.');
    }
  }
}
