import 'package:flutter/material.dart';

import 'components/group_categories_page.dart';
import 'components/user_categories_page.dart';

class Category {
  final String name;
  final String? group;
  final bool isGroupCategory;

  Category({required this.name, this.isGroupCategory = false, this.group});
}

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
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
          UserCategoriesPage(),
          GroupCategoriesPage(),
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
              onPressed: () => _controller.animateToPage(1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut),
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





