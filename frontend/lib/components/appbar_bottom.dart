import 'package:flutter/material.dart';

class AppBarBottom extends StatelessWidget {
  final double height;
  final Widget child;

  const AppBarBottom({super.key, required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: height),
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset.zero,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
