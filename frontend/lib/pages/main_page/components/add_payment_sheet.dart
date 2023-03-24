import 'package:flutter/material.dart';

import '../../../components/custom_text_field.dart';
import '../../../components/rounded_outlined_button.dart';

class AddPaymentSheet extends StatefulWidget {
  const AddPaymentSheet({
    super.key,
  });

  @override
  State<AddPaymentSheet> createState() => _AddPaymentSheetState();
}

class _AddPaymentSheetState extends State<AddPaymentSheet> {
  final _amount = TextEditingController();
  final _category = TextEditingController();

  bool _isRecurring = false;

  @override
  void dispose() {
    _amount.dispose();
    _category.dispose();
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
                      controller: _amount,
                      hintText: 'e.g. 21.37',
                      labelText: 'Amount',
                    ),
                    CustomTextField(
                      controller: _category,
                      hintText: 'e.g. Groceries',
                      labelText: 'Category',
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
                        'Recurring payment',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      value: _isRecurring,
                      onChanged: (value) =>
                          setState(() => _isRecurring = value!),
                    ),
                    const SizedBox(height: 16),
                    SmallRoundedOutlinedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Submit',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
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
