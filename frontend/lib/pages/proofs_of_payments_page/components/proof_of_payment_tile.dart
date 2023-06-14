import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../providers/payment_proof_provider.dart';
import '../../../utils/api/models/payment_proof.dart';
import '../../../utils/snackbars.dart';

class PaymentProofTile extends StatefulWidget {
  final PaymentProof proof;

  const PaymentProofTile({
    super.key,
    required this.proof,
  });

  @override
  State<PaymentProofTile> createState() => _PaymentProofTileState();
}

class _PaymentProofTileState extends State<PaymentProofTile> {
  Future<void> _downloadFile() async {
    await launchUrl(Uri.parse(widget.proof.url),
        mode: LaunchMode.externalApplication);
  }

  Future<void> deletePaymentProof(BuildContext context, int id) async {
    try {
      await Provider.of<PaymentProofProvider>(context, listen: false)
          .deletePaymentProof(id);
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        collapsedTextColor: Theme.of(context).textTheme.bodyMedium!.color,
        textColor: Theme.of(context).textTheme.bodyMedium!.color,
        iconColor: Theme.of(context).textTheme.bodyMedium!.color,
        leading: const Icon(
          Icons.file_present_rounded,
          color: Colors.redAccent,
        ),
        title: Text(
          widget.proof.name,
          overflow: TextOverflow.ellipsis,
        ),
        childrenPadding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Connected payments: ${widget.proof.payments.length}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    maxRadius: 18,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                    child: IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          title: Text(
                            'Are you sure you want to delete the "${widget.proof.name}"?',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async => await deletePaymentProof(
                                context,
                                widget.proof.id!,
                              ),
                              child: Text(
                                'Yes',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'No',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            )
                          ],
                        ),
                      ),
                      icon: const Icon(Icons.delete),
                      iconSize: 19,
                      color: Colors.white,
                      splashColor: Theme.of(context).colorScheme.tertiary,
                      splashRadius: 25,
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    maxRadius: 18,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                    child: IconButton(
                      onPressed: () async => await _downloadFile(),
                      icon: const Icon(Icons.remove_red_eye),
                      iconSize: 19,
                      color: Colors.white,
                      splashColor: Theme.of(context).colorScheme.tertiary,
                      splashRadius: 25,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
