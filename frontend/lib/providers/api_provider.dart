import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/utils/api/category.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BackendApi extends ChangeNotifier {
  static const _hostUrl = 'http://10.0.2.2:8080/';

  /// Token to authorize requests to the backend API.
  String? _token;

  /// List of categories obtained from the backend.
  List<Category>? categories;

  /// Saves the token to persistent storage.
  void _saveToken(String tokenToSave) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', tokenToSave);
    _token = tokenToSave;
    notifyListeners();
  }

  /// Builds uri for the backend request on the specified enpoint.
  Uri _buildUri(String endpoint) => Uri.parse('$_hostUrl$endpoint');

  /// Returns the user's token if it exists.
  String? get token {
    if (_token == null) _getToken();
    return _token;
  }

  /// Obtains the token from the persistent memory if it exists.
  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('access_token');
    notifyListeners();
  }

  /// Defines if the user is logged in.
  bool get isUserLoggedIn => token != null;

  /// Logs the user in.
  Future<void> logIn(String username, String password) async {
    final response = await http.post(
      _buildUri('token'),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to log in.');
    }

    final data = jsonDecode(response.body);
    _saveToken(data['access_token']);
  }

  /// Logs the user out.
  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    _token = null;
    notifyListeners();
  }

  /// Signs the user up.
  Future<void> signUp(String email, String username, String password) async {
    final response = await http.post(
      _buildUri('users/'),
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

  /// Obtains the user's categories from backend API.
  Future<void> getCategories() async {
    if (!isUserLoggedIn) throw Exception('User is not logged in.');
    final response = await http.get(
      _buildUri('categories/'),
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load categories.');
    }

    final data = jsonDecode(response.body);
    categories = List<Category>.from(
      data.map((json) => Category.fromJson(json)),
    );
    notifyListeners();
  }

  /// Adds new category.
  Future<void> addCategory(Category category) async {
    if (!isUserLoggedIn) throw Exception('User is not logged in.');
    final response = await http.post(
      _buildUri('categories/'),
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

    final created = Category.fromJson(jsonDecode(response.body));
    if (created.isUserCategory) {
      categories ??= <Category>[];
      categories = <Category>[...categories!, created];
    }
    notifyListeners();
  }

  /// Edits the specified category.
  Future<void> editCategory(Category category) async {
    if (!isUserLoggedIn) throw Exception('User is not logged in.');
    final response = await http.put(
      _buildUri('categories/${category.id}'),
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
    notifyListeners();
  }

  /// Deletes the specified category.
  Future<void> deleteCategory(Category category) async {
    if (!isUserLoggedIn) throw Exception('User is not logged in.');
    final response = await http.delete(
      _buildUri('categories/${category.id}'),
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete category.');
    }

    if (category.isUserCategory) {
      categories!.removeWhere((toDelete) => category.id == toDelete.id);
    }
    notifyListeners();
  }
}
