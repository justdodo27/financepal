import 'package:flutter/material.dart';

import '../../../utils/api/models/payment_statistics.dart';

class PaymentStatsTile extends StatelessWidget {
  final PaymentStatistics paymentStats;

  const PaymentStatsTile({
    super.key,
    required this.paymentStats,
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
        leading: const Icon(Icons.monetization_on, color: Colors.green),
        title: Text(
          paymentStats.name,
          overflow: TextOverflow.ellipsis,
        ),
        childrenPadding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total cost:',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    paymentStats.value.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total payments count:',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${paymentStats.count}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
          ),
        ],
      ),
    );
  }
}
