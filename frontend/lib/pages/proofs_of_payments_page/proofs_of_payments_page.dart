import 'package:flutter/material.dart';
import 'package:frontend/pages/home_page/components/no_data_widget.dart';
import 'package:frontend/pages/proofs_of_payments_page/components/add_payment_proof_sheet.dart';
import 'package:frontend/providers/payment_proof_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/snackbars.dart';
import 'components/proof_of_payment_tile.dart';

class ProofsOfPaymentsPage extends StatefulWidget {
  const ProofsOfPaymentsPage({super.key});

  @override
  State<ProofsOfPaymentsPage> createState() => _ProofsOfPaymentsPageState();
}

class _ProofsOfPaymentsPageState extends State<ProofsOfPaymentsPage> {
  Future<void> reloadPaymentProofs() async {
    try {
      await Provider.of<PaymentProofProvider>(context, listen: false)
          .reloadProofsOfPayments();
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.tertiary,
        onRefresh: reloadPaymentProofs,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 4,
              color: Theme.of(context).colorScheme.onPrimary,
              child: Consumer<PaymentProofProvider>(
                builder: (context, provider, child) {
                  final paymentProofs = provider.paymentProofs ?? [];

                  if (paymentProofs.isEmpty) {
                    return const NoDataWidget(
                        text: 'No proofs of payment to display');
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: paymentProofs.length,
                    itemBuilder: (context, index) =>
                        PaymentProofTile(proof: paymentProofs[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Opacity(
        opacity: 0.85,
        child: FloatingActionButton(
          heroTag: null,
          onPressed: () => showModalBottomSheet(
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
            builder: (context) => const AddPaymentProofSheet(),
          ),
          child: Icon(
            Icons.note_add,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
    );
  }
}
