import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  final int activePage;

  const MainDrawer({
    super.key,
    required this.activePage,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DrawerOption(
              isActive: activePage == 0,
              baseIcon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Home',
              onPressed: () {},
            ),
            DrawerOption(
              isActive: activePage == 1,
              baseIcon: Icons.monetization_on_outlined,
              activeIcon: Icons.monetization_on,
              label: 'Payments history',
              onPressed: () {},
            ),
            DrawerOption(
              isActive: activePage == 2,
              baseIcon: Icons.replay_circle_filled_outlined,
              activeIcon: Icons.replay,
              label: 'Recurring payments',
              onPressed: () {},
            ),
            DrawerOption(
              isActive: activePage == 3,
              baseIcon: Icons.note_add_outlined,
              activeIcon: Icons.note_add,
              label: 'Add proof of payment',
              onPressed: () {},
            ),
            DrawerOption(
              isActive: activePage == 4,
              baseIcon: Icons.group_outlined,
              activeIcon: Icons.group,
              label: 'Groups',
              onPressed: () {},
            ),
            DrawerOption(
              isActive: activePage == 5,
              baseIcon: Icons.insert_chart_outlined,
              activeIcon: Icons.insert_chart,
              label: 'Generate a report',
              onPressed: () {},
            ),
            DrawerOption(
              isActive: activePage == 6,
              baseIcon: Icons.notification_add_outlined,
              activeIcon: Icons.notification_add,
              label: 'Set notifications',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerOption extends StatelessWidget {
  final bool isActive;
  final IconData activeIcon;
  final IconData baseIcon;
  final String label;
  final Function() onPressed;

  const DrawerOption({
    super.key,
    required this.activeIcon,
    required this.baseIcon,
    required this.label,
    required this.onPressed,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          elevation: 1,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                isActive ? activeIcon : baseIcon,
                color: isActive
                    ? Theme.of(context).colorScheme.tertiary
                    : Colors.grey,
              ),
              const SizedBox(width: 16),
              Text(label, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
