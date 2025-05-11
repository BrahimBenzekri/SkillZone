import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/auth/controllers/auth_controller.dart';

class AccountTypeWidget extends StatelessWidget {
  final String email;
  final String password;
  final String username;
  final String? firstName;
  final String? lastName;

  const AccountTypeWidget({
    required this.email,
    required this.password,
    required this.username,
    this.firstName,
    this.lastName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.textColorLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Join us as',
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => authController.signup(
                  firstName: firstName,
                  lastName: lastName,
                  username: username,
                  email: email,
                  password: password,
                  isTeacherValue: false, // Student
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Student',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.backgroundColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => authController.signup(
                  firstName: firstName,
                  lastName: lastName,
                  username: username,
                  email: email,
                  password: password,
                  isTeacherValue: true, // Teacher
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.backgroundColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Teacher',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.backgroundColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
