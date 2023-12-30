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
  Timestamp submitDate; // Assume timestamp from Firestore
  Timestamp dueDate;    // Assume timestamp from Firestore
  String status;
  int daysRemaining;

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
      'daysRemaining': daysRemaining
    };
  }

  factory SaleRecord.fromJson(Map<String, dynamic> json) {
    return SaleRecord(
      customerName: json['customerName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      chasisNumber: json['chasisNumber'],
      registrationNumber: json['registrationNumber'],
      carName: json['carName'],
      make: json['make'],
      model: json['model'],
      costPrice: json['costPrice'],
      sellingPrice: json['sellingPrice'],
      profit: json['profit'],
      selectedInstallments: json['selectedInstallments'],
      downPayment: json['downPayment'],
      paymentRemaining: json['paymentRemaining'],
      installmentAmount: json['installmentAmount'],
      submitDate: json['submitDate'],
      dueDate: json['dueDate'],
      status: json['status'],
      daysRemaining: json['daysRemaining'],

    );
  }
}
