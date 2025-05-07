import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/core/utils/media_query_helper.dart';
import 'package:skillzone/features/profile/controllers/profile_controller.dart';

class EditAvatarPage extends GetView<ProfileController> {
  const EditAvatarPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate item width to fit exactly 4 items per row
    final screenWidth = MediaQueryHelper.getScreenWidth(context);
    const horizontalPadding = 20.0 * 2; // Left and right padding
    const spacingBetweenItems = 15.0 * 3; // 3 spaces between 4 items
    final availableWidth = screenWidth - horizontalPadding - spacingBetweenItems;
    final avatarItemWidth = availableWidth / 4;
    
    // Calculate color item width (smaller than avatar items)
    final colorItemWidth = avatarItemWidth * 0.6;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/cubes_background.png',
              repeat: ImageRepeat.repeat,
              fit: BoxFit.fitWidth,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textColorLight,
                        size: 25,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Edit Avatar',
                      style: TextStyle(
                        color: AppColors.textColorLight,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Preview of selected avatar
                Obx(() => Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.selectedAvatarColor.withValues(alpha: 0.2),
                    border: Border.all(
                      color: controller.selectedAvatarColor,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      controller.selectedAvatarImage.value
                    ),
                  ),
                )),
                
                const SizedBox(height: 30),
                
                // Avatar selection
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Select Avatar',
                    style: TextStyle(
                      color: AppColors.textColorLight,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                
                const SizedBox(height: 15),
                
                // Avatar grid using Wrap with fixed 4 items per row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: controller.availableAvatars.map((avatar) {
                      return Obx(() => GestureDetector(
                        onTap: () => controller.selectAvatar(avatar),
                        child: Container(
                          width: avatarItemWidth,
                          height: avatarItemWidth, // Make it square
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.bottomBarColor,
                            border: Border.all(
                              color: controller.selectedAvatarImage.value == avatar
                                  ? controller.selectedAvatarColor
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              avatar
                            ),
                          ),
                        ),
                      ));
                    }).toList(),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Color selection
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Select Color',
                    style: TextStyle(
                      color: AppColors.textColorLight,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                
                const SizedBox(height: 15),
                
                // Color grid using Wrap with fixed 4 items per row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: controller.availableColors.map((color) {
                      return Obx(() => GestureDetector(
                        onTap: () => controller.selectColor(color),
                        child: Container(
                          width: colorItemWidth,
                          height: colorItemWidth, // Make it square
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                            border: Border.all(
                              color: controller.selectedAvatarColor == color
                                  ? AppColors.textColorLight
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                      ));
                    }).toList(),
                  ),
                ),
                
                const SizedBox(height: 50),
                
                // Save button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.saveAvatarSettings();
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
