import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../themes/theme_manager.dart';

class DarkModeSetting extends StatelessWidget {
  const DarkModeSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 8, left: 4, right: 4),
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
