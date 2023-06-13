import 'package:flutter/material.dart';

import '../utils/api/models/group.dart';
import 'auth_provider.dart';

class GroupProvider extends ChangeNotifier {
  final Auth? auth;

  GroupProvider(this.auth);

  /// List of groups that user belongs to.
  List<Group>? _groups;

  List<Group>? get groups => _groups;

  bool get isLoading => _groups == null;

  /// Fetches list of the user's groups from the backend.
  Future<void> fetchGroups() async {
    if (auth == null) return;
    final token = auth!.token;
    if (token == null) return;

    try {
      _groups = await auth!.apiService.getGroups(token);
    } catch (_) {
      throw Exception('Failed to load the groups.');
    }
    notifyListeners();
  }

  /// Creates a new group.
  Future<void> createGroup(String name) async {
    if (auth == null) return;
    final token = auth!.token;
    if (token == null) return;

    try {
      final created =
          await auth!.apiService.createGroup(token, groupName: name);
      _groups!.add(created);
    } catch (_) {
      throw Exception('Failed to create the group.');
    }
    notifyListeners();
  }

  /// Joins a group.
  Future<void> joinGroup(String code) async {
    if (auth == null) return;
    final token = auth!.token;
    if (token == null) return;

    try {
      await auth!.apiService.joinGroup(token, groupCode: code);
    } catch (_) {
      throw Exception('Failed to join the group.');
    }

    await fetchGroups();
  }

  /// Deletes a group.
  Future<void> deleteGroup(int groupId) async {
    if (auth == null) return;
    final token = auth!.token;
    if (token == null) return;

    try {
      await auth!.apiService.deleteGroup(token, groupId: groupId);
      _groups!.removeWhere((group) => group.id == groupId);
    } catch (_) {
      rethrow;
    }

    notifyListeners();
  }

  Future<void> reloadGroups() async {
    await fetchGroups();
  }
}
