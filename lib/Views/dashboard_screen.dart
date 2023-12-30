import 'package:creditrack/Views/add_sale_screen.dart';
import 'package:creditrack/Views/sales_history_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Controllers/dashboard_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:creditrack/Utils/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to providers
    final totalCarsSold = ref.watch(totalCarSoldProvider);
    final paymentRemainingSum = ref.watch(paymentRemainingSumProvider);
    final totalProfit = ref.watch(totalProfitProvider);
    final statusSum = ref.watch(statusSumProvider);
    final dayAndDownPaymentData = ref.watch(dayAndDownPaymentDataProvider);
    final revenueList = ref.watch(revenueListProvider);
    final months = ref.watch(next5monthsprovider);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 145, 207, 236),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                'TADASHII MOTORS DASHBOARD',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Three Cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        final totalCarsSoldAsyncValue =
                            ref.watch(totalCarSoldProvider);
                        return Card(
                          elevation: 5,
                          child: totalCarsSoldAsyncValue.when(
                            data: (data) =>
                                _buildCard('Total Car Sold', data.toString()),
                            loading: () =>
                                _buildCard('Total Car Sold', 'Loading...'),
                            error: (error, stack) =>
                                _buildCard('Total Car Sold', 'Error: $error'),
                          ),
                        );
                      },
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final paymentRemainingSumAsyncValue =
                            ref.watch(paymentRemainingSumProvider);

                        return paymentRemainingSumAsyncValue.when(
                          data: (Revenue) {
                            var revenueInMillions = Revenue / 1000000;
                            return _buildCard(
                                'Revenue Generated', '$revenueInMillions M');
                          },
                          loading: () =>
                              _buildCard('Revenue Generated', 'Loading...'),
                          error: (error, stack) =>
                              _buildCard('Revenue Generated', 'Error'),
                        );
                      },
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final totalProfitAsyncValue =
                            ref.watch(totalProfitProvider);

                        return totalProfitAsyncValue.when(
                          data: (profit) {
                            var profitinM = profit / 1000000;
                            return _buildCard('Profit', '$profitinM M');
                          },
                          loading: () => _buildCard('Profit', 'Loading...'),
                          error: (error, stack) =>
                              _buildCard('Profit', 'Error'),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              Consumer(
                builder: (context, ref, child) {
                  final statusSumAsyncValue = ref.watch(statusSumProvider);

                  return statusSumAsyncValue.when(
                    data: (statusSum) {
                      return Card(
                        elevation: 5,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Paid/Upcoming/Due',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 15),
                              _buildDonutChart(
                                  statusSum[0], statusSum[1], statusSum[2]),
                            ],
                          ),
                        ),
                      );
                    },
                    loading: () => _buildCard('Donut Chart', 'Loading...'),
                    error: (error, stack) => _buildCard('Donut Chart', 'Error'),
                  );
                },
              ),

              SizedBox(height: 20),

              Card(
                elevation: 5,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Projected Revenue',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Consumer(
                        builder: (context, ref, child) {
                          final revenueListAsyncValue =
                              ref.watch(revenueListProvider);
                          final monthsAsyncValue =
                              ref.watch(next5monthsprovider);

                          return revenueListAsyncValue.when(
                            data: (revenueList) => monthsAsyncValue.when(
                              data: (months) => _buildBarChart(
                                revenueList
                                    .map((value) => value.toDouble())
                                    .toList(),
                                months,
                              ),
                              loading: () => CircularProgressIndicator(),
                              error: (error, stack) => Text('Error: $error'),
                            ),
                            loading: () => CircularProgressIndicator(),
                            error: (error, stack) => Text('Error: $error'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              Card(
                elevation: 5,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Advance Collected',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Consumer(
                        builder: (context, ref, child) {
                          final dayAndDownPaymentDataAsyncValue =
                              ref.watch(dayAndDownPaymentDataProvider);

                          return dayAndDownPaymentDataAsyncValue.when(
                            data: (dayAndCostPriceData) =>
                                _buildLineChart(dayAndCostPriceData),
                            loading: () => CircularProgressIndicator(),
                            error: (error, stack) =>
                                Text('Error fetching data: $error'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
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
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation here
          if (index == 2) {
            // Navigate to Home (you can replace 'DashboardScreen' with the actual name of your dashboard screen)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SalesHistoryScreen()),
            );
          } else if (index == 0) {
            // Stay on Add Record screen
          } else if (index == 1) {
            // Navigate to Sales History (you can replace 'SalesHistoryScreen' with the actual name of your sales history screen)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AddRecordScreen()),
            );
          }
        },
      ),
    );
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
                logout(context);
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

  void logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

Widget _buildCard(String title, String value) {
  return Card(
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 255, 217, 0),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildDonutChart(double dueSum, double upcomingSum, double paidSum) {
  return Container(
    height: 200,
    child: PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: upcomingSum,
            color: Colors.blue,
            title: 'UPCOMING',
            radius: 50,
          ),
          PieChartSectionData(
            value: dueSum,
            color: Colors.red,
            title: 'DUE',
            radius: 50,
          ),
          PieChartSectionData(
            value: paidSum,
            color: Colors.lightGreen,
            title: 'PAID',
            radius: 50,
          ),
        ],
      ),
    ),
  );
}

Widget _buildBarChart(List<double> revenueList, List<String> months) {
  return Container(
    height: 200,
    child: BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 2000000,
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (value) {
              if (value >= 0 && value < months.length) {
                return months[value.toInt()];
              }
              return '';
            },
            margin: 10,
          ),
          leftTitles: SideTitles(showTitles: true),
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
        ),
        barGroups: List.generate(revenueList.length, (index) {
          return BarChartGroupData(
            x: index.toInt(),
            barRods: [
              BarChartRodData(y: revenueList[index], colors: [Colors.blue]),
            ],
          );
        }),
      ),
    ),
  );
}

Widget _buildLineChart(List<Map<String, dynamic>> data) {
  List<FlSpot> spots = data
      .map((entry) => FlSpot(entry['day'].toDouble(), entry['downPayment']))
      .toList();

  return Container(
    height: 200,
    child: LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
        ),
        titlesData: FlTitlesData(
          leftTitles: SideTitles(showTitles: true),
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (value) {
              // You can customize the x-axis labels here based on your data
              return value.toInt().toString();
            },
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: const Color(0xff37434d),
            width: 2,
          ),
        ),
        minX: 1,
        maxX: 31, // Assuming the maximum day in a month is 31
        minY: 50000,
        maxY: 6000000, // Adjust this based on your actual data range
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            colors: [Colors.blue],
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    ),
  );
}
