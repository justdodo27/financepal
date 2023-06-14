import 'package:flutter/material.dart';
import 'package:frontend/pages/home_page/components/payment_stats_tile.dart';
import 'package:frontend/utils/api/models/payment_statistics.dart';
import 'no_data_widget.dart';

class LastPaymentsSection extends StatelessWidget {
  final List<PaymentStatistics> data;

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

    return data.map((stats) => PaymentStatsTile(paymentStats: stats)).toList();
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
