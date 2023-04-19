import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../main_page/main_page.dart';
import 'login_page.dart';

class LoginConsumer extends StatelessWidget {
  const LoginConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, account, child) {
        if (account.isUserLoggedIn) return const MainPage();
        return const LoginPage();
      },
    );
  }
}
