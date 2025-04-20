import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/auth/controllers/auth_controller.dart';
import 'package:skillzone/widgets/notification_icon.dart';
import 'package:skillzone/features/profile/widgets/profile_option.dart';
import 'package:skillzone/features/auth/widgets/logout_confirmation_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          centerTitle: true,
          title: const Text(
            'My Profile',
            style: TextStyle(
              color: AppColors.textColorLight,
              fontSize: 24,
            ),
          ),
          actions: const [
            NotificationIcon(isThereNotification: true),
            SizedBox(width: 12,)
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 136,
                      height: 136,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.backgroundColor,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 3,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 63,
                      child: Image.asset(
                        'lib/assets/images/profile_image.png',
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text('Cool Guy',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 22,
                    )),
                const SizedBox(
                  height: 50,
                ),
                const ProfileOptionCard(text: "Edit Avatar"),
                const ProfileOptionCard(text: "Card Information"),
                const ProfileOptionCard(text: "About the app"),
                const SizedBox(
                  height: 60,
                ),
                Obx(() => TextButton(
                  onPressed: authController.isLoggingOut.value 
                    ? null  // Disable button while logging out
                    : () => _showLogoutConfirmation(context, authController),
                  child: authController.isLoggingOut.value
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.errorColor,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Logging out...",
                              style: TextStyle(
                                color: AppColors.errorColor,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          "Log Out",
                          style: TextStyle(
                            color: AppColors.errorColor,
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.errorColor,
                            decorationThickness: 2,
                          ),
                        ),
                )),
                Obx(() => authController.logoutError.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          authController.logoutError.value,
                          style: const TextStyle(
                            color: AppColors.errorColor,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox.shrink()),
              ],
            ),
          ),
        ));
  }

  void _showLogoutConfirmation(BuildContext context, AuthController authController) {
    Get.dialog(
      LogoutConfirmationDialog(authController: authController),
      barrierDismissible: false,
    );
  }
}
