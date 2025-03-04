import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/view/pages/onboarding_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Oddval',
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              fontWeight: FontWeight.w600,
            ),
            bodyMedium: TextStyle(fontWeight: FontWeight.w600),
            bodySmall: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        home: OnboardingScreen());
  }
}
