import 'package:flutter/material.dart';

import '../../../utils/api/models/limit.dart';

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
      case 'YEARLY':
        return 'Yearly spendings > ${limit.amount}';
      default:
        return 'Daily spendings > ${limit.amount}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
