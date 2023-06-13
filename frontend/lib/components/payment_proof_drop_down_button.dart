import 'package:flutter/material.dart';

import '../utils/api/models/payment_proof.dart';

class PaymentProofDropDownButton extends StatefulWidget {
  final PaymentProof? selected;
  final List<PaymentProof> proofs;
  final Function(PaymentProof selected) onSelected;

  const PaymentProofDropDownButton({
    super.key,
    this.selected,
    required this.proofs,
    required this.onSelected,
  });

  @override
  State<PaymentProofDropDownButton> createState() =>
      _PaymentProofDropDownButtonState();
}

class _PaymentProofDropDownButtonState
    extends State<PaymentProofDropDownButton> {
  late List<PaymentProof> options;
  late PaymentProof selectedProof;

  @override
  void initState() {
    super.initState();
    final noProof = PaymentProof(
      id: null,
      name: 'No proof',
      fileName: 'none',
      url: 'none',
      payments: [],
    );
    options = [noProof, ...widget.proofs];

    if (widget.selected != null) {
      selectedProof = options.firstWhere(
        (proof) => proof.id == widget.selected!.id,
      );
    } else {
      selectedProof = noProof;
    }
    widget.onSelected(selectedProof);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<PaymentProof>(
            itemHeight: 60,
            value: selectedProof,
            items: options
                .map((proof) => DropdownMenuItem(
                      value: proof,
                      child: Text(proof.name),
                    ))
                .toList(),
            onChanged: (selected) {
              setState(() => selectedProof = selected!);
              widget.onSelected(selectedProof);
            },
            borderRadius: BorderRadius.circular(15.0),
            isExpanded: true,
            underline: Container(),
            style: Theme.of(context).textTheme.bodySmall,
            dropdownColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
