// import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
import 'package:creditrack/main.dart' as app;
import 'package:integration_test/integration_test.dart';



void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Firebase Login Integration Test', () {
    testWidgets('should login with correct credentials and navigate to dashboard', (WidgetTester tester) async {
      // Start your app
      app.main();
      await tester.pumpAndSettle();

      // Find the login fields and button.
      final Finder emailField = find.byKey(const Key('emailField')); // Replace with actual key
      final Finder passwordField = find.byKey(const Key('passwordField')); // Replace with actual key
      final Finder loginButton = find.byKey(const Key('loginButton')); // Replace with actual key

      // Enter the correct credentials.
      await tester.enterText(emailField, 'ahmed@gmail.com');
      await tester.enterText(passwordField, 'ahmed123');

      // Tap the login button.
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify that the dashboard screen is displayed upon successful login.
      expect(find.byKey(const Key('dashboardScreen')), findsOneWidget); // Replace with actual key

      // Add additional assertions or actions as needed.
    });
  });
}