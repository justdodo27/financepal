import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api/api_settings.dart';

class Auth extends ChangeNotifier {
  /// Token to authorize requests to the backend API.
  String? _token;

   /// Saves the token to persistent storage.
  void _saveToken(String tokenToSave) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', tokenToSave);
    _token = tokenToSave;
    notifyListeners();
  }

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
      ApiSettings.buildUri('token'),
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
      ApiSettings.buildUri('users/'),
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
}
