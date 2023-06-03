import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/payment_proof_provider.dart';
import 'package:frontend/utils/snackbars.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_text_field.dart';
import '../../../components/rounded_outlined_button.dart';

class AddPaymentProofSheet extends StatefulWidget {
  const AddPaymentProofSheet({
    super.key,
  });

  @override
  State<AddPaymentProofSheet> createState() => _AddPaymentProofSheetState();
}

class _AddPaymentProofSheetState extends State<AddPaymentProofSheet> {
  final _name = TextEditingController();

  Future<FilePickerResult?>? _futureFile;

  late PaymentProofProvider _paymentProofProvider;

  @override
  void initState() {
    super.initState();
    _paymentProofProvider = Provider.of<PaymentProofProvider>(
      context,
      listen: false,
    );
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _pickFile() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png'],
    );

    if (picked == null && mounted) {
      showExceptionSnackBar(context, Exception('No file selected.'));
    }

    _futureFile = Future.value(picked);
    setState(() {});
  }

  Future<void> createProofOfPayment() async {
    final result = await _futureFile;
    if (result == null && mounted) {
      showExceptionSnackBar(context, Exception('No file selected.'));
      return;
    }

    final path = result!.files.single.path!;
    try {
      await _paymentProofProvider.createPaymentProof(
        name: _name.text,
        path: path,
      );
    } on Exception catch (e) {
      if (!mounted) return;
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
              'Add the proof payment',
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
                      hintText: 'e.g. Receipt Biedronka 22/03/2023',
                      labelText: 'Name',
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<FilePickerResult?>(
                      future: _futureFile,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!.files.single.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                          );
                        } else if (snapshot.hasError) {
                          showExceptionSnackBar(
                            context,
                            Exception(
                              'Error while picking file: ${snapshot.error}',
                            ),
                          );
                        }
                        return RoundedOutlinedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          backgroundColor:
                              Theme.of(context).colorScheme.onSecondary,
                          onPressed: _pickFile,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Upload file',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        );
                      },
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
                      onPressed: () async => await createProofOfPayment(),
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
