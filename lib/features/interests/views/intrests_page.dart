import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/interests/controllers/interests_controller.dart';
import 'package:skillzone/features/profile/views/profile_page.dart';
import 'package:skillzone/features/interests/widgets/skill_card.dart';

class InterestsPage extends StatelessWidget {
  final InterestController controller = Get.put(InterestController());
  bool get isButtonEnabled => controller.isSelectionValid;
  InterestsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textColorLight,
              size: 25,
            ),
            onPressed: () => Get.back(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Please choose your area of interest',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textColorLight,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 25),
                const Text("Soft Skills",
                    style:
                        TextStyle(fontSize: 22, color: AppColors.primaryColor)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.softSkills.map((skill) {
                    return SkillCard(
                      skill: skill,
                      onTap: () =>
                          skill.isSelected.value = !skill.isSelected.value,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text("Hard Skills",
                    style:
                        TextStyle(fontSize: 22, color: AppColors.primaryColor)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.hardSkills.map((skill) {
                    return SkillCard(
                      skill: skill,
                      onTap: () =>
                          skill.isSelected.value = !skill.isSelected.value,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                              // Navigate to the next screen
                              Get.to(() => const ProfilePage());
                            }
                          : () {
                              // Show snackbar when the button is disabled
                              controller.showWarningSnackbar();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isButtonEnabled
                            ? AppColors.primaryColor
                            : AppColors.textColorInactive,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: AppColors.backgroundColor,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
