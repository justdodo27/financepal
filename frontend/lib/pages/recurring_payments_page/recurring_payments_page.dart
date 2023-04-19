import 'package:flutter/material.dart';
import 'package:frontend/utils/api/payment.dart';

import '../../utils/api/category.dart';
import '../home_page/components/no_payment_data_widget.dart';
import '../home_page/components/payment_tile.dart';

class RecurringPaymentsPage extends StatelessWidget {
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

  List<Widget> _getRows() {
    if (payments.isEmpty) {
      return const [NoPaymentDataWidget()];
    }
    return payments
        .map((payment) => PaymentTile(
              payment: payment,
              icon: Icons.replay_circle_filled_rounded,
              showDate: true,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 4,
            color: Theme.of(context).colorScheme.onPrimary,
            child: Column(
              children: _getRows(),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
