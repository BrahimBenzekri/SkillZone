import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import 'package:skillzone/features/courses/controllers/courses_controller.dart';
import 'package:skillzone/features/courses/models/course.dart';

import '../models/course_type.dart';

class TeacherCoursesPage extends GetView<CoursesController> {
  const TeacherCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
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
                Text.rich(
                  TextSpan(
                    text: 'My ',
                    style: const TextStyle(
                      color: AppColors.textColorLight,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: 'Courses',
                        style: TextStyle(
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [
                                AppColors.primaryColor,
                                AppColors.secondaryColor,
                              ],
                            ).createShader(
                              const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                            ),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Upload Course Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.uploadCourse),
              icon: const Icon(Icons.add),
              label: const Text('Upload New Course'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Courses List
          Expanded(
            child: Obx(() {
              final teacherCourses = controller.teacherCourses;
              
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (teacherCourses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.school_outlined,
                        size: 80,
                        color: AppColors.textColorInactive,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No courses uploaded yet',
                        style: TextStyle(
                          color: AppColors.textColorLight,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Start sharing your knowledge by uploading a course',
                        style: TextStyle(
                          color: AppColors.textColorInactive,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => Get.toNamed(AppRoutes.uploadCourse),
                        icon: const Icon(Icons.add),
                        label: const Text('Upload Your First Course'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor.withValues(alpha: 0.2),
                          foregroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: teacherCourses.length,
                itemBuilder: (context, index) {
                  final course = teacherCourses[index];
                  return _buildCourseCard(course);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCourseCard(Course course) {
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
          arguments: course,
        ),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Type Badge
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.only(top: 12, right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: course.type == CourseType.hard
                      ? AppColors.secondaryColor.withValues(alpha: 0.2)
                      : AppColors.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  course.type == CourseType.hard ? 'Hard Skill' : 'Soft Skill',
                  style: TextStyle(
                    color: course.type == CourseType.hard
                        ? AppColors.secondaryColor
                        : AppColors.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Title
                  Text(
                    course.title,
                    style: const TextStyle(
                      color: AppColors.textColorLight,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Course Description
                  Text(
                    course.description,
                    style: const TextStyle(
                      color: AppColors.textColorInactive,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  
                  // Course Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Duration
                      Row(
                        children: [
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
                      
                      // Lessons Count
                      Row(
                        children: [
                          const Icon(
                            Icons.video_library,
                            color: AppColors.textColorInactive,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${course.lessons.length} lessons',
                            style: const TextStyle(
                              color: AppColors.textColorInactive,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      
                      // Price or Points
                      Row(
                        children: [
                          Icon(
                            course.type == CourseType.hard ? Icons.attach_money : Icons.star,
                            color: AppColors.textColorInactive,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            course.type == CourseType.hard
                                ? '\$${course.price}'
                                : '${course.points} points',
                            style: const TextStyle(
                              color: AppColors.textColorInactive,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}