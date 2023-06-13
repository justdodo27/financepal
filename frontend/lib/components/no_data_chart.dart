import 'package:flutter/material.dart';

class NoDataChart extends StatelessWidget {
  const NoDataChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.info_outline,
              size: 50,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            Text(
              'No data is available',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
      ),
    );
  }
}
