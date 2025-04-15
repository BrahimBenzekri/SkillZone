import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import 'package:skillzone/features/auth/controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    final isLoggedIn = authController.accessToken != null;
    
    if (!isLoggedIn && 
        route != AppRoutes.login && 
        route != AppRoutes.signup && 
        route != AppRoutes.onboarding && 
        route != AppRoutes.welcome &&
        route != AppRoutes.emailVerification) {
      if (Get.isRegistered<AuthController>()) {
        Get.delete<AuthController>();
      }
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}
