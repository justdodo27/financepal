import 'package:flutter/material.dart';
import 'package:frontend/pages/recurring_payments_page/components/add_recurring_payment_sheet.dart';
import 'package:frontend/utils/api/payment.dart';
import 'package:frontend/utils/api/recurring_payment.dart';
import 'package:provider/provider.dart';

import '../../providers/recurring_payment_provider.dart';
import '../../utils/api/category.dart';
import '../../utils/snackbars.dart';
import '../home_page/components/no_payment_data_widget.dart';
import 'components/recurring_payment_tile.dart';

class RecurringPaymentsPage extends StatefulWidget {
  const RecurringPaymentsPage({super.key});

  static List<Payment> payments = [
    Payment(
      id: 0,
      name: 'Test',
      type: 'RECURRING',
      date: DateTime.now(),
      cost: 89.99,
      category: Category(name: 'Groceries'),
    ),
  ];

  @override
  State<RecurringPaymentsPage> createState() => _RecurringPaymentsPageState();
}

class _RecurringPaymentsPageState extends State<RecurringPaymentsPage> {
  void fetchRecurringPayments() async {
    try {
      await Provider.of<RecurringPaymentProvider>(context, listen: false)
          .getRecurringPayments();
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<RecurringPaymentProvider>(
      context,
      listen: false,
    );
    if (provider.recurringPayments == null) {
      fetchRecurringPayments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 4,
            color: Theme.of(context).colorScheme.onPrimary,
            child: Consumer<RecurringPaymentProvider>(
              builder: (context, provider, child) {
                final recurringPayments =
                    provider.recurringPayments ?? <RecurringPayment>[];

                if (recurringPayments.isEmpty) {
                  return const NoPaymentDataWidget();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recurringPayments.length,
                  itemBuilder: (context, index) => RecurringPaymentTile(
                    recurringPayment: recurringPayments[index],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: Opacity(
        opacity: 0.85,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              useSafeArea: true,
              isScrollControlled: true,
              builder: (context) => const AddRecurringPaymentSheet(),
            );
          },
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
    );
  }
}
