import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creditrack/Models/sales_history_model.dart';

class DueRecordsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DUE RECORDS'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.lightBlue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Add any additional widgets or components you want here

              // Example: Due Records List
              buildDueRecordsList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDueRecordsList(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('sales').where('status', isEqualTo: 'DUE').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No due records available.'));
        }

        List<SaleRecord> dueRecordsList = snapshot.data!.docs
            .map((doc) => SaleRecord.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
            .toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: dueRecordsList.length,
          itemBuilder: (context, index) {
            var dueRecordData = dueRecordsList[index];
            return _buildDueRecordItem(dueRecordData, context);
          },
        );
      },
    );
  }

  Widget _buildDueRecordItem(SaleRecord dueRecordData, BuildContext context) {
    // Customize this function based on your UI requirements
    return Container(
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
              color: Colors.red, // Customize color as needed
            ),
            child: Center(
              child: Text(
                'DUE',
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
                  "Car Name: ${dueRecordData.carName}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),

                // 4. Installment Amount
                Text(
                  "Installment Amount: ${dueRecordData.installmentAmount}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),

                // 5. Remaining Installments
                Text(
                  "Remaining Installments: ${dueRecordData.selectedInstallments}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),

                // 6. Days Remaining
                Text(
                  "Days Remaining: ${calculateDaysRemaining(dueRecordData.dueDate)}",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int calculateDaysRemaining(Timestamp dueDate) {
    // Implement your logic to calculate days remaining based on the current date
    // For demonstration, this function returns a dummy value
    DateTime currentDate = DateTime.now();
    DateTime dueDateTime = dueDate.toDate();
    return dueDateTime.difference(currentDate).inDays;
  }
}
