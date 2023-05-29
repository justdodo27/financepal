import 'package:flutter/material.dart';
import 'package:frontend/components/rounded_outlined_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/recurring_payment_provider.dart';
import '../../../utils/api/models/recurring_payment.dart';
import '../../../utils/snackbars.dart';
import 'add_recurring_payment_sheet.dart';

class RecurringPaymentTile extends StatelessWidget {
  final RecurringPayment recurringPayment;

  const RecurringPaymentTile({
    super.key,
    required this.recurringPayment,
  });

  void deleteRecurringPayment(BuildContext context) {
    try {
      Provider.of<RecurringPaymentProvider>(context, listen: false)
          .deleteRecurringPayment(recurringPayment.id!);
      Navigator.of(context).pop();
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

  void payTheBill(BuildContext context) {
    try {
      Provider.of<RecurringPaymentProvider>(context, listen: false)
          .payTheBill(recurringPayment);
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
    showSuccessSnackBar(context, 'Payment successfully saved!');
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
                'Amount',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '${recurringPayment.cost}',
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
          const SizedBox(height: 4),
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
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Category',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                recurringPayment.category.name,
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Last payment date:',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                recurringPayment.lastPaymentDate != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(recurringPayment.lastPaymentDate!)
                    : 'N/A',
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundedOutlinedButton(
                padding: EdgeInsets.zero,
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                child: Text(
                  'Pay the bill',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onPressed: () => payTheBill(context),
              ),
              Row(
                children: [
                  CircleAvatar(
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
                            'Are you sure you want to delete the "${recurringPayment.name}"?',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => deleteRecurringPayment(context),
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
                  const SizedBox(width: 8),
                  CircleAvatar(
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
                            AddRecurringPaymentSheet(payment: recurringPayment),
                      ),
                      icon: const Icon(Icons.edit),
                      iconSize: 19,
                      color: Colors.white,
                      splashColor: Theme.of(context).colorScheme.tertiary,
                      splashRadius: 25,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
