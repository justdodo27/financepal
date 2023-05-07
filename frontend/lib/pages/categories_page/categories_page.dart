import 'package:flutter/material.dart';

import 'components/add_category_sheet.dart';
import 'components/user_categories_page.dart';

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
          //GroupCategoriesPage(),
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
            // TODO: Implement group categories
            // const SizedBox(height: 12),
            // FloatingActionButton(
            //   heroTag: null,
            //   onPressed: () => _controller.animateToPage(1,
            //       duration: const Duration(milliseconds: 300),
            //       curve: Curves.easeInOut),
            //   child: Icon(
            //     Icons.group,
            //     color: Theme.of(context).colorScheme.tertiary,
            //   ),
            // ),
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
                builder: (context) => const AddCategorySheet(),
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

