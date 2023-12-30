import 'package:creditrack/Controllers/add_sale_controller.dart';
import 'package:creditrack/Views/dashboard_screen.dart';
import 'package:creditrack/Views/login_screen.dart';
import 'package:creditrack/Views/sales_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Models/add_sale_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Utils/reuseable_widgets.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AddSale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tadashii Motors',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: AddRecordScreen(),
    );
  }
}

class AddRecordScreen extends StatefulWidget {
  @override
  _AddRecordScreenState createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  TextEditingController soldAtController = TextEditingController();
  TextEditingController downPaymentController = TextEditingController();
  TextEditingController costPriceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController profitController = TextEditingController();
  TextEditingController RemainingController = TextEditingController();
  TextEditingController InstallmentAmountController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController chasisNumberController = TextEditingController();
  TextEditingController registrationNumberController = TextEditingController();
  TextEditingController carNameController = TextEditingController();
  TextEditingController makeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  int selectedInstallments = 6; // Default value
  DateTime? currentDate; // Variable to store the current date

  AddSaleController saleFormController = AddSaleController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Tadashi Motors'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/logout.png',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              // Implement the logout functionality here
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.lightBlue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildStyledContainer(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader('Customer Detail'),
                    SizedBox(height: 5.0),
                    buildTextInput('Customer Name', 'Example: Nawfal',
                        maxLength: 30, controller: customerNameController),
                    SizedBox(height: 10.0),
                    buildTextInput('Phone Number', 'Enter your phone number',
                        controller: phoneNumberController,
                        maxLength: 11,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ]),
                    SizedBox(height: 10.0),
                    buildTextInput('Email', 'Enter your email',
                        controller: emailController,
                        maxLength: 50,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                          .hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    }),
                  ],
                ),
              ),
              buildStyledContainer(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader('Car Detail'),
                    SizedBox(height: 10.0),
                    buildTextInput('Chasis#', 'Enter Chasis#',
                        maxLength: 17, controller: chasisNumberController),
                    SizedBox(height: 10.0),
                    buildTextInput(
                        'Registration#', 'Enter Registration# (e.g., ABC-345)',
                        controller: registrationNumberController),
                    SizedBox(height: 10.0),
                    buildTextInput('Car Name', 'Enter Car Name',
                        controller: carNameController),
                    SizedBox(height: 10.0),
                    buildTextInput('Make', 'Enter Make',
                        controller: makeController),
                    SizedBox(height: 10.0),
                    buildTextInput('Model', 'Enter Model',
                        controller: modelController,
                        maxLength: 30,
                        keyboardType: TextInputType.number),
                  ],
                ),
              ),
              buildStyledContainer(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader('Accounts'),
                    SizedBox(height: 10.0),
                    buildNumericInput(
                      'COST PRICE',
                      'Enter cost price',
                      controller: costPriceController,
                      onChanged: (value) {
                        updateProfit();
                      },
                    ),
                    SizedBox(height: 10.0),
                    buildNumericInput(
                      'SELLING PRICE',
                      'Enter selling price',
                      controller: sellingPriceController,
                      onChanged: (value) {
                        updateProfit();
                      },
                    ),
                    SizedBox(height: 10.0),
                    buildNumericInput(
                      'PROFIT',
                      'Profit Generated',
                      controller: profitController,
                      onChanged: (value) {
                        updateProfit();
                      },
                    ),
                    SizedBox(height: 10.0),
                    // Replace the existing buildNumericInput with NumberSelectionWidget
                    NumberSelectionWidget(
                      labelText: 'Installments',
                      hintText: 'Select Installments',
                      selectedNumber: selectedInstallments,
                      onChanged: (int? value) {
                        calculateInstallments();

                        setState(() {
                          selectedInstallments = value ?? 6;
                        });
                      },
                    ),
                    SizedBox(height: 10.0),
                    buildNumericInput(
                      'DOWN PAYMENT',
                      'enter the amount that the customer paid',
                      controller: downPaymentController,
                      onChanged: (value) {
                        updateRemaining();
                        calculateInstallments();
                      },
                    ),
                    SizedBox(height: 10.0),
                    buildNumericInput(
                      'Payment Remaining',
                      '',
                      controller: RemainingController,
                      onChanged: (value) {
                        updateRemaining();
                      },
                    ),
                    SizedBox(height: 10.0),

                    buildNumericInput(
                      'DUE',
                      'Installments due per month',
                      controller: InstallmentAmountController,
                      onChanged: (value) {
                        calculateInstallments();
                      },
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
              buildStyledContainer(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
        // Call the submitForm method from the controller
        saleFormController.submitForm(
            context: context,
            customerNameController: customerNameController,
            phoneNumberController: phoneNumberController,
            emailController: emailController,
            chasisNumberController: chasisNumberController,
            registrationNumberController: registrationNumberController,
            carNameController: carNameController,
            makeController: makeController,
            modelController: modelController,
            costPriceController: costPriceController,
            sellingPriceController: sellingPriceController,
            profitController: profitController,
            downPaymentController: downPaymentController,
            remainingController: RemainingController,
            installmentAmountController: InstallmentAmountController,
            selectedInstallments: selectedInstallments,
        );
      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(
                            255, 255, 217, 0), // Set the button color to golden
                      ),
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  void updateProfit() {
    double costPrice = double.tryParse(costPriceController.text) ?? 0;
    double sellingPrice = double.tryParse(sellingPriceController.text) ?? 0;
    double profit = sellingPrice - costPrice;
    profitController.text = profit.toString();
  }

  void updateRemaining() {
    double soldAt = double.tryParse(sellingPriceController.text) ?? 0;
    double downPayment = double.tryParse(downPaymentController.text) ?? 0;
    double paymentRemaining = soldAt - downPayment;
    RemainingController.text = paymentRemaining.toString();
  }

  void calculateInstallments() {
    print("calculateInstallments called"); // Add this line for debugging
    double paymentRemaining = double.tryParse(RemainingController.text) ?? 0;
    int installments = selectedInstallments;
    double installmentsDue = paymentRemaining / installments;
    int roundedInstallmentsDue = installmentsDue.ceil();
    InstallmentAmountController.text = roundedInstallmentsDue.toString();
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform logout actions here (e.g., clear session, navigate to login screen)
                // For demonstration purposes, let's assume you have a function named logout()
                logout();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}