import 'package:flutter/material.dart';

import '../../../utils/api/recurring_payment.dart';

class RecurringPaymentTile extends StatelessWidget {
  final RecurringPayment recurringPayment;

  const RecurringPaymentTile({
    super.key,
    required this.recurringPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        collapsedTextColor: Theme.of(context).textTheme.bodyMedium!.color,
        textColor: Theme.of(context).textTheme.bodyMedium!.color,
        iconColor: Theme.of(context).textTheme.bodyMedium!.color,
        leading: const Icon(
          Icons.replay_circle_filled,
          color: Colors.deepPurpleAccent,
        ),
        title: Text(
          recurringPayment.name,
          overflow: TextOverflow.ellipsis,
        ),
        childrenPadding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment date:',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                recurringPayment.date,
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
        ],
      ),
    );
  }
}
