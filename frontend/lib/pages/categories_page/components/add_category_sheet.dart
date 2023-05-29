import 'package:flutter/material.dart';
import 'package:frontend/utils/api/models/category.dart';
import 'package:frontend/utils/snackbars.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_text_field.dart';
import '../../../components/rounded_outlined_button.dart';
import '../../../providers/category_provider.dart';

class AddCategorySheet extends StatefulWidget {
  final Category? category;

  const AddCategorySheet({
    super.key,
    this.category,
  });

  @override
  State<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _group = TextEditingController();

  void createCategory() async {
    try {
      await Provider.of<CategoryProvider>(context, listen: false)
          .addCategory(Category(name: _name.text));
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    } finally {
      Navigator.of(context).pop();
    }
  }

  void editCategory() async {
    try {
      widget.category!.name = _name.text;
      await Provider.of<CategoryProvider>(context, listen: false)
          .editCategory(widget.category!);
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    } finally {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _name.text = widget.category!.name;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _group.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                'Add a category',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 1,
                color: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _name,
                        hintText: 'e.g. Groceries',
                        labelText: 'Name',
                        validator: (value) => value!.isEmpty
                            ? 'Enter at least one character.'
                            : null,
                      ),
                      // CustomTextField(
                      //   controller: _group,
                      //   hintText: 'e.g. Friends',
                      //   labelText: 'Group (optional)',
                      // ),
                      const SizedBox(height: 16),
                      RoundedOutlinedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        onPressed: widget.category == null
                            ? createCategory
                            : editCategory,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Submit',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
