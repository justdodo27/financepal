import 'package:flutter/material.dart';
import '../../../utils/api/models/payment.dart';
import 'no_data_widget.dart';
import 'payment_tile.dart';

class LastPaymentsSection extends StatelessWidget {
  final List<Payment> data;

  const LastPaymentsSection({
    super.key,
    required this.data,
  });

  List<Widget> _getRows() {
    if (data.isEmpty) {
      return [
        const NoDataWidget(
          text: 'No payments to display.',
        ),
      ];
    }

    return data.map((payment) => PaymentTile(payment: payment)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      color: Theme.of(context).colorScheme.onPrimary,
      child: Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        child: Column(
          children: _getRows(),
        ),
      ),
    );
  }
}
