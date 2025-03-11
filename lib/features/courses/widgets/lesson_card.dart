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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bottomBarColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
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
        trailing: ElevatedButton(
          onPressed: lesson.isCompleted ? null : onTap,
          child: Text(lesson.isCompleted ? 'Completed' : 'Start'),
        ),
      ),
    );
  }
}