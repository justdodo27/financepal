import 'package:flutter/material.dart';

import '../utils/api/models/limit.dart';
import '../utils/helpers.dart';
import 'auth_provider.dart';

class LimitProvider extends ChangeNotifier {
  final Auth? auth;

  LimitProvider(this.auth);

  /// List of the user's limits.
  List<Limit>? limits;

  bool get isLoading => limits == null;

  bool requestInProgress = false;

  /// Obtains the user's limits from backend API.
  Future<void> getLimits() async {
    handleIfNotLoggedIn(auth);
    try {
      limits = await auth!.apiService.getLimits(auth!.token!);
    } catch (_) {
      throw Exception('Failed to load the limits.');
    }
    notifyListeners();
  }

  /// Adds new limit.
  Future<void> addLimit(Limit limit) async {
    handleIfNotLoggedIn(auth);
    requestInProgress = true;
    notifyListeners();
    try {
      final created = await auth!.apiService.createLimit(
        auth!.token!,
        limit: limit,
      );
      limits?.add(created);
      requestInProgress = false;
    } catch (_) {
      throw Exception('Failed to add the limit.');
    }
    notifyListeners();
  }

  /// Updates the limit.
  Future<void> updateLimit(Limit limit) async {
    handleIfNotLoggedIn(auth);
    try {
      await auth!.apiService.updateLimit(
        auth!.token!,
        limit: limit,
      );
    } catch (_) {
      throw Exception('Failed to update the limit.');
    }
    notifyListeners();
  }

  /// Deletes the limit.
  Future<void> deleteLimit(Limit limit) async {
    handleIfNotLoggedIn(auth);
    try {
      await auth!.apiService.deleteLimit(
        auth!.token!,
        id: limit.id!,
      );
      limits?.remove(limit);
    } catch (_) {
      throw Exception('Failed to delete the limit.');
    }
    notifyListeners();
  }

  /// Reloads the user's limits from backend API.
  Future<void> reloadLimits() async {
    await getLimits();
  }
}
