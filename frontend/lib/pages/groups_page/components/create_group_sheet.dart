import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_text_field.dart';
import '../../../components/rounded_outlined_button.dart';
import '../../../providers/group_provider.dart';
import '../../../utils/snackbars.dart';

class CreateGroupSheet extends StatefulWidget {
  const CreateGroupSheet({
    super.key,
  });

  @override
  State<CreateGroupSheet> createState() => _CreateGroupSheetState();
}

class _CreateGroupSheetState extends State<CreateGroupSheet> {
  final _name = TextEditingController();

  Future<void> createGroup() async {
    final name = _name.text;
    if (name.isEmpty) return;

    final provider = Provider.of<GroupProvider>(context, listen: false);
    try {
      await provider.createGroup(name);
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _name.dispose();
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
              'Create a new group',
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
                      hintText: 'e.g. Power Rangers',
                      labelText: 'Name',
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
                      onPressed: () async => await createGroup(),
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
