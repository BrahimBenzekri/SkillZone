import 'package:flutter/material.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import '../models/lesson.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bottomBarColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              lesson.number.toString(),
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        title: Text(
          lesson.title,
          style: const TextStyle(
            color: AppColors.textColorLight,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '${lesson.duration.inMinutes} minutes',
          style: const TextStyle(
            color: AppColors.textColorInactive,
            fontSize: 12,
          ),
        ),
        trailing: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: lesson.isCompleted 
                ? AppColors.textColorInactive.withOpacity(0.1)
                : AppColors.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: lesson.isCompleted ? null : onTap,
            icon: Icon(
              lesson.isCompleted 
                  ? Icons.check_rounded
                  : Icons.play_arrow_rounded,
              color: lesson.isCompleted 
                  ? AppColors.textColorInactive
                  : AppColors.primaryColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
