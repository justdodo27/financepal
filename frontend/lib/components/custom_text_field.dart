import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final EdgeInsets padding;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: controller,
        cursorColor: Theme.of(context).textTheme.bodyMedium!.color,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          labelStyle: Theme.of(context)
              .textTheme
              .bodySmall!
              .apply(color: const Color.fromARGB(255, 100, 100, 100)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
