import 'package:flutter/material.dart';

class SmallRoundedOutlinedTextButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final EdgeInsets padding;
  final double width;
  final Color? backgroundColor;
  final Color? borderColor;
  final OutlinedBorder shape;

  const SmallRoundedOutlinedTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.padding = const EdgeInsets.all(8.0),
    this.backgroundColor,
    this.borderColor,
    this.width = 100.0,
    this.shape = const StadiumBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: width),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor:
                backgroundColor ?? Theme.of(context).colorScheme.onBackground,
            shape: shape,
            side: BorderSide(
              color: borderColor ?? Theme.of(context).colorScheme.onBackground,
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .apply(displayColor: Colors.white)
                .bodySmall,
          ),
        ),
      ),
    );
  }
}

class RoundedOutlinedButton extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final EdgeInsets padding;
  final double width;
  final Color? backgroundColor;
  final Color? borderColor;
  final OutlinedBorder shape;

  const RoundedOutlinedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.padding = const EdgeInsets.all(8.0),
    this.backgroundColor,
    this.borderColor,
    this.width = 100.0,
    this.shape = const StadiumBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: width),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor:
                backgroundColor ?? Theme.of(context).colorScheme.onBackground,
            shape: shape,
            side: BorderSide(
              color: borderColor ?? Theme.of(context).colorScheme.onBackground,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
