import 'package:flutter/material.dart';
import 'package:frontend/providers/category_provider.dart';
import 'package:frontend/utils/snackbars.dart';
import 'package:provider/provider.dart';

import '../../../utils/api/models/category.dart';
import 'add_category_sheet.dart';

class CategoryTile extends StatelessWidget {
  final Category category;

  const CategoryTile({
    super.key,
    required this.category,
  });

  void deleteCategory(BuildContext context) async {
    try {
      await Provider.of<CategoryProvider>(context, listen: false)
          .deleteCategory(category);
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    } finally {
      Navigator.of(context).pop();
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 65),
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
                              'Group name',
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
              if (!category.isGeneralCategory)
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: IconButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            title: Text(
                              'Are you sure you want to delete the "${category.name}" category?',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => deleteCategory(context),
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
                        ),
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
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            ),
                          ),
                          useSafeArea: true,
                          isScrollControlled: true,
                          builder: (context) =>
                              AddCategorySheet(category: category),
                        ),
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
    return const Stack(
      children: [
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
