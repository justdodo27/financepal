import 'package:flutter/material.dart';

import '../utils/api/models/payment_proof.dart';
import 'auth_provider.dart';

class PaymentProofProvider extends ChangeNotifier {
  final Auth? auth;

  PaymentProofProvider(this.auth);

  /// List of payment proofs.
  List<PaymentProof>? _paymentProofs;

  List<PaymentProof>? get paymentProofs => _paymentProofs;

  /// Fetches the proofs of payments from the backend API.
  Future<void> fetchProofsOfPayments() async {
    if (auth == null) return;
    final token = auth!.token;
    if (token == null) return;
    try {
      _paymentProofs = await auth!.apiService.getPaymentProofs(token);
    } catch (_) {
      throw Exception('Failed to load proofs of payments.');
    }
    notifyListeners();
  }

  /// Creates a new proof of payment.
  Future<void> createPaymentProof(
      {required String name, required String path}) async {
    if (auth == null) return;
    final token = auth!.token;
    if (token == null) return;
    try {
      final created = await auth!.apiService
          .createPaymentProof(token, proofName: name, filePath: path);
      _paymentProofs?.add(created);
    } catch (_) {
      throw Exception('Failed to add the proof of payment.');
    }
    notifyListeners();
  }

  /// Deletes a proof of payment.
  Future<void> deletePaymentProof(int id) async {
    if (auth == null) return;
    final token = auth!.token;
    if (token == null) return;
    try {
      await auth!.apiService.deletePaymentProof(token, id);
      _paymentProofs?.removeWhere((element) => element.id == id);
    } catch (_) {
      throw Exception('Failed to delete the proof of payment.');
    }
    notifyListeners();
  }

  Future<void> reloadProofsOfPayments() async {
    await fetchProofsOfPayments();
  }
}
