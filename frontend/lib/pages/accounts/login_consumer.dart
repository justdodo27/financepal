import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/api_provider.dart';
import '../main_page/main_page.dart';
import 'login_page.dart';

class LoginConsumer extends StatelessWidget {
  const LoginConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BackendApi>(
      builder: (context, backendApi, child) {
        if (backendApi.token != null) return const MainPage();
        return const LoginPage();
      },
    );
  }
}
