import 'package:flutter/material.dart';

import '../../../components/custom_text_field.dart';
import '../../../components/rounded_outlined_button.dart';

class Limit {
  final double value;
  final String option;
  final String? groupName;
  bool isActive;

  Limit({
    required this.value,
    required this.option,
    required this.isActive,
    this.groupName,
  });

  bool get isGroupLimit => groupName != null;
}

class AddNotificationSheet extends StatefulWidget {
  const AddNotificationSheet({
    super.key,
  });

  @override
  State<AddNotificationSheet> createState() => _AddNotificationSheetState();
}

class _AddNotificationSheetState extends State<AddNotificationSheet> {
  final _value = TextEditingController();
  final _option = TextEditingController();
  final _group = TextEditingController();

  @override
  void dispose() {
    _value.dispose();
    _option.dispose();
    _group.dispose();
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
                      labelText: 'Value',
                    ),
                    CustomTextField(
                      controller: _option,
                      hintText: 'e.g. Yearly',
                      labelText: 'Option',
                    ),
                    CustomTextField(
                      controller: _group,
                      hintText: 'e.g. Friends',
                      labelText: 'Group (optional)',
                    ),
                    const SizedBox(height: 16),
                    RoundedOutlinedButton(
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
