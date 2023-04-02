import 'package:flutter/material.dart';

import '../../components/date_range_picker.dart';
import '../home_page/components/last_payments_section.dart';
import '../home_page/components/no_payment_data_widget.dart';
import '../home_page/components/payment_tile.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  static List<PaymentData> payments = [
    PaymentData(
        name: 'Biedronka groceries', value: 25.62, category: 'Groceries'),
    PaymentData(
        name: 'Media Expert electronics',
        value: 15.22,
        category: 'Electronics'),
    PaymentData(
        name: 'Biedronka chemicals', value: 12.23, category: 'Chemicals'),
    PaymentData(name: 'Lidl shopping', value: 25.62, category: 'Groceries'),
    PaymentData(name: 'Gym payment', value: 15.22, category: 'Gym'),
    PaymentData(name: 'Spotify', value: 12.23, category: 'Music'),
  ];

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  DateTimeRange _dateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  List<Widget> _getRows() {
    if (PaymentHistoryPage.payments.isEmpty) {
      return const [NoPaymentDataWidget()];
    }
    return PaymentHistoryPage.payments
        .map((payment) => PaymentTile(payment: payment))
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
              children: [
                DateRangePicker(
                  dateTimeRange: _dateTimeRange,
                  onDateTimePicked: (selected) =>
                      setState(() => _dateTimeRange = selected),
                ),
                ..._getRows(),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
