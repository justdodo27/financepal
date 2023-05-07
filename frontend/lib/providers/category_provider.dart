import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/utils/api/category.dart';

class CategoryProvider extends ChangeNotifier {
  final Auth? auth;

  CategoryProvider(this.auth);

  /// List of categories obtained from the backend.
  List<Category>? categories;

  void _handleIfNotLoggedIn() {
    if (auth == null) throw Exception('User is not logged in.');
    if (!auth!.isUserLoggedIn) throw Exception('User is not logged in.');
  }

  /// Obtains the user's categories from backend API.
  Future<void> getCategories() async {
    _handleIfNotLoggedIn();
    try {
      categories = await auth!.apiService.getCategories(auth!.token!);
    } catch (_) {
      throw Exception('Failed to load the categories.');
    }
    notifyListeners();
  }

  /// Adds new category.
  Future<void> addCategory(Category category) async {
    _handleIfNotLoggedIn();
    late Category created;
    try {
      created = await auth!.apiService.createCategory(auth!.token!, category);
    } catch (_) {
      throw Exception('Failed to create category.');
    }

    if (created.isUserCategory) {
      categories ??= <Category>[];
      categories = <Category>[...categories!, created];
    }
    notifyListeners();
  }

  /// Edits the specified category.
  Future<void> editCategory(Category category) async {
    _handleIfNotLoggedIn();
    try {
      await auth!.apiService.updateCategory(auth!.token!, category);
    } catch (_) {
      throw Exception('Failed to update category.');
    }
    notifyListeners();
  }

  /// Deletes the specified category.
  Future<void> deleteCategory(Category category) async {
    _handleIfNotLoggedIn();
    try {
      await auth!.apiService.deleteCategory(auth!.token!, category);
    } catch (_) {
      throw Exception('Failed to delete category.');
    }

    if (category.isUserCategory) {
      categories!.removeWhere((toDelete) => category.id == toDelete.id);
    }
    notifyListeners();
  }
}
