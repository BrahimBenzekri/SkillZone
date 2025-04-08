import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Add your authentication logic here
    // For example, check if user is logged in
    // TODO: Replace with actual auth check using Get Storage
    bool isLoggedIn = false;
    
    if (!isLoggedIn && 
        route != AppRoutes.login && 
        route != AppRoutes.signup && 
        route != AppRoutes.onboarding && 
        route != AppRoutes.welcome) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}