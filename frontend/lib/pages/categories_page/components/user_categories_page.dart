import 'package:flutter/material.dart';

import '../categories_page.dart';
import 'category_tile.dart';

class UserCategoriesPage extends StatelessWidget {
  const UserCategoriesPage({super.key});

  static List<Category> categories = [
    Category(name: 'Groceries'),
    Category(name: 'Chemicals'),
    Category(name: 'Electronics'),
    Category(name: 'Music'),
    Category(name: 'Films and Videos'),
    Category(name: 'Alcohol'),
    Category(name: 'Groceries'),
    Category(name: 'Chemicals'),
    Category(name: 'Electronics'),
    Category(name: 'Music'),
    Category(name: 'Films and Videos'),
    Category(name: 'Alcohol'),
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
