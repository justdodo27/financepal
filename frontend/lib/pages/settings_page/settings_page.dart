import 'package:flutter/material.dart';
import 'package:frontend/themes/theme_manager.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .apply(color: Colors.white),
        ),
      ),
      body: Column(
        children: const [
          DarkModeSetting(),
        ],
      ),
    );
  }
}

class DarkModeSetting extends StatelessWidget {
  const DarkModeSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 8, left: 2, right: 2),
      color: Theme.of(context).colorScheme.onPrimary,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dark mode',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Switch(
              activeColor: Theme.of(context).colorScheme.tertiary,
              value: themeManager.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeManager.toggleTheme();
              },
            ),
          ],
        ),
      ),
    );
  }
}
