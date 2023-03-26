import 'package:flutter/material.dart';

import '../categories_page.dart';
import 'category_tile.dart';

class GroupCategoriesPage extends StatelessWidget {
  const GroupCategoriesPage({super.key});

  static List<Category> categories = [
    Category(name: 'Groceries', isGroupCategory: true, group: 'Friends'),
    Category(name: 'Chemicals', isGroupCategory: true, group: 'Friends'),
    Category(name: 'Electronics', isGroupCategory: true, group: 'Friends'),
    Category(name: 'Music', isGroupCategory: true, group: 'Friends'),
    Category(name: 'Films and Videos', isGroupCategory: true, group: 'Friends'),
    Category(name: 'Alcohol', isGroupCategory: true, group: 'Friends'),
    Category(name: 'Groceries', isGroupCategory: true, group: 'Family'),
    Category(name: 'Chemicals', isGroupCategory: true, group: 'Family'),
    Category(
        name: 'Electronics',
        isGroupCategory: true,
        group: 'Family asdasasdassada  asdas das'),
    Category(name: 'Music', isGroupCategory: true, group: 'Family'),
    Category(name: 'Films and Videos', isGroupCategory: true, group: 'Family'),
    Category(name: 'Alcohol', isGroupCategory: true, group: 'Family'),
  ];

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