import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creditrack/Models/sales_history_model.dart';
import 'package:flutter/material.dart';

class SalesHistoryController {
  final CollectionReference<Map<String, dynamic>> _salesCollection =
      FirebaseFirestore.instance.collection('sales');

  Stream<QuerySnapshot<Map<String, dynamic>>> getSalesStream() {
    return _salesCollection.snapshots();
  }

  Future<void> updateInstallments(
      String documentId, int selectedInstallments, Timestamp dueDate) async {
    int updatedInstallments = selectedInstallments - 1;
    DateTime newDueDate = dueDate.toDate().add(Duration(days: 30));

    await _salesCollection.doc(documentId).update({
      'selectedInstallments': updatedInstallments,
      'dueDate': Timestamp.fromDate(newDueDate),
    });
  }

  Future<void> deleteDocument(String documentId) async {
    await _salesCollection.doc(documentId).delete();
  }

   Future<void> confirmationDialog(BuildContext context, String documentId) async {
    await showDialog(
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
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // Add your logic for deleting the document
                await _salesCollection.doc(documentId).delete();
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
}

//  Widget _buildSaleRecordItem(SaleRecord saleData, String documentId) {
//     // Parse the dueDate from the saleData
//     Timestamp dueDate = saleData.dueDate;
//     // Convert Timestamp objects to DateTime objects
//     DateTime currentDate = DateTime.now();
//     DateTime dueDateTime = dueDate.toDate(); // Convert Timestamp to DateTime

//     // Calculate the difference in days
//     int daysRemaining = dueDateTime.difference(currentDate).inDays;

//     String status;
//     if (daysRemaining > 5) {
//       status = "PAID";
//     } else if (daysRemaining > 0) {
//       status = "UPCOMING";
//     } else {
//       status = "DUE";
//     }

//     // Update the 'status' field of the document in Firestore
//     FirebaseFirestore.instance
//         .collection('sales')
//         .doc(documentId)
//         .update({'status': status});

//     // Determine the color based on the status
//     Color statusColor;
//     switch (status) {
//       case "PAID":
//         statusColor = Colors.lightGreen;
//         break;
//       case "UPCOMING":
//         statusColor = Colors.blue; // Change this to sky blue if needed
//         break;
//       case "DUE":
//         statusColor = Colors.red;
//         break;
//       default:
//         statusColor = Colors.lightGreen;
//     }

//     return InkWell(
//       onTap: () {
//         _showBottomSheet( saleData, documentId);
//       },
//       child: Container(
//         margin: EdgeInsets.all(10.0),
//         padding: EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10.0),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 1. Status (in a round box with dynamic color)
//             Container(
//               width: 50.0,
//               height: 50.0,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: statusColor,
//               ),
//               child: Center(
//                 child: Text(
//                   status,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: 16.0),

//             // 2. Content (Car Name and Installment Amount)
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // 3. Car Name
//                   Text(
//                     "Car Name: ${saleData.carName}",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 5),

//                   // 4. Installment Amount
//                   Text(
//                     "Installment Amount: ${saleData.installmentAmount}",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 5),

//                   // 5. Remaining Installments
//                   Text(
//                     "Remaining Installments: ${saleData.selectedInstallments}",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 5),

//                   // 6. Days Remaining
//                   Text(
//                     "Days Remaining: $daysRemaining",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//     void _showBottomSheet(BuildContext context,SaleRecord saleData, String documentId) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true, // Set to true for full-height modal
//       builder: (BuildContext context) {
//         return SingleChildScrollView(
//           child: IntrinsicHeight(
//             child: Container(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Row for the first image (user.png) and user-related data
//                   Row(
//                     children: [
//                       // User image
//                       Image.asset(
//                         'assets/user.png',
//                         width: 100,
//                         height: 100,
//                       ),
//                       SizedBox(width: 20),
//                       // User-related data
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Customer Name: ${saleData.carName}",
//                             style: TextStyle(fontSize: 16),
//                           ),
//                           Text(
//                             "Phone Number: ${saleData.phoneNumber}",
//                             style: TextStyle(fontSize: 16),
//                           ),
//                           Text(
//                             "Email: ${saleData.email}",
//                             style: TextStyle(fontSize: 16),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),

//                   // Row for the second image (accounting.png) and other data
//                   Row(
//                     children: [
//                       // Accounting image
//                       Image.asset(
//                         'assets/accounting.png',
//                         width: 100,
//                         height: 100,
//                       ),
//                       SizedBox(width: 16),
//                       // Other data
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Car Name: ${saleData.carName}"),
//                           Text(
//                               "Installment Amount: ${saleData.installmentAmount}"),
//                           Text(
//                               "Payment Remaining: ${saleData.paymentRemaining}"),
//                           Text(
//                               "Selected Installments: ${saleData.selectedInstallments}"),
//                           Text("Profit: ${saleData.profit}"),
//                         ],
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: 20),

//                   // Row for buttons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       // First button
//                       MaterialButton(
//                         minWidth: 150,
//                         height: 60,
//                         onPressed: () {
//                           confirmationDialog(context, documentId);
//                           _buildSaleRecordItem(
//                               saleData, documentId);
//                         },
//                         color: Colors.redAccent,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         child: Text(
//                           "DELETE",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),

//                       // Second button
//                       MaterialButton(
//                         minWidth: 150,
//                         height: 60,
//                         onPressed: () {
//                           _showConfirmationDialog(
//                             documentId,
//                             saleData.selectedInstallments,
//                             saleData.dueDate,
//                           );
//                           _buildSaleRecordItem(
//                               saleData as SaleRecord, documentId);
//                         },
//                         color: Colors.greenAccent,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         child: Text(
//                           "UPDATE INSTALLMENTS",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
