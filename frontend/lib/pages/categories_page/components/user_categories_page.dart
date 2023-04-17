import 'package:flutter/material.dart';
import 'package:frontend/providers/api_provider.dart';
import 'package:frontend/utils/snackbars.dart';
import 'package:provider/provider.dart';

import '../../../utils/api/category.dart';
import 'category_tile.dart';

class UserCategoriesPage extends StatefulWidget {
  const UserCategoriesPage({super.key});

  @override
  State<UserCategoriesPage> createState() => _UserCategoriesPageState();
}

class _UserCategoriesPageState extends State<UserCategoriesPage> {
  void fetchCategories() async {
    if (Provider.of<BackendApi>(context, listen: false).categories == null) {
      try {
        await Provider.of<BackendApi>(context, listen: false).getCategories();
      } on Exception catch (e) {
        showExceptionSnackBar(context, e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          color: Theme.of(context).colorScheme.onPrimary,
          child: Consumer<BackendApi>(
            builder: (context, backendApi, child) {
              final categories = backendApi.categories ?? <Category>[];
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
    );
  }
}
