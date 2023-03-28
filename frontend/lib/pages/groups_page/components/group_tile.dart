import 'package:flutter/material.dart';

import '../groups_page.dart';

class GroupTile extends StatelessWidget {
  final Group group;
  const GroupTile({
    super.key,
    required this.group,
  });

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
                  const Icon(
                    Icons.group,
                    color: Colors.purpleAccent,
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Text(
                      group.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward_outlined),
            )
          ],
        ),
      ),
    );
  }
}
