import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';

class ProfileController extends GetxController {
  // User profile data
  final username = 'Cool Guy'.obs;
  final userEmail = 'cooluser@example.com'.obs;
  
  // Avatar settings
  final selectedAvatarImage = 'lib/assets/images/avatar13.png'.obs;
  final selectedAvatarColor = AppColors.primaryColor.obs;
  
  // Available avatars and colors
  final List<String> availableAvatars = [
    'lib/assets/images/avatar1.png',
    'lib/assets/images/avatar2.png',
    'lib/assets/images/avatar3.png',
    'lib/assets/images/avatar4.png',
    'lib/assets/images/avatar5.png',
    'lib/assets/images/avatar6.png',
    'lib/assets/images/avatar7.png',
    'lib/assets/images/avatar8.png',
    'lib/assets/images/avatar9.png',
    'lib/assets/images/avatar10.png',
    'lib/assets/images/avatar11.png',
    'lib/assets/images/avatar12.png',
    'lib/assets/images/avatar13.png',
    'lib/assets/images/avatar14.png',
    'lib/assets/images/avatar15.png',
    'lib/assets/images/avatar16.png',
  ];
  
  final List<Color> availableColors = [
    AppColors.courseColor1,
    AppColors.courseColor2,
    AppColors.courseColor3,
    AppColors.courseColor4,
    AppColors.courseColor5,
    AppColors.courseColor6,
  ];
  
  @override
  void onInit() {
    super.onInit();
    // Load saved avatar settings
    loadAvatarSettings();
  }
  
  // Select avatar image
  void selectAvatar(String avatarPath) {
    selectedAvatarImage.value = avatarPath;
  }
  
  // Select avatar color
  void selectColor(Color color) {
    selectedAvatarColor.value = color;
  }
  
  // Save avatar settings
  void saveAvatarSettings() {
    // In a real app, this would save to local storage or backend
    Get.snackbar(
      'Success',
      'Avatar updated successfully',
      backgroundColor: AppColors.primaryColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
  
  // Load saved avatar settings
  void loadAvatarSettings() {
    // In a real app, this would load from local storage or backend
    // For now, we'll use default values
  }
}