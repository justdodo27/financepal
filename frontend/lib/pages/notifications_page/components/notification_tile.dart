import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/limit_provider.dart';
import '../../../utils/api/models/limit.dart';
import '../../../utils/snackbars.dart';

class NotificationTile extends StatelessWidget {
  final Limit limit;
  final Function(bool value) onSwitch;

  const NotificationTile({
    super.key,
    required this.limit,
    required this.onSwitch,
  });

  String get label {
    switch (limit.period) {
      case 'MONTHLY':
        return 'Monthly spendings > ${limit.amount}';
      case 'WEEKLY':
        return 'Weekly spendings > ${limit.amount}';
      default:
        return 'Daily spendings > ${limit.amount}';
    }
  }

  Future<void> deleteLimit(BuildContext context, Limit limit) async {
    final provider = Provider.of<LimitProvider>(context, listen: false);
    try {
      await provider.deleteLimit(limit);
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

  void _showDeleteDialog(BuildContext context, Limit limit) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            'Do you want to delete a notification about a ${limit.period.toLowerCase()} limit?',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                deleteLimit(context, limit);
                Navigator.of(context).pop();
              },
              child: Text(
                'Yes',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'No',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showDeleteDialog(context, limit),
      child: Card(
        elevation: 1,
        color: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      color: limit.isActive ? Colors.amberAccent : Colors.grey,
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            overflow: TextOverflow.clip,
                            style: Theme.of(context).textTheme.bodySmall!.apply(
                                  color: !limit.isActive
                                      ? Colors.grey
                                      : Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .color,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                activeColor: Colors.green,
                inactiveTrackColor: Colors.redAccent,
                value: limit.isActive,
                onChanged: onSwitch,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupLimitIcon extends StatelessWidget {
  final bool isActive;

  const GroupLimitIcon({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SizedBox(height: 25, width: 25),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topLeft,
            child: Icon(
              Icons.notifications,
              color: isActive ? Colors.amberAccent : Colors.grey,
              size: 18,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.group,
              color: isActive ? Colors.blue : Colors.blueGrey,
              size: 15,
            ),
          ),
        )
      ],
    );
  }
}
