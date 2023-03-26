import 'package:flutter/material.dart';

import '../home_page/components/last_payments_section.dart';

class RecurringPaymentsPage extends StatefulWidget {
  const RecurringPaymentsPage({super.key});

  static List<PaymentData> payments = [
    PaymentData(
        name: 'Shopify', value: 25.62, isRecurring: true, category: 'Music'),
    PaymentData(
        name: 'Netflix',
        value: 15.22,
        isRecurring: true,
        category: 'Films and Videos'),
    PaymentData(
        name: 'HBO',
        value: 12.23,
        isRecurring: true,
        category: 'Films and Videos'),
    PaymentData(
        name: 'Disney+',
        value: 25.62,
        isRecurring: true,
        category: 'Films and Videos'),
    PaymentData(name: 'Gym', value: 15.22, isRecurring: true, category: 'Gym'),
    PaymentData(
        name: 'PrimeVideo',
        value: 12.23,
        isRecurring: true,
        category: 'Films and Videos'),
  ];

  @override
  State<RecurringPaymentsPage> createState() => _RecurringPaymentsPageState();
}

class _RecurringPaymentsPageState extends State<RecurringPaymentsPage> {
  List<Widget> _getRows() {
    if (RecurringPaymentsPage.payments.isEmpty) {
      return const [NoPaymentDataWidget()];
    }
    return RecurringPaymentsPage.payments
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
