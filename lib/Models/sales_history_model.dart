// sale_record_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class SaleRecord {
  String customerName;
  String phoneNumber;
  String email;
  String chasisNumber;
  String registrationNumber;
  String carName;
  String make;
  String model;
  double costPrice;
  double sellingPrice;
  double profit;
  int selectedInstallments;
  double downPayment;
  double paymentRemaining;
  double installmentAmount;
  Timestamp submitDate;
  Timestamp dueDate;
  String status;
  int daysRemaining;

  // Constructor
  SaleRecord({
    required this.customerName,
    required this.phoneNumber,
    required this.email,
    required this.chasisNumber,
    required this.registrationNumber,
    required this.carName,
    required this.make,
    required this.model,
    required this.costPrice,
    required this.sellingPrice,
    required this.profit,
    required this.selectedInstallments,
    required this.downPayment,
    required this.paymentRemaining,
    required this.installmentAmount,
    required this.submitDate,
    required this.dueDate,
    required this.status,
    required this.daysRemaining,
  });

  // Factory method to create a SaleRecord from a Firestore document
  factory SaleRecord.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data() ?? {};
    return SaleRecord(
      customerName: data['customerName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      email: data['email'] ?? '',
      chasisNumber: data['chasisNumber'] ?? '',
      registrationNumber: data['registrationNumber'] ?? '',
      carName: data['carName'] ?? '',
      make: data['make'] ?? '',
      model: data['model'] ?? '',
      costPrice: (data['costPrice'] ?? 0).toDouble(),
      sellingPrice: (data['sellingPrice'] ?? 0).toDouble(),
      profit: (data['profit'] ?? 0).toDouble(),
      selectedInstallments: data['selectedInstallments'] ?? 0,
      downPayment: (data['downPayment'] ?? 0).toDouble(),
      paymentRemaining: (data['paymentRemaining'] ?? 0).toDouble(),
      installmentAmount: (data['installmentAmount'] ?? 0).toDouble(),
      submitDate: data['submitDate'] ?? Timestamp.now(),
      dueDate: data['dueDate'] ?? Timestamp.now(),
      status: data['status'] ?? '',
      daysRemaining: data['daysRemaining'] ?? 0,
    );
  }

  // Convert SaleRecord instance to JSON for storing in Firestore
  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'email': email,
      'chasisNumber': chasisNumber,
      'registrationNumber': registrationNumber,
      'carName': carName,
      'make': make,
      'model': model,
      'costPrice': costPrice,
      'sellingPrice': sellingPrice,
      'profit': profit,
      'selectedInstallments': selectedInstallments,
      'downPayment': downPayment,
      'paymentRemaining': paymentRemaining,
      'installmentAmount': installmentAmount,
      'submitDate': submitDate,
      'dueDate': dueDate,
      'status': status,
      'daysRemaining': daysRemaining,
    };
  }
}
