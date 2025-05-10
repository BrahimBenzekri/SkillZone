import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import '../controllers/points_controller.dart';
import '../widgets/level_progress_bar.dart';

class PointsPage extends StatelessWidget {
  PointsPage({super.key}) {
    Get.put(PointsController());
  }

  PointsController get controller => Get.find<PointsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textColorLight,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Points & Level',
          style: TextStyle(
            color: AppColors.textColorLight,
            fontSize: 24,
          ),
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Current Level Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.bottomBarColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            controller.currentLevel.value?.badge ?? '',
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.currentLevel.value?.name ?? '',
                                  style: const TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  controller.currentLevel.value?.description ??
                                      '',
                                  style: const TextStyle(
                                    color: AppColors.textColorLight,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      LevelProgressBar(progress: controller.levelProgress),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${controller.points} points',
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${controller.pointsToNextLevel} points to next level',
                            style: const TextStyle(
                              color: AppColors.textColorInactive,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Levels List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.levels.length,
                  itemBuilder: (context, index) {
                    final level = controller.levels[index];
                    final isUnlocked =
                        controller.points.value >= level.requiredPoints;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bottomBarColor.withValues(alpha:0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isUnlocked
                              ? AppColors.primaryColor.withValues(alpha:0.3)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            level.badge,
                            height: 60,
                            width: 60,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  level.name,
                                  style: TextStyle(
                                    color: isUnlocked
                                        ? AppColors.textColorLight
                                        : AppColors.textColorInactive,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${level.requiredPoints} points required',
                                  style: TextStyle(
                                    color: isUnlocked
                                        ? AppColors.primaryColor
                                        : AppColors.textColorInactive,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isUnlocked)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primaryColor,
                              size: 24,
                            ),
                        ],
                      ),
                    );
                  },
                ),
                // Bottom padding to account for bottom bar
                const SizedBox(height: 70), // Increased bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}
