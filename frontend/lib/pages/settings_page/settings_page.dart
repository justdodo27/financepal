import 'package:flutter/material.dart';
import 'package:frontend/pages/settings_page/components/account_setting.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_manager.dart';
import 'components/dark_mode_setting.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Consumer<ThemeManager>(
            builder: (context, theme, child) => IconButton(
              splashRadius: 25,
              icon: Icon(
                Icons.arrow_back,
                color: theme.isDark ? Colors.white : Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Consumer<ThemeManager>(
            builder: (context, theme, child) => Text(
              'Settings',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .apply(color: theme.isDark ? Colors.white : Colors.black),
            ),
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
