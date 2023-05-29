import 'package:flutter/material.dart';
import 'package:frontend/utils/api/models/category.dart';

import 'category_tile.dart';

class GroupCategoriesPage extends StatelessWidget {
  const GroupCategoriesPage({super.key});

  static List<Category> categories = [];

  List<Widget> _getRows() {
    return categories
        .map((category) => CategoryTile(category: category))
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
