import 'package:flutter/material.dart';
import 'package:frontend/pages/payment_history_page/components/add_payment_sheet.dart';
import 'package:frontend/utils/snackbars.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/payment_provider.dart';
import '../../../utils/api/models/payment.dart';

class PaymentTile extends StatelessWidget {
  final Payment payment;
  final IconData icon;
  final bool? showDate;

  const PaymentTile({
    super.key,
    required this.payment,
    this.icon = Icons.monetization_on,
    this.showDate,
  });

  void deletePayment(BuildContext context) async {
    try {
      await Provider.of<PaymentProvider>(context, listen: false)
          .deletePayment(payment.id!);
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

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
                          DateFormat('dd/MM/yyyy').format(payment.date),
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
                          '${payment.cost}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Category:',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          payment.category.name,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
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
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            title: Text(
                              'Are you sure you want to delete the "${payment.name}"?',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  deletePayment(context);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Yes',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  'No',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              )
                            ],
                          ),
                        ),
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
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            ),
                          ),
                          useSafeArea: true,
                          isScrollControlled: true,
                          builder: (context) =>
                              AddPaymentSheet(payment: payment),
                        ),
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
