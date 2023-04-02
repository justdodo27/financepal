import 'package:flutter/material.dart';

import 'add_notification_sheet.dart';
import 'notification_tile.dart';

class GroupNotificationsPage extends StatefulWidget {
  const GroupNotificationsPage({super.key});

  static List<Limit> limits = [
    Limit(
      value: 130,
      option: 'DAILY',
      isActive: true,
      groupName: 'Friends',
    ),
    Limit(
      value: 1400,
      option: 'MONTHLY',
      isActive: true,
      groupName: 'Friends',
    ),
    Limit(
      value: 12200,
      option: 'YEARLY',
      isActive: false,
      groupName: 'Friends',
    ),
    Limit(
      value: 150,
      option: 'DAILY',
      isActive: true,
      groupName: 'Students',
    ),
    Limit(
      value: 1600,
      option: 'MONTHLY',
      isActive: true,
      groupName: 'Students',
    ),
    Limit(
      value: 18000,
      option: 'YEARLY',
      isActive: false,
      groupName: 'Students',
    ),
  ];

  @override
  State<GroupNotificationsPage> createState() => _GroupNotificationsPageState();
}

class _GroupNotificationsPageState extends State<GroupNotificationsPage> {
  List<Widget> _getRows() {
    return GroupNotificationsPage.limits
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
