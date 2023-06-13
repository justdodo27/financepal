import 'package:flutter/material.dart';
import 'package:frontend/utils/snackbars.dart';
import 'package:provider/provider.dart';

import '../../../providers/category_provider.dart';
import '../../../utils/api/models/category.dart';
import 'category_tile.dart';

class UserCategoriesPage extends StatefulWidget {
  const UserCategoriesPage({super.key});

  @override
  State<UserCategoriesPage> createState() => _UserCategoriesPageState();
}

class _UserCategoriesPageState extends State<UserCategoriesPage> {
  void fetchCategories() async {
    final categories =
        Provider.of<CategoryProvider>(context, listen: false).categories;
    if (categories != null) return;
    try {
      await Provider.of<CategoryProvider>(context, listen: false)
          .getCategories();
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

  Future<void> reloadCategories() async {
    try {
      await Provider.of<CategoryProvider>(context, listen: false)
          .reloadCategories();
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.tertiary,
      onRefresh: reloadCategories,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 4,
            color: Theme.of(context).colorScheme.onPrimary,
            child: Consumer<CategoryProvider>(
              builder: (context, provider, child) {
                final categories = provider.categories ?? <Category>[];
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) =>
                      CategoryTile(category: categories[index]),
                );
              },
            ),
          ),
          const SizedBox(height: 220)
        ],
      ),
    );
  }
}
