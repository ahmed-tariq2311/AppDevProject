import 'package:creditrack/Views/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:creditrack/Utils/FadeAnimation.dart';
import 'package:creditrack/Views/login_screen.dart';
import 'package:creditrack/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationProvider = StateProvider<bool>((ref) => false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomePage(),
      ),
    ),
  );
}
 