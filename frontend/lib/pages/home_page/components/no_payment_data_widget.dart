import 'package:flutter/material.dart';

class NoPaymentDataWidget extends StatelessWidget {
  const NoPaymentDataWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.monetization_on,
              color: Colors.redAccent,
            ),
            Text('No payments to display'),
            Icon(
              Icons.close,
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
