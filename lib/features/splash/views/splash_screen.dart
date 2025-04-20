import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/features/auth/controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      log('Starting app initialization from splash screen...');
      final authController = Get.find<AuthController>();
      final route = await authController.determineInitialRoute();
      log('Determined initial route: $route');
      Get.offAllNamed(route);
    } catch (e) {
      log('Error during app initialization: $e');
      // Handle initialization error - perhaps navigate to a fallback route
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
