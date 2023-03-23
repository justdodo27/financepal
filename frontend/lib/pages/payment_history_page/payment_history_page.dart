import 'package:flutter/material.dart';
import 'package:frontend/components/rounded_outlined_button.dart';
import 'package:intl/intl.dart';

import '../home_page/components/last_payments_section.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  static List<PaymentData> payments = [
    PaymentData(
        name: 'Biedronka groceries', value: 25.62, color: Colors.greenAccent),
    PaymentData(
        name: 'Media Expert electronics',
        value: 15.22,
        color: Colors.greenAccent),
    PaymentData(
        name: 'Biedronka chemicals', value: 12.23, color: Colors.greenAccent),
    PaymentData(name: 'Lidl shopping', value: 25.62, color: Colors.greenAccent),
    PaymentData(name: 'Gym payment', value: 15.22, color: Colors.greenAccent),
    PaymentData(name: 'Spotify', value: 12.23, color: Colors.greenAccent),
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
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4,
        color: Theme.of(context).colorScheme.onPrimary,
        child: Column(
          children: [
            SmallRoundedOutlinedButton(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              borderColor: Colors.grey,
              onPressed: () async {
                DateTimeRange? selected = await showDateRangePicker(
                  context: context,
                  initialDateRange: _dateTimeRange,
                  firstDate: DateTime(2023, 1),
                  lastDate: DateTime(2223, 1),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                              primary: Theme.of(context).colorScheme.tertiary,
                            ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (selected == null) return;
                setState(() => _dateTimeRange = selected);
              },
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ),
                    Text(
                      '${DateFormat('dd.MM.yyyy').format(_dateTimeRange.start)} - ${DateFormat('dd.MM.yyyy').format(_dateTimeRange.end)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Icon(
                      Icons.edit,
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ),
                  ],
                ),
              ),
            ),
            ..._getRows(),
          ],
        ),
      ),
    );
  }
}
