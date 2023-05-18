import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../proofs_of_payments_page.dart';

class PaymentProofTile extends StatelessWidget {
  final PaymentProof proof;

  const PaymentProofTile({
    super.key,
    required this.proof,
  });

  void _downloadFile() async {
    await launchUrl(Uri.parse(proof.url), mode: LaunchMode.externalApplication);
  }

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  const Icon(
                    Icons.file_present_rounded,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Text(
                      proof.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _downloadFile,
              icon: const Icon(Icons.remove_red_eye),
            )
          ],
        ),
      ),
    );
  }
}
