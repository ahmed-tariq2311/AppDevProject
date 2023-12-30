import 'package:creditrack/Models/add_sale_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddSaleController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    int selectedInstallments = 6;


  void submitForm({
    required BuildContext context,
    required TextEditingController customerNameController,
    required TextEditingController phoneNumberController,
    required TextEditingController emailController,
    required TextEditingController chasisNumberController,
    required TextEditingController registrationNumberController,
    required TextEditingController carNameController,
    required TextEditingController makeController,
    required TextEditingController modelController,
    required TextEditingController costPriceController,
    required TextEditingController sellingPriceController,
    required TextEditingController profitController,
    required TextEditingController downPaymentController,
    required TextEditingController remainingController,
    required TextEditingController installmentAmountController,
    required int selectedInstallments,
  }) {
    // Check if any field is empty
    if (_areFieldsEmpty([
      customerNameController,
      phoneNumberController,
      emailController,
      chasisNumberController,
      registrationNumberController,
      carNameController,
      makeController,
      modelController,
      costPriceController,
      sellingPriceController,
      profitController,
      downPaymentController,
      remainingController,
      installmentAmountController,
    ])) {
      _showErrorDialog(context, 'Please fill in all fields.');
      return;
    }

    // Capture the current date before storing in Firebase
    DateTime currentDate = DateTime.now();

    // Calculate due date (one month after the current date)
    Timestamp dueDate = currentDate != null
        ? Timestamp.fromDate(currentDate.add(Duration(days: 30)))
        : Timestamp.now();

    // Create a SaleRecord instance
    SaleRecord saleRecord = SaleRecord(
      customerName: customerNameController.text,
      phoneNumber: phoneNumberController.text,
      email: emailController.text,
      chasisNumber: chasisNumberController.text,
      registrationNumber: registrationNumberController.text,
      carName: carNameController.text,
      make: makeController.text,
      model: modelController.text,
      costPrice: double.tryParse(costPriceController.text) ?? 0,
      sellingPrice: double.tryParse(sellingPriceController.text) ?? 0,
      profit: double.tryParse(profitController.text) ?? 0,
      selectedInstallments: selectedInstallments,
      downPayment: double.tryParse(downPaymentController.text) ?? 0,
      paymentRemaining: double.tryParse(remainingController.text) ?? 0,
      installmentAmount:
          double.tryParse(installmentAmountController.text) ?? 0,
      submitDate: Timestamp.fromDate(currentDate), // Convert DateTime to Timestamp
      dueDate: dueDate, // Convert DateTime to Timestamp
      status: "PAID",
      daysRemaining: 30, // Set the "status" to "PAID"
    );

    // Convert SaleRecord instance to JSON
    Map<String, dynamic> jsonData = saleRecord.toJson();

    // Push the data to Firebase under 'sales' node
    _firestore.collection('sales').add(jsonData).then((value) {
      // Show a success pop-up
      _showSuccessDialog(context, 'Record Successfully Added');

      // Reset the form
      resetForm([
        customerNameController,
        phoneNumberController,
        emailController,
        chasisNumberController,
        registrationNumberController,
        carNameController,
        makeController,
        modelController,
        costPriceController,
        sellingPriceController,
        profitController,
        downPaymentController,
        remainingController,
        installmentAmountController,
      ]);

      print('Form submitted on: $currentDate');
    }).catchError((error) {
      print('Error submitting form: $error');
    });
  }

      bool _areFieldsEmpty(List<TextEditingController> controllers) {
    // Check if any of the text controllers are empty
    return controllers.any((controller) => controller.text.isEmpty);
  }
  // ... (rest of the class remains unchanged)

   void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

   void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Set the size to minimum
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0), // Adjust padding as needed
                child: Image.asset(
                  'assets/success.png',
                  width: 100,
                  height: 100,
                ),
              ),
              Text(message),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void resetForm(List<TextEditingController> controllers) {
    // Clear all text controllers and reset other state variables
    controllers.forEach((controller) => controller.clear());
    // Set default values for other state variables if needed
    selectedInstallments = 6;
  }

}
