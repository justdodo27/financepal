import 'package:flutter/material.dart';
import 'package:frontend/pages/proofs_of_payments_page/components/add_payment_proof_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentProof {
  final String name;
  final String url;

  PaymentProof({required this.name, required this.url});
}

class ProofsOfPaymentsPage extends StatelessWidget {
  const ProofsOfPaymentsPage({super.key});

  static List<PaymentProof> data = [
    PaymentProof(
        name: 'Receipt Biedronka 22/03/2023',
        url:
            'https://d-art.ppstatic.pl/kadry/k/r/1/3b/18/61712ef03f711_o_full.jpg'),
    PaymentProof(
        name: 'Receipt Auchan 21/03/2023',
        url:
            'https://twojepajeczno.pl/wp-content/uploads/2015/10/Paragon_czyt.png'),
    PaymentProof(
        name: 'Receipt Lidl asd asdaddasd asdasdasd 20/03/2023',
        url:
            'https://pomoc.ipos.pl/hc/article_attachments/4405692742290/FISCAL.TRANSACTION-NIP-nabywcy.txt__1_.png'),
  ];

  List<Widget> _getRows() {
    return data.map((proof) => PaymentProofTile(proof: proof)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 4,
              color: Theme.of(context).colorScheme.onPrimary,
              child: Column(
                children: _getRows(),
              ),
            ),
            const SizedBox(height: 220),
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

class PaymentProofTile extends StatelessWidget {
  final PaymentProof proof;

  const PaymentProofTile({
    super.key,
    required this.proof,
  });

  void _downloadFile() async {
    await launchUrl(Uri.parse(proof.url), mode: LaunchMode.platformDefault);
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
