import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api/api_service.dart';

class Auth extends ChangeNotifier {
  final ApiService apiService;

  Auth(this.apiService);

  /// Token to authorize requests to the backend API.
  String? _token;

  bool isLoading = true;

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
    isLoading = false;
    notifyListeners();
  }

  /// Defines if the user is logged in.
  bool get isUserLoggedIn => token != null;

  /// Logs the user in.
  Future<void> logIn(String username, String password) async {
    late String token;
    final fcmToken = await FirebaseMessaging.instance.getToken();
    try {
      token = await apiService.getToken(username, password, fcmToken);
    } catch (_) {
      throw Exception('Failed to log in.');
    }
    _saveToken(token);
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
    try {
      await apiService.signUp(email, username, password);
    } catch (_) {
      throw Exception('Failed to create an account.');
    }
  }
}
