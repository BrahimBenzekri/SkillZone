import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
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

      final authController = Get.find<AuthController>();
      final route = await authController.determineInitialRoute();

      Get.offAllNamed(route);
    } catch (e) {

      // Handle initialization error - perhaps navigate to a fallback route
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
