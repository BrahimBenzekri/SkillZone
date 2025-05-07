import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/courses/controllers/courses_controller.dart';
import 'package:skillzone/features/courses/models/course.dart';

class CourseListItem extends StatelessWidget {
  final Course course;
  final CoursesController coursesController = Get.find<CoursesController>();

  CourseListItem({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.bottomBarColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Get.toNamed(
          AppRoutes.courseDetails,
          arguments: {'course': course, 'backgroundColor': AppColors.courseColor1},
        ),
        child: Row(
          children: [
            // Course thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.asset(
                course.thumbnail,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            // Course details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        color: AppColors.textColorLight,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          course.rating.toString(),
                          style: const TextStyle(
                            color: AppColors.textColorInactive,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.access_time,
                          color: AppColors.textColorInactive,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${course.duration.inHours}h ${course.duration.inMinutes % 60}m',
                          style: const TextStyle(
                            color: AppColors.textColorInactive,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (course.progress != null) ...[
                      LinearProgressIndicator(
                        value: course.progress,
                        backgroundColor: AppColors.textColorInactive.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(course.progress! * 100).toInt()}% completed',
                        style: const TextStyle(
                          color: AppColors.textColorInactive,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Like button
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Obx(() => IconButton(
                icon: Icon(
                  course.isLiked.value ? Icons.favorite : Icons.favorite_border,
                  color: course.isLiked.value ? Colors.red : AppColors.textColorInactive,
                ),
                onPressed: () => coursesController.toggleLike(course),
              )),
            ),
          ],
        ),
      ),
    );
  }
}