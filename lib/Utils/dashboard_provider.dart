import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:creditrack/Controllers/dashboard_controller.dart';  

final firestoreHelperProvider = Provider<FirestoreHelper>((ref) {
  return FirestoreHelper();
});

final totalCarSoldProvider = FutureProvider<int>((ref) {
  final firestoreHelper = ref.watch(firestoreHelperProvider);
  return firestoreHelper.getTotalCarSold();
});

final paymentRemainingSumProvider = FutureProvider<num>((ref) {
  final firestoreHelper = ref.watch(firestoreHelperProvider);
  return firestoreHelper.getPaymentRemainingSum();
});

final totalProfitProvider = FutureProvider<num>((ref) {
  final firestoreHelper = ref.watch(firestoreHelperProvider);
  return firestoreHelper.getTotalProfit();
});

final statusSumProvider = FutureProvider<List<double>>((ref) {
  final firestoreHelper = ref.watch(firestoreHelperProvider);
  return firestoreHelper.getStatusSum();
});

final dayAndDownPaymentDataProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  final firestoreHelper = ref.watch(firestoreHelperProvider);
  return firestoreHelper.getDayAnddownPaymentData();
});

final revenueListProvider = FutureProvider<List<num>>((ref) {
  final firestoreHelper = ref.watch(firestoreHelperProvider);
  return firestoreHelper.getRevenueList();
});

final next5monthsprovider = FutureProvider<List<String>>((ref) {
  final firestoreHelper = ref.watch(firestoreHelperProvider);
  return firestoreHelper.getNext5Months();
});
