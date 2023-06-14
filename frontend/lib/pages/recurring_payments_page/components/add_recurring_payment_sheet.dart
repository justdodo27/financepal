import 'package:flutter/material.dart';
import 'package:frontend/components/date_picker_button.dart';
import 'package:frontend/components/frequency_dropdown_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../components/category_drop_down_button.dart';
import '../../../components/custom_text_field.dart';
import '../../../components/rounded_outlined_button.dart';
import '../../../components/text_field_placeholder.dart';
import '../../../providers/category_provider.dart';
import '../../../providers/recurring_payment_provider.dart';
import '../../../utils/api/models/category.dart';
import '../../../utils/api/models/recurring_payment.dart';
import '../../../utils/snackbars.dart';

class AddRecurringPaymentSheet extends StatefulWidget {
  final RecurringPayment? payment;
  const AddRecurringPaymentSheet({super.key, this.payment});

  @override
  State<AddRecurringPaymentSheet> createState() =>
      _AddRecurringPaymentSheetState();
}

class _AddRecurringPaymentSheetState extends State<AddRecurringPaymentSheet> {
  final _name = TextEditingController();
  final _amount = TextEditingController();

  bool _isInvoice = false;

  late Category category;
  late String frequency;
  late DateTime date;

  Future<void> createPayment() async {
    if (_name.text.isEmpty) {
      _name.text = 'Payment #${DateFormat('HHMMss').format(DateTime.now())}';
    }

    try {
      final payment = RecurringPayment(
        name: _name.text,
        type: _isInvoice ? 'INVOICE' : 'BILL',
        cost: double.parse(_amount.text),
        category: category,
        frequency: frequency.toUpperCase(),
        paymentDate: date,
      );
      await Provider.of<RecurringPaymentProvider>(context, listen: false)
          .addRecurringPayment(payment);
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    } finally {
      Navigator.of(context).pop();
    }
  }

  Future<void> updatePayment() async {
    if (_name.text.isEmpty) {
      _name.text = 'Payment #${DateFormat('HHMMss').format(DateTime.now())}';
    }

    try {
      final payment = RecurringPayment(
        id: widget.payment!.id,
        name: _name.text,
        type: _isInvoice ? 'INVOICE' : 'BILL',
        cost: double.parse(_amount.text),
        category: category,
        frequency: frequency.toUpperCase(),
        paymentDate: date,
      );
      await Provider.of<RecurringPaymentProvider>(context, listen: false)
          .updateRecurringPayment(payment);
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
      frequency = widget.payment!.frequency;
      date = widget.payment!.paymentDate;
    }
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
              'Add a recurring payment',
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
                      hintText: 'e.g. Spotify, Netflix, Amazon Prime, etc...',
                      labelText: 'Name',
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
                    FrequencyDropDownButton(
                      selected: widget.payment?.frequency,
                      onSelected: (selected) => frequency = selected,
                    ),
                    DatePickerButton(
                      onDateChanged: (selected) => date = selected,
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
                        child: Text(
                          'Submit',
                          style: Theme.of(context).textTheme.bodyMedium,
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
