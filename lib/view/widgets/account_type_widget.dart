import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/constants/app_colors.dart';
import 'package:skillzone/view/pages/intrests_page.dart';

void showAccountTypeDialog() {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: AppColors.textColorLight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Join us as',
              style: TextStyle(
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => InterestsPage(),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 500));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Student',
                  style:
                      TextStyle(fontSize: 20, color: AppColors.backgroundColor),
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Handle Teacher button press
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.backgroundColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Teacher',
                  style:
                      TextStyle(fontSize: 20, color: AppColors.backgroundColor),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
