import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
        if (account.isLoading) {
          return Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.primary,
            highlightColor: Theme.of(context).colorScheme.onPrimary,
            child: const SafeArea(child: Scaffold()),
          );
        }
        return const LoginPage();
      },
    );
  }
}
