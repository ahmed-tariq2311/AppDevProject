import 'package:creditrack/Views/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:creditrack/main.dart' as app; // Replace with your app's import
import 'package:creditrack/Views/login_screen.dart'; // Import your LoginPage

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Test', () {
    testWidgets("Login and Navigate to Dashboard", (WidgetTester tester) async {
      app.main(); // Start your app
      await tester.pumpAndSettle(); // Wait for all animations and initializations

      // Find the TextFields and the login button by looking for their specific widgets
      final emailField = find.widgetWithText(TextField, 'Email');
      final passwordField = find.widgetWithText(TextField, 'Password');
      final loginButton = find.widgetWithText(MaterialButton, "Login");

      // Enter 'testUser' into the email TextField
      await tester.enterText(emailField, 'ahmed@gmail.com');
      // Enter 'testPassword' into the password TextField
      await tester.enterText(passwordField, 'ahmed123');

      // Tap the login button
      await tester.tap(loginButton);
      await tester.pumpAndSettle(); // Wait for navigation and animations

      // Verify that the Dashboard screen is displayed by checking for its specific widget
      expect(find.byType(DashboardScreen), findsOneWidget);
    });
  });
}