import 'package:flutter/material.dart';

import '../utils/api/models/category.dart';

class CategoryDropDownButton extends StatefulWidget {
  final Category? selected;
  final List<Category> categories;
  final Function(Category selected) onSelected;

  const CategoryDropDownButton({
    super.key,
    this.selected,
    required this.categories,
    required this.onSelected,
  });

  @override
  State<CategoryDropDownButton> createState() => _CategoryDropDownButtonState();
}

class _CategoryDropDownButtonState extends State<CategoryDropDownButton> {
  late Category selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.selected != null) {
      selectedCategory = widget.categories.firstWhere(
        (category) => category.id == widget.selected!.id,
      );
    } else {
      selectedCategory = widget.categories.first;
    }
    widget.onSelected(selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<Category>(
            itemHeight: 60,
            value: selectedCategory,
            items: widget.categories
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category.name),
                    ))
                .toList(),
            onChanged: (selected) {
              setState(() => selectedCategory = selected!);
              widget.onSelected(selectedCategory);
            },
            borderRadius: BorderRadius.circular(15.0),
            isExpanded: true,
            underline: Container(),
            style: Theme.of(context).textTheme.bodySmall,
            dropdownColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
