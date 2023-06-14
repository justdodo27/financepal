import 'package:flutter/material.dart';

import '../../../utils/api/models/limit.dart';
import 'notification_tile.dart';

class GroupNotificationsPage extends StatefulWidget {
  const GroupNotificationsPage({super.key});

  static List<Limit> limits = [
    Limit(
      id: 1,
      amount: 130,
      period: 'DAILY',
      isActive: true,
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
