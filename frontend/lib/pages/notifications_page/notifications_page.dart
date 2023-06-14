import 'package:flutter/material.dart';

import 'components/add_notification_sheet.dart';
import 'components/user_notification_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const UserNotificationsPage(),
      floatingActionButton: Opacity(
        opacity: 0.85,
        child: FloatingActionButton(
          heroTag: null,
          onPressed: () => showModalBottomSheet(
            context: context,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            useSafeArea: true,
            isScrollControlled: true,
            builder: (context) => const AddNotificationSheet(),
          ),
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
    );
  }
}
