import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skillzone/core/theme/app_colors.dart';

class ProfileController extends GetxController {
  // Storage keys
  static const String avatarImageKey = 'avatar_image';
  static const String avatarColorIndexKey = 'avatar_color_index'; // Changed key name
  static const String usernameKey = 'username';
  static const String userEmailKey = 'user_email';
  
  final storage = GetStorage();
  
  // User profile data
  final username = 'Rania Kouda'.obs;
  final userEmail = 'cooluser@example.com'.obs;
  
  // Avatar settings
  final selectedAvatarImage = 'lib/assets/images/avatar13.png'.obs;
  final selectedAvatarColorIndex = 0.obs; // Store index instead of color
  
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
  
  // Computed property to get the selected color from the index
  Color get selectedAvatarColor => availableColors[selectedAvatarColorIndex.value];
  
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
  
  // Select avatar color by index
  void selectColor(Color color) {
    final index = availableColors.indexOf(color);
    if (index != -1) {
      selectedAvatarColorIndex.value = index;
    }
  }
  
  // Save avatar settings
  void saveAvatarSettings() async {
    try {
      // Save avatar image path
      await storage.write(avatarImageKey, selectedAvatarImage.value);
      
      // Save avatar color index
      await storage.write(avatarColorIndexKey, selectedAvatarColorIndex.value);
      
      Get.snackbar(
        'Success',
        'Avatar updated successfully',
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save avatar settings',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }
  
  // Load saved avatar settings
  void loadAvatarSettings() {
    try {
      // Load avatar image path
      final savedAvatarImage = storage.read<String>(avatarImageKey);
      if (savedAvatarImage != null && savedAvatarImage.isNotEmpty) {
        selectedAvatarImage.value = savedAvatarImage;
      }
      
      // Load avatar color index
      final savedColorIndex = storage.read<int>(avatarColorIndexKey);
      if (savedColorIndex != null && savedColorIndex >= 0 && savedColorIndex < availableColors.length) {
        selectedAvatarColorIndex.value = savedColorIndex;
      }
    } catch (e) {
      // If loading fails, use default values
      selectedAvatarImage.value = 'lib/assets/images/avatar13.png';
      selectedAvatarColorIndex.value = 0; // Default to first color
    }
  }
}
