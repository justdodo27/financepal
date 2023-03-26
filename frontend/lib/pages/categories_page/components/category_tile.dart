import 'package:flutter/material.dart';

import '../categories_page.dart';

class CategoryTile extends StatelessWidget {
  final Category category;

  const CategoryTile({
    super.key,
    required this.category,
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
                  category.isGroupCategory
                      ? const GroupCategoryIcon()
                      : const Icon(Icons.category, color: Colors.blue),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (category.isGroupCategory)
                          Text(
                            category.group!,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.delete),
                    iconSize: 22,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                    splashRadius: 22,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                    iconSize: 22,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                    splashRadius: 22,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class GroupCategoryIcon extends StatelessWidget {
  const GroupCategoryIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        SizedBox(height: 25, width: 25),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topLeft,
            child: Icon(
              Icons.category,
              color: Colors.blue,
              size: 18,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.group,
              color: Colors.amber,
              size: 15,
            ),
          ),
        )
      ],
    );
  }
}
