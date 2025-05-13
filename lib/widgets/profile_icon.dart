import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/navigation/controllers/navigation_controller.dart';
import 'package:skillzone/features/profile/services/user_profile_service.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final profileService = Get.find<UserProfileService>();

    return GestureDetector(
      onTap: () {
        Get.find<NavigationController>().changePage(3);
      },
      child: Obx(() => Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.avatarColors[profileService.selectedAvatarColorIndex.value].withValues(alpha: 0.2),
          border: Border.all(
            color: AppColors.avatarColors[profileService.selectedAvatarColorIndex.value],
            width: 2,
          ),
        ),
        child: Image.asset(
          profileService.selectedAvatarImage.value,
        ),
      )),
    );
  }
}
