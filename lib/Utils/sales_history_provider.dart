import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:creditrack/Controllers/sales_history_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creditrack/Models/sales_history_model.dart';


final salesHistoryControllerProvider = Provider<SalesHistoryController>((ref) {
  return SalesHistoryController();
});
// Provider for the sales stream
final salesStreamProvider = StreamProvider.autoDispose<QuerySnapshot<Map<String, dynamic>>>((ref) {
  final SalesHistoryController _salesController = SalesHistoryController();
  return _salesController.getSalesStream();
});

// Provider for the search text controller
final searchControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});

// Provider for the filtered sales records
final filteredSalesProvider = Provider.autoDispose<List<SaleRecord>>((ref) {
  final searchText = ref.watch(searchControllerProvider).text.toLowerCase();
  final salesQuerySnapshot = ref.watch(salesStreamProvider).asData?.value;

  if (salesQuerySnapshot == null) return [];

  final salesList = salesQuerySnapshot.docs.map((doc) => SaleRecord.fromFirestore(doc)).toList();
  return salesList.where((sale) => sale.carName.toLowerCase().contains(searchText) || sale.customerName.toLowerCase().contains(searchText)).toList();
});

final updateInstallmentsProvider = Provider((ref) {
  // Get your SalesHistoryController from somewhere, maybe another provider
  final controller = ref.watch(salesHistoryControllerProvider);
  
  return (String documentId, int selectedInstallments, Timestamp dueDate) async {
    await controller.updateInstallments(documentId, selectedInstallments, dueDate);
  };
});

