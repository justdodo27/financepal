import 'package:flutter/material.dart';

import 'coming_soon_label.dart';

class MainDrawer extends StatelessWidget {
  final int activePage;
  final Function(int value) onTabSelected;

  const MainDrawer({
    super.key,
    required this.activePage,
    required this.onTabSelected,
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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DrawerOption(
                isActive: activePage == 0,
                baseIcon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                onPressed: () {
                  onTabSelected(0);
                  Navigator.of(context).pop();
                },
              ),
              DrawerOption(
                isActive: activePage == 1,
                baseIcon: Icons.monetization_on_outlined,
                activeIcon: Icons.monetization_on,
                label: 'Payments',
                onPressed: () {
                  onTabSelected(1);
                  Navigator.of(context).pop();
                },
              ),
              DrawerOption(
                isActive: activePage == 2,
                baseIcon: Icons.replay_circle_filled_outlined,
                activeIcon: Icons.replay,
                label: 'Recurring payments',
                onPressed: () {
                  onTabSelected(2);
                  Navigator.of(context).pop();
                },
              ),
              DrawerOption(
                isActive: activePage == 3,
                baseIcon: Icons.category_outlined,
                activeIcon: Icons.category,
                label: 'Categories',
                onPressed: () {
                  onTabSelected(3);
                  Navigator.of(context).pop();
                },
              ),
              DrawerOption(
                isActive: activePage == 4,
                baseIcon: Icons.file_present_outlined,
                activeIcon: Icons.file_present_rounded,
                label: 'Proofs of payments',
                onPressed: () {
                  onTabSelected(4);
                  Navigator.of(context).pop();
                },
              ),
              Stack(
                children: [
                  DrawerOption(
                    isActive: activePage == 5,
                    baseIcon: Icons.group_outlined,
                    activeIcon: Icons.group,
                    label: 'Groups',
                    onPressed: () {
                      // onTabSelected(5);
                      // Navigator.of(context).pop();
                    },
                  ),
                   const Positioned(
                    top: 15,
                    right: 0,
                    child: ComingSoonLabel(),
                  ),
                ],
              ),
              DrawerOption(
                isActive: activePage == 6,
                baseIcon: Icons.insert_chart_outlined,
                activeIcon: Icons.insert_chart,
                label: 'Reports',
                onPressed: () {
                  onTabSelected(6);
                  Navigator.of(context).pop();
                },
              ),
              DrawerOption(
                isActive: activePage == 7,
                baseIcon: Icons.notifications_outlined,
                activeIcon: Icons.notifications,
                label: 'Notifications',
                onPressed: () {
                  onTabSelected(7);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
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
