import 'package:flutter/material.dart';

import '../utils/api/models/group.dart';
import 'auth_provider.dart';

class GroupProvider extends ChangeNotifier {
  final Auth? auth;

  GroupProvider(this.auth);

  /// List of groups that user belongs to.
  List<Group>? _groups;

  List<Group>? get groups => _groups;

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
  }
}
