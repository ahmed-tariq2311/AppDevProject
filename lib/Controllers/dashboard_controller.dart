import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<int> getTotalCarSold() async {
    // Get the current month and year
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    // Format the current month and year as a string in 'YYYY-MM' format
    String currentMonthYear = '${currentYear.toString().padLeft(4, '0')}-'
        '${currentMonth.toString().padLeft(2, '0')}';

    // Reference to the 'sales' collection in Firestore
    CollectionReference salesCollection = _firestore.collection('sales');

    // Query to get records for the current month and year
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await salesCollection
        .where('submitDate',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(DateTime(currentYear, currentMonth, 1)))
        .where('submitDate',
            isLessThan:
                Timestamp.fromDate(DateTime(currentYear, currentMonth + 1, 1)))
        .get() as QuerySnapshot<Map<String, dynamic>>; // Explicit type casting

    // Get the count of documents
    int totalCount = querySnapshot.size;

    return totalCount;
  }

  Future<num> getPaymentRemainingSum() async {
    // Get the current month and year
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    // Format the current month and year as a string in 'YYYY-MM' format
    String currentMonthYear = '${currentYear.toString().padLeft(4, '0')}-'
        '${currentMonth.toString().padLeft(2, '0')}';

    // Reference to the 'sales' collection in Firestore
    CollectionReference salesCollection = _firestore.collection('sales');

    // Query to get records for the current month and year
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await salesCollection
        .where('submitDate',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(DateTime(currentYear, currentMonth, 1)))
        .where('submitDate',
            isLessThan:
                Timestamp.fromDate(DateTime(currentYear, currentMonth + 1, 1)))
        .get() as QuerySnapshot<Map<String, dynamic>>; // Explicit type casting

    // Calculate the sum of 'paymentRemaining'
    num paymentRemainingSum = 0;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      paymentRemainingSum += doc['paymentRemaining'] ?? 0;
    }
    return paymentRemainingSum;
  }

  Future<num> getTotalProfit() async {
    // Get the current month and year
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    // Format the current month and year as a string in 'YYYY-MM' format
    String currentMonthYear = '${currentYear.toString().padLeft(4, '0')}-'
        '${currentMonth.toString().padLeft(2, '0')}';

    // Reference to the 'sales' collection in Firestore
    CollectionReference salesCollection = _firestore.collection('sales');

    // Query to get records for the current month and year
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await salesCollection
        .where('submitDate',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(DateTime(currentYear, currentMonth, 1)))
        .where('submitDate',
            isLessThan:
                Timestamp.fromDate(DateTime(currentYear, currentMonth + 1, 1)))
        .get() as QuerySnapshot<Map<String, dynamic>>; // Explicit type casting

    // Calculate the total profit
    num totalProfit = 0;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      totalProfit += doc['profit'] ?? 0;
    }
    return totalProfit;
  }
  
  Future<List<double>> getStatusSum() async {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    // Format the current month and year as a string in 'YYYY-MM' format
    String currentMonthYear = '${currentYear.toString().padLeft(4, '0')}-'
        '${currentMonth.toString().padLeft(2, '0')}';

    // Reference to the 'sales' collection in Firestore
    CollectionReference salesCollection = _firestore.collection('sales');

    // Query to get records for the current month and year
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await salesCollection
        .where('submitDate',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(DateTime(currentYear, currentMonth, 1)))
        .where('submitDate',
            isLessThan:
                Timestamp.fromDate(DateTime(currentYear, currentMonth + 1, 1)))
        .get() as QuerySnapshot<Map<String, dynamic>>; // Explicit type casting

    double dueSum = 0;
    double upcomingSum = 0;
    double paidSum = 0;

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      // Extract the "submitDate" field and convert it to a DateTime object
      DateTime submitDate = (doc['submitDate'] as Timestamp).toDate();

      // Check if the document's "submitDate" is in the current month
      if (submitDate.month != currentMonth) {
        continue; // Skip documents with a different month
      }
      // Process the document based on its "status" field
      String status = doc['status'] ?? '';

      switch (status) {
        case 'DUE':
          dueSum += dueSum + 1;
          break;
        case 'UPCOMING':
          upcomingSum += upcomingSum + 1;
          break;
        case 'PAID':
          paidSum += paidSum + 1;
          break;
        // Handle other status values if needed
      }
    }
    return [dueSum, upcomingSum, paidSum];
  }

  Future<List<Map<String, dynamic>>> getDayAnddownPaymentData() async {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    // Format the current month and year as a string in 'YYYY-MM' format
    String currentMonthYear = '${currentYear.toString().padLeft(4, '0')}-'
        '${currentMonth.toString().padLeft(2, '0')}';

    // Reference to the 'sales' collection in Firestore
    CollectionReference salesCollection = _firestore.collection('sales');

    // Query to get records for the current month and year
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await salesCollection
        .where('submitDate',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(DateTime(currentYear, currentMonth, 1)))
        .where('submitDate',
            isLessThan:
                Timestamp.fromDate(DateTime(currentYear, currentMonth + 1, 1)))
        .get() as QuerySnapshot<Map<String, dynamic>>; // Explicit type casting

    List<Map<String, dynamic>> dayAndCostPriceData = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      DateTime submitDate = (doc['submitDate'] as Timestamp).toDate();
      int day = submitDate.day;
      double costPrice = (doc['downPayment'] ?? 0).toDouble();

      // Add data to the list
      dayAndCostPriceData.add({
        'day': day,
        'downPayment': costPrice,
      });
    }

    return dayAndCostPriceData;
  }

  List<String> getNext5Months() {
    List<String> months = [];

    // Get the current month and year
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    for (int i = 0; i < 6; i++) {
      // Calculate the next month
      int nextMonth = (currentMonth + i) % 12;

      // Adjust the year if needed
      int nextYear = currentYear + (currentMonth + i) ~/ 12;

      // Get the name of the month
      String monthName = _getMonthName(nextMonth);

      // Add the formatted string to the list
      months.add('$monthName');
    }

    return months;
  }

  String _getMonthName(int month) {
    switch (month) {
      case 0:
        return 'Jan';
      case 1:
        return 'Feb';
      case 2:
        return 'Mar';
      case 3:
        return 'Apr';
      case 4:
        return 'May';
      case 5:
        return 'Jun';
      case 6:
        return 'Jul';
      case 7:
        return 'Aug';
      case 8:
        return 'Sept';
      case 9:
        return 'Oct';
      case 10:
        return 'Nov';
      case 11:
        return 'Dec';
      default:
        return '';
    }
  }

  Future<List<num>> getRevenueList() async {
  List<num> revenueList = List.filled(6, 0);

  // Reference to the 'sales' collection in Firestore
  CollectionReference salesCollection = _firestore.collection('sales');

  // Query to get all documents
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await salesCollection.get() as QuerySnapshot<Map<String, dynamic>>;

  for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
    int selectedInstallments = doc['selectedInstallments'] ?? 0;
    num installmentAmount = doc['installmentAmount'] ?? 0;

    // Check each condition and update the corresponding index in the list
    if (selectedInstallments > 0) {
      revenueList[0] += installmentAmount;
    }

    if (selectedInstallments > 1) {
      revenueList[1] += installmentAmount;
    }

    if (selectedInstallments > 2) {
      revenueList[2] += installmentAmount;
    }

      if (selectedInstallments > 3) {
      revenueList[3] += installmentAmount;
    }  
    if (selectedInstallments > 4) {
      revenueList[4] += installmentAmount;
    } 
     if (selectedInstallments > 5) {
      revenueList[5] += installmentAmount;
    }

  }
  return revenueList;
}
  

}