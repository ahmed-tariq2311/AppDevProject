import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:creditrack/dashboard.dart';
import 'package:creditrack/add_sale.dart';
import 'package:creditrack/sales_history.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Multiple Device Screenshots', () {
    testGoldens('Device Variation Test', (tester) async {
      await loadAppFonts(); // Load fonts if you have any

      // Define your device configurations
      final devices = [
        Device(name: 'iPhone11', size: const Size(414, 896), devicePixelRatio: 2.0), // iPhone 11
        Device(name: 'SamsungS10', size: const Size(360, 760), devicePixelRatio: 4.0), // Samsung S10
        // ... Add more devices as needed
      ];

      // Define your widget scenarios manually
      final scenarios = [
        {'name': 'Dashboard Screen', 'widget': DashboardScreen()},
        {'name': 'Add Sale Screen', 'widget': AddSale()},
        {'name': 'Sales History Screen', 'widget': SalesHistoryScreen()},
        // ... Add more scenarios as needed
      ];

      // Iterate over each device and scenario combination
      for (final device in devices) {
        for (final scenario in scenarios) {
          // Set up the device environment and widget
          await tester.pumpWidgetBuilder(
            scenario['widget'] as Widget,
            wrapper: (child) => MediaQuery(
              data: MediaQueryData(
                size: device.size,
                devicePixelRatio: device.devicePixelRatio,
              ),
              child: MaterialApp(home: child),
            ),
          );

          // Take the screenshot
          await multiScreenGolden(
            tester,
            '${scenario['name']} on ${device.name}',
            devices: [device],
          );
        }
      }
    });
  });
}