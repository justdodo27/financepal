import '../providers/auth_provider.dart';

void handleIfNotLoggedIn(Auth? auth) {
  if (auth == null) throw Exception('User is not logged in.');
  if (!auth.isUserLoggedIn) throw Exception('User is not logged in.');
}
