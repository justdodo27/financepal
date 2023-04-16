import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BackendApi extends ChangeNotifier {
  BackendApi() {
    isUserLoggedIn();
  }

  final _hostUrl = 'http://10.0.2.2:8080/';
  String? token;

  void _saveToken(String tokenToSave) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', tokenToSave);
    token = tokenToSave;
    notifyListeners();
  }

  Future<String?> getToken() async {
    if (token == null) {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('access_token');
    }
    return token;
  }

  Future<bool> isUserLoggedIn() async => await getToken() != null;

  Uri _buildUri(String endpoint) => Uri.parse('$_hostUrl$endpoint');

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

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    token = null;
    notifyListeners();
  }

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
}
