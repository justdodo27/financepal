import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/utils/api/models/category.dart';

import '../utils/helpers.dart';

class CategoryProvider extends ChangeNotifier {
  final Auth? auth;

  CategoryProvider(this.auth);

  /// List of categories obtained from the backend.
  List<Category>? categories;

  /// Obtains the user's categories from backend API.
  Future<void> getCategories() async {
    handleIfNotLoggedIn(auth);
    try {
      categories = await auth!.apiService.getCategories(auth!.token!);
    } catch (_) {
      throw Exception('Failed to load the categories.');
    }
    notifyListeners();
  }

  /// Adds new category.
  Future<void> addCategory(Category category) async {
    handleIfNotLoggedIn(auth);
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
    handleIfNotLoggedIn(auth);
    try {
      await auth!.apiService.updateCategory(auth!.token!, category);
    } catch (_) {
      throw Exception('Failed to update category.');
    }
    notifyListeners();
  }

  /// Deletes the specified category.
  Future<void> deleteCategory(Category category) async {
    handleIfNotLoggedIn(auth);
    try {
      await auth!.apiService.deleteCategory(auth!.token!, category.id!);
    } catch (_) {
      throw Exception('Failed to delete category.');
    }

    if (category.isUserCategory) {
      categories!.removeWhere((toDelete) => category.id == toDelete.id);
    }
    notifyListeners();
  }

  Future<void> reloadCategories() async {
    await getCategories();
  }
}
