import 'package:flutter/material.dart';
import 'package:frontend/pages/notifications_page/components/add_notification_sheet.dart';
import 'package:frontend/pages/notifications_page/components/group_notification_page.dart';
import 'package:frontend/pages/notifications_page/components/user_notification_page.dart';

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
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          UserNotificationsPage(),
          GroupNotificationsPage(),
        ],
      ),
      floatingActionButton: Opacity(
        opacity: 0.85,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: null,
              onPressed: () => _controller.animateToPage(0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut),
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: null,
              onPressed: () => _controller.animateToPage(1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut),
              child: Icon(
                Icons.group,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
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
          ],
        ),
      ),
    );
  }
}
