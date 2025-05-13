import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skillzone/features/profile/services/user_profile_service.dart';

class ProfileController extends GetxController {
  final UserProfileService _profileService = Get.find<UserProfileService>();
  final storage = GetStorage();
  
  // About app URL
  final String aboutAppUrl = 'https://skillzone.netlify.app/';
  
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
  
  // Delegate to profile service
  RxString get username => _profileService.username;
  RxString get selectedAvatarImage => _profileService.selectedAvatarImage;
  RxInt get selectedAvatarColorIndex => _profileService.selectedAvatarColorIndex;
  String get fullName => _profileService.fullName;
  bool get isTeacher => _profileService.isTeacher;
  
  // Computed property to get the selected color from the index
  Color get selectedAvatarColor => availableColors[selectedAvatarColorIndex.value];
  
  // Launch URL method
  Future<void> launchAboutAppUrl() async {
    final Uri url = Uri.parse(aboutAppUrl);
    try {
      if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open the about page: $e',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  @override
  void onInit() {
    super.onInit();
    // Refresh profile data from API
    _profileService.fetchProfileData();
  }
  
  // Select avatar image
  void selectAvatar(String avatarPath) {
    _profileService.selectedAvatarImage.value = avatarPath;
  }
  
  // Select avatar color by index
  void selectColor(Color color) {
    final index = availableColors.indexOf(color);
    if (index != -1) {
      _profileService.selectedAvatarColorIndex.value = index;
    }
  }
  
  // Save avatar settings
  void saveAvatarSettings() async {
    try {
      await _profileService.saveAvatarSettings(
        selectedAvatarImage.value,
        selectedAvatarColorIndex.value
      );
      
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
}
