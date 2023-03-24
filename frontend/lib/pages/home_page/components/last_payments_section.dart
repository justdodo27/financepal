import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentData {
  final String name;
  final double value;
  final Color color;
  final DateTime? date;

  PaymentData({
    required this.name,
    required this.value,
    required this.color,
    this.date,
  });
}

class LastPaymentsSection extends StatefulWidget {
  final List<PaymentData> data;

  const LastPaymentsSection({
    super.key,
    required this.data,
  });

  @override
  State<LastPaymentsSection> createState() => _LastPaymentsSectionState();
}

class _LastPaymentsSectionState extends State<LastPaymentsSection> {
  List<Widget> _getRows() {
    if (widget.data.isEmpty) {
      return [const NoPaymentDataWidget()];
    }

    return widget.data.map((payment) => PaymentTile(payment: payment)).toList();
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

class NoPaymentDataWidget extends StatelessWidget {
  const NoPaymentDataWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(
              Icons.monetization_on,
              color: Colors.redAccent,
            ),
            Text('No payments to display'),
            Icon(
              Icons.close,
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}

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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: payment.color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  payment.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (showDate ?? false) ...{
              Text(DateFormat('dd/MM').format(payment.date ?? DateTime.now())),
              const SizedBox(width: 16),
            },
            Text('${payment.value}'),
          ],
        ),
      ),
    );
  }
}
