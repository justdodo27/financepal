import 'package:flutter/material.dart';
import 'package:frontend/components/frequency_dropdown_button.dart';
import 'package:frontend/providers/limit_provider.dart';
import 'package:frontend/utils/api/models/limit.dart';
import 'package:frontend/utils/snackbars.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_text_field.dart';
import '../../../components/rounded_outlined_button.dart';

class AddNotificationSheet extends StatefulWidget {
  const AddNotificationSheet({
    super.key,
  });

  @override
  State<AddNotificationSheet> createState() => _AddNotificationSheetState();
}

class _AddNotificationSheetState extends State<AddNotificationSheet> {
  final _value = TextEditingController();

  String? _period;

  @override
  void dispose() {
    _value.dispose();
    super.dispose();
  }

  Future<void> addNotification() async {
    final provider = Provider.of<LimitProvider>(context, listen: false);
    final toCreate = Limit(
      amount: double.parse(_value.text),
      period: _period!.toUpperCase(),
      isActive: true,
    );

    try {
      await provider.addLimit(toCreate);
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }

    if (!mounted) return;
    Navigator.of(context).pop();
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
              'Add a notification',
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
                      controller: _value,
                      hintText: 'e.g. 1000',
                      labelText: 'Amount',
                    ),
                    FrequencyDropDownButton(
                      frequencies: const [
                        'Daily',
                        'Weekly',
                        'Monthly',
                      ],
                      onSelected: (selected) => _period = selected,
                    ),
                    const SizedBox(height: 16),
                    RoundedOutlinedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      onPressed: addNotification,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Consumer<LimitProvider>(
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
