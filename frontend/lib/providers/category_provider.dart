import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/utils/api/api_settings.dart';
import 'package:frontend/utils/api/category.dart';
import 'package:http/http.dart' as http;

class CategoryProvider extends ChangeNotifier {
  final Auth? auth;

  CategoryProvider(this.auth);

  /// List of categories obtained from the backend.
  List<Category>? categories;

  /// Obtains the user's categories from backend API.
  Future<void> getCategories() async {
    final response = await http.get(
      ApiSettings.buildUri('categories/'),
      headers: <String, String>{'Authorization': 'Bearer ${auth!.token}'},
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
    final response = await http.post(
      ApiSettings.buildUri('categories/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${auth!.token}',
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
    final response = await http.put(
      ApiSettings.buildUri('categories/${category.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${auth!.token}',
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
    final response = await http.delete(
      ApiSettings.buildUri('categories/${category.id}'),
      headers: <String, String>{'Authorization': 'Bearer ${auth!.token}'},
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
