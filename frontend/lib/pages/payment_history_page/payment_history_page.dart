import 'package:flutter/material.dart';
import 'package:frontend/utils/snackbars.dart';
import 'package:provider/provider.dart';

import '../../components/date_range_picker.dart';
import '../../components/loading_card.dart';
import '../../providers/payment_provider.dart';
import '../home_page/components/no_data_widget.dart';
import '../home_page/components/payment_tile.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  late DateTimeRange _dateTimeRange;

  void fetchPayments() async {
    try {
      await Provider.of<PaymentProvider>(context, listen: false)
          .getPayments(_dateTimeRange);
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

  Future<void> reloadPayments() async {
    try {
      await Provider.of<PaymentProvider>(context, listen: false)
          .getPayments(_dateTimeRange);
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PaymentProvider>(context, listen: false);
    if (provider.range != null) {
      _dateTimeRange = provider.range!;
    } else {
      final now = DateTime.now();
      _dateTimeRange = DateTimeRange(
        start: DateTime(now.year, now.month, now.day),
        end: DateTime(now.year, now.month, now.day)
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1)),
      );
    }
    if (provider.payments == null) fetchPayments();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.tertiary,
      onRefresh: reloadPayments,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          DateRangePicker(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            dateTimeRange: _dateTimeRange,
            onDateTimePicked: (selected) {
              setState(() => _dateTimeRange = selected);
              fetchPayments();
            },
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 4,
            color: Theme.of(context).colorScheme.onPrimary,
            child: Consumer<PaymentProvider>(
              builder: (context, provider, child) {
                final payments = provider.payments;

                if (payments == null) {
                  return const LoadingCard();
                }

                if (payments.isEmpty) {
                  return const NoDataWidget(
                    text: 'No payments to display.',
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: payments.length,
                  itemBuilder: (context, index) =>
                      PaymentTile(payment: payments[index]),
                );
              },
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
