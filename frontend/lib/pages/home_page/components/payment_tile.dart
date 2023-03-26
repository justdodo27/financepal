import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'last_payments_section.dart';

class PaymentTile extends StatelessWidget {
  final PaymentData payment;
  final IconData icon;
  final bool? showDate;

  const PaymentTile({
    super.key,
    required this.payment,
    this.icon = Icons.monetization_on,
    this.showDate,
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
        leading: payment.isRecurring
            ? const Icon(Icons.replay_circle_filled,
                color: Colors.deepPurpleAccent)
            : const Icon(Icons.monetization_on, color: Colors.greenAccent),
        title: Text(
          payment.name,
          overflow: TextOverflow.ellipsis,
        ),
        childrenPadding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment date:',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          DateFormat('dd/MM')
                              .format(payment.date ?? DateTime.now()),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Amount:',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${payment.value}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    if (payment.category != null) ...{
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Category:',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '${payment.category}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    },
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: CircleAvatar(
                      maxRadius: 18,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete),
                        iconSize: 19,
                        color: Colors.white,
                        splashColor: Theme.of(context).colorScheme.tertiary,
                        splashRadius: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 8),
                    child: CircleAvatar(
                      maxRadius: 18,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                        iconSize: 19,
                        color: Colors.white,
                        splashColor: Theme.of(context).colorScheme.tertiary,
                        splashRadius: 25,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
