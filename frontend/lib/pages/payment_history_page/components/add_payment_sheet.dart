import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../components/category_drop_down_button.dart';
import '../../../components/custom_text_field.dart';
import '../../../components/payment_proof_drop_down_button.dart';
import '../../../components/rounded_outlined_button.dart';
import '../../../components/text_field_placeholder.dart';
import '../../../providers/category_provider.dart';
import '../../../providers/payment_proof_provider.dart';
import '../../../providers/payment_provider.dart';
import '../../../utils/api/models/category.dart';
import '../../../utils/api/models/payment.dart';
import '../../../utils/api/models/payment_proof.dart';
import '../../../utils/snackbars.dart';

class AddPaymentSheet extends StatefulWidget {
  final Payment? payment;

  const AddPaymentSheet({
    super.key,
    this.payment,
  });

  @override
  State<AddPaymentSheet> createState() => _AddPaymentSheetState();
}

class _AddPaymentSheetState extends State<AddPaymentSheet> {
  final _name = TextEditingController();
  final _amount = TextEditingController();

  bool _isInvoice = false;
  PaymentProof? proof;

  late Category category;

  Future<void> createPayment() async {
    if (_name.text.isEmpty) {
      _name.text = 'Payment #${DateFormat('HHMMss').format(DateTime.now())}';
    }

    try {
      final payment = Payment(
        name: _name.text,
        type: _isInvoice ? 'INVOICE' : 'BILL',
        date: DateTime.now(),
        cost: double.parse(_amount.text),
        category: category,
        proof: proof,
      );
      await Provider.of<PaymentProvider>(context, listen: false)
          .addPayment(payment);
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    } finally {
      Navigator.of(context).pop();
    }
  }

  Future<void> updatePayment() async {
    if (widget.payment == null) return;
    final payment = Payment(
      id: widget.payment!.id,
      name: _name.text,
      type: _isInvoice ? 'INVOICE' : 'BILL',
      date: widget.payment!.date,
      cost: double.parse(_amount.text),
      category: category,
      proof: proof,
    );

    try {
      await Provider.of<PaymentProvider>(context, listen: false)
          .updatePayment(payment);
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    } finally {
      Navigator.of(context).pop();
    }
  }

  void _handleSubmit() async {
    if (widget.payment == null) {
      return await createPayment();
    }
    return await updatePayment();
  }

  @override
  void initState() {
    super.initState();
    if (widget.payment != null) {
      _name.text = widget.payment!.name;
      _amount.text = widget.payment!.cost.toString();
      _isInvoice = widget.payment!.type == 'INVOICE';
      category = widget.payment!.category;
      proof = widget.payment!.proof;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              'Add a payment',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              color: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _name,
                      hintText:
                          'e.g. Payment on ${DateFormat('dd.MM.yyyy').format(DateTime.now())}',
                      labelText: 'Name (optional)',
                    ),
                    CustomTextField(
                      controller: _amount,
                      hintText: 'e.g. 21.37',
                      labelText: 'Amount',
                    ),
                    Consumer<CategoryProvider>(
                      builder: (context, provider, child) {
                        if (provider.categories == null) {
                          return const TextFieldPlaceholder(
                            label: 'Category',
                          );
                        }

                        if (provider.categories!.isEmpty) {
                          return Container();
                        }

                        return CategoryDropDownButton(
                          selected: widget.payment?.category,
                          categories: provider.categories!,
                          onSelected: (selected) => category = selected,
                        );
                      },
                    ),
                    Consumer<PaymentProofProvider>(
                      builder: (context, provider, child) {
                        if (provider.paymentProofs == null) {
                          return const TextFieldPlaceholder(
                            label: 'Payment proof',
                          );
                        }

                        if (provider.paymentProofs!.isEmpty) {
                          return Container();
                        }

                        return PaymentProofDropDownButton(
                          selected: proof,
                          proofs: provider.paymentProofs!,
                          onSelected: (selected) => proof = selected,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      tileColor: Theme.of(context).colorScheme.onSecondary,
                      activeColor: Colors.green,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      title: Text(
                        'Invoice',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      value: _isInvoice,
                      onChanged: (value) => setState(() => _isInvoice = value!),
                    ),
                    const SizedBox(height: 16),
                    RoundedOutlinedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      onPressed: _handleSubmit,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Consumer<PaymentProvider>(
                          builder: (context, provider, child) {
                            if (provider.requestInProgress) {
                              return const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            }
                            return Text(
                              'Submit',
                              style: Theme.of(context).textTheme.bodyMedium,
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
