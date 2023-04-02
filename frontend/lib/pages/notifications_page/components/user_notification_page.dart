import 'package:flutter/material.dart';
import 'package:frontend/pages/notifications_page/components/add_notification_sheet.dart';

import 'notification_tile.dart';

class UserNotificationsPage extends StatefulWidget {
  const UserNotificationsPage({super.key});

  static List<Limit> limits = [
    Limit(
      value: 100,
      option: 'DAILY',
      isActive: true,
    ),
    Limit(
      value: 1000,
      option: 'MONTHLY',
      isActive: true,
    ),
    Limit(
      value: 12000,
      option: 'YEARLY',
      isActive: false,
    ),
  ];

  @override
  State<UserNotificationsPage> createState() => _UserNotificationsPageState();
}

class _UserNotificationsPageState extends State<UserNotificationsPage> {
  List<Widget> _getRows() {
    return UserNotificationsPage.limits
        .map((limit) => NotificationTile(
              limit: limit,
              onSwitch: (value) => setState(() => limit.isActive = value),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 4,
            color: Theme.of(context).colorScheme.onPrimary,
            child: Column(
              children: _getRows(),
            ),
          ),
          const SizedBox(height: 220),
        ],
      ),
    );
  }
}
