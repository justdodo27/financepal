import 'package:flutter/material.dart';
import 'package:frontend/pages/settings_page/components/account_setting.dart';

import 'components/dark_mode_setting.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .apply(color: Colors.white),
          ),
        ),
        body: const Column(
          children: [
            DarkModeSetting(),
            AccountSetting(),
          ],
        ),
      ),
    );
  }
}
