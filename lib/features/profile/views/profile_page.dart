import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/auth/controllers/auth_controller.dart';
import 'package:skillzone/features/profile/controllers/profile_controller.dart';
import 'package:skillzone/widgets/notification_icon.dart';
import 'package:skillzone/features/auth/widgets/logout_confirmation_dialog.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Make sure ProfileController is initialized
    Get.put(ProfileController(), permanent: true);
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
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Obx(() => Container(
                height: 136,
                width: 136,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.selectedAvatarColor.withValues(alpha: 0.2),
                  border: Border.all(
                    color: controller.selectedAvatarColor,
                    width: 2,
                  ),
                ),
                child: Image.asset(
                controller.selectedAvatarImage.value,
                ),
              )),
              const SizedBox(
                height: 5,
              ),
              Obx(() => Text(
                controller.username.value,
                style: TextStyle(
                  color: controller.selectedAvatarColor,
                  fontSize: 22,
                ),
              )),
              const SizedBox(
                height: 50,
              ),
              _buildProfileOptions(),
              const SizedBox(
                height: 20,
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
        ));
  }

  void _showLogoutConfirmation(BuildContext context, AuthController authController) {
    Get.dialog(
      LogoutConfirmationDialog(authController: authController),
      barrierDismissible: false,
    );
  }

  Widget _buildProfileOptions() {
    // final authController = Get.find<AuthController>();
    
    return Column(
      children: [
        _buildOptionTile(
          icon: Icons.edit,
          title: 'Edit Avatar',
          subtitle: 'Change your profile picture',
          onTap: () => Get.toNamed(AppRoutes.editAvatar),
        ),
        _buildOptionTile(
          icon: Icons.credit_card,
          title: 'Card Information',
          subtitle: 'View and manage your payment details',
          onTap: () => Get.toNamed(AppRoutes.cardInformation),
        ),
        _buildOptionTile(
          icon: Icons.info,
          title: 'About the app',
          subtitle: 'Learn more about SkillZone',
          onTap: () => Get.toNamed(AppRoutes.aboutApp),
        ),
       _buildOptionTile(
              icon: Icons.school,
              title: 'My Courses',
              subtitle: 'Manage your uploaded courses',
              onTap: () => Get.toNamed(AppRoutes.teacherCourses),
              iconColor: AppColors.primaryColor,
            )
      
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = AppColors.textColorLight,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textColorLight,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.textColorInactive,
          fontSize: 12,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textColorLight,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
