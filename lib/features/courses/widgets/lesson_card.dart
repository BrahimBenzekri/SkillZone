import 'package:flutter/material.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/inventory/controllers/inventory_controller.dart';
import '../models/lesson.dart';
import 'package:get/get.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;
  final bool isLocked;
  final String courseId;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.onTap,
    this.isLocked = false,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bottomBarColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Lesson Number Circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${lesson.number}',
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Lesson Title and Duration
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: TextStyle(
                        color: isLocked ? AppColors.textColorInactive : AppColors.textColorLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${lesson.duration.inMinutes} min',
                      style: const TextStyle(
                        color: AppColors.textColorInactive,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Status Icon (completed, locked, or play)
              Obx(() {
                final isCompleted = Get.find<InventoryController>().isLessonCompleted(courseId, lesson.id);
                
                if (isCompleted) {
                 return Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                  );
                } else if (isLocked) {
                  return const Icon(
                    Icons.lock,
                    color: AppColors.textColorInactive,
                    size: 24,
                  );
                } else{
                  return Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
