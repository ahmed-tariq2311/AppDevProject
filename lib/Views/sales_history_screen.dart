import 'package:creditrack/Views/add_sale_screen.dart';
import 'package:creditrack/Views/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'login_screen.dart';
import 'package:creditrack/Models/sales_history_model.dart';

class SalesHistoryScreen extends StatefulWidget {
  @override
  _SalesHistoryScreenState createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _salesStream;
  TextEditingController _searchController = TextEditingController();

  String formatTimestamp(Timestamp timestamp) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp.toDate());
  }

 @override
  void initState() {
    super.initState();
    _salesStream = FirebaseFirestore.instance
        .collection('sales')
        .snapshots(); // Remove the .map() part
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SALES HISTORY'),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.notifications,
              color: Color.fromARGB(255, 204, 201, 9),
            ),
            iconSize: 30.0,
            onPressed: () {},
          ),
        ),
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
              // Search Bar
              buildSearchBar(),

              // Display the sales history content
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _salesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No sales records available.'),
                    );
                  }

                  // Use the map() method to convert QueryDocumentSnapshot to SaleRecord
                  List<SaleRecord> salesList = snapshot.data!.docs
                      .map((doc) => SaleRecord.fromFirestore(doc))
                      .toList();

                  // Filtered list of sales records
                  List<SaleRecord> filteredSales = salesList
                      .where((saleData) => _isSearchMatch(saleData.toJson()))
                      .toList();

                  // Display the list of sales records or a no records message
                  if (filteredSales.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/noRecord.png',
                            width: 150,
                            height: 150,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'No Record found',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredSales.length,
                      itemBuilder: (context, index) {
                        var saleData = filteredSales[index];
                        var documentId = snapshot.data!.docs[index].id;
                        return _buildSaleRecordItem(saleData, documentId);
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/dashboard.png',
              width: 24,
              height: 24,
              color: null,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/add.png',
              width: 24,
              height: 24,
              color: null,
            ),
            label: 'Add Record',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/folder.png',
              width: 24,
              height: 24,
              color: null,
            ),
            label: 'Sales History',
          ),
        ],
        currentIndex: 2,
        onTap: (index) {
          // Handle navigation here
          if (index == 0) {
            // Navigate to Home (you can replace 'DashboardScreen' with the actual name of your dashboard screen)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen()),
            );
          } else if (index == 2) {
            // Stay on Add Record screen
          } else if (index == 1) {
            // Navigate to Sales History (you can replace 'SalesHistoryScreen' with the actual name of your sales history screen)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AddSale()),
            );
          }
        },
      ),
    );
  }

  void _showConfirmationDialog(
      String documentId, int selectedInstallments, Timestamp dueDate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _updateInstallments(documentId, selectedInstallments, dueDate);
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void _updateInstallments(
      String documentId, int selectedInstallments, Timestamp dueDate) async {
    // Update Firestore document with new values
    int updatedInstallments = selectedInstallments - 1;
    DateTime newDueDate = dueDate
        .toDate()
        .add(Duration(days: 30)); // Add 30 days to the current dueDate

    await FirebaseFirestore.instance
        .collection('sales')
        .doc(documentId)
        .update({
      'selectedInstallments': updatedInstallments,
      'dueDate': Timestamp.fromDate(newDueDate),
    });
  }

  void _showBottomSheet(SaleRecord saleData, String documentId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true for full-height modal
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: IntrinsicHeight(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row for the first image (user.png) and user-related data
                  Row(
                    children: [
                      // User image
                      Image.asset(
                        'assets/user.png',
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(width: 20),
                      // User-related data
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Customer Name: ${saleData.carName}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Phone Number: ${saleData.phoneNumber}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Email: ${saleData.email}",
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Row for the second image (accounting.png) and other data
                  Row(
                    children: [
                      // Accounting image
                      Image.asset(
                        'assets/accounting.png',
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(width: 16),
                      // Other data
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Car Name: ${saleData.carName}"),
                          Text(
                              "Installment Amount: ${saleData.installmentAmount}"),
                          Text(
                              "Payment Remaining: ${saleData.paymentRemaining}"),
                          Text(
                              "Selected Installments: ${saleData.selectedInstallments}"),
                          Text("Profit: ${saleData.profit}"),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Row for buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // First button
                      MaterialButton(
                        minWidth: 150,
                        height: 60,
                        onPressed: () {
                          _showDeleteConfirmationDialog(documentId);
                          _buildSaleRecordItem(
                              saleData, documentId);
                        },
                        color: Colors.redAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          "DELETE",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),

                      // Second button
                      MaterialButton(
                        minWidth: 150,
                        height: 60,
                        onPressed: () {
                          _showConfirmationDialog(
                            documentId,
                            saleData.selectedInstallments,
                            saleData.dueDate,
                          );
                          _buildSaleRecordItem(
                              saleData as SaleRecord, documentId);
                        },
                        color: Colors.greenAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          "UPDATE INSTALLMENTS",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to delete?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Add your logic for deleting the document
                _deleteDocument(documentId);
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void _deleteDocument(String documentId) {
    // Add your logic to delete the document from Firestore
    FirebaseFirestore.instance.collection('sales').doc(documentId).delete();
    // You may want to add error handling here
  }

  Widget _buildSaleRecordItem(SaleRecord saleData, String documentId) {
    // Parse the dueDate from the saleData
    Timestamp dueDate = saleData.dueDate;
    // Convert Timestamp objects to DateTime objects
    DateTime currentDate = DateTime.now();
    DateTime dueDateTime = dueDate.toDate(); // Convert Timestamp to DateTime

    // Calculate the difference in days
    int daysRemaining = dueDateTime.difference(currentDate).inDays;

    String status;
    if (daysRemaining > 5) {
      status = "PAID";
    } else if (daysRemaining > 0) {
      status = "UPCOMING";
    } else {
      status = "DUE";
    }

    // Update the 'status' field of the document in Firestore
    FirebaseFirestore.instance
        .collection('sales')
        .doc(documentId)
        .update({'status': status});

    // Determine the color based on the status
    Color statusColor;
    switch (status) {
      case "PAID":
        statusColor = Colors.lightGreen;
        break;
      case "UPCOMING":
        statusColor = Colors.blue; // Change this to sky blue if needed
        break;
      case "DUE":
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.lightGreen;
    }

    return InkWell(
      onTap: () {
        _showBottomSheet( saleData, documentId);
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Status (in a round box with dynamic color)
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor,
              ),
              child: Center(
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.0),

            // 2. Content (Car Name and Installment Amount)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 3. Car Name
                  Text(
                    "Car Name: ${saleData.carName}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),

                  // 4. Installment Amount
                  Text(
                    "Installment Amount: ${saleData.installmentAmount}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),

                  // 5. Remaining Installments
                  Text(
                    "Remaining Installments: ${saleData.selectedInstallments}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),

                  // 6. Days Remaining
                  Text(
                    "Days Remaining: $daysRemaining",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        onChanged: (query) {
          setState(() {
            // Update the search query when the text changes
            // This will trigger the StreamBuilder to update with filtered data
            // based on the search query
          });
        },
        decoration: InputDecoration(
          hintText: 'Enter customer name and car name..',
          prefixIcon: Icon(Icons.search), // Add the search icon
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
    );
  }

  bool _isSearchMatch(Map<String, dynamic> saleData) {
    // Get the search query from the controller
    String query = _searchController.text.toLowerCase();

    // Check if customerName or carName contains the search query
    return saleData['customerName'].toLowerCase().contains(query) ||
        saleData['carName'].toLowerCase().contains(query);
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
