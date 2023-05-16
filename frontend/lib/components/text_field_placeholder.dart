import 'package:flutter/material.dart';

class TextFieldPlaceholder extends StatelessWidget {
  final String label;
  final EdgeInsets padding;

  const TextFieldPlaceholder({
    super.key,
    required this.label,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .apply(color: const Color.fromARGB(255, 100, 100, 100)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox(
                height: 12,
                width: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}