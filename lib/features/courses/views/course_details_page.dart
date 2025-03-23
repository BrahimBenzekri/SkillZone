import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import '../controllers/course_details_controller.dart';
import '../models/course_type.dart';
import '../widgets/lesson_card.dart';

class CourseDetailsPage extends StatelessWidget {
  final controller = Get.put(CourseDetailsController());
  final Color backgroundColor;

  CourseDetailsPage({super.key})
      : backgroundColor = (Get.arguments as Map)['backgroundColor'] as Color {
    final String courseId = Get.parameters['id'] ?? '';
    controller.loadCourseDetails(courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
              child: CircularProgressIndicator(
            color: backgroundColor,
          ));
        }
            
        if (controller.hasError.value) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.errorColor, fontSize: 18),
            ),
          ));
        }
            
        final course = controller.course.value;
        if (course == null) return const SizedBox();
            
      return Column(
        children: [
          // Course Header Container
          Container(
            height: 250,
            width: double.infinity,
            color: backgroundColor,
            child: Stack(
              children: [
                
                Center(
                  child: SvgPicture.asset(
                    course.thumbnail,
                    fit: BoxFit.cover,
                    height: 130,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha:0.8),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16, // Add right constraint
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7, // Limit width to 70% of screen
                    child: Text(
                      course.title,
                      style: const TextStyle(
                        color: AppColors.textColorLight,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2, // Limit to 2 lines
                      overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                    ),
                  ),
                ),
                // Back Button
                Positioned(
                    top : 30,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textColorLight,
                      size: 24,
                      
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
              ],
            ),
          ),
            
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Text(
                      course.description,
                      style: const TextStyle(
                        color: AppColors.textColorLight,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
            
                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(Icons.star, '${course.rating}', 'Rating'),
                        _buildStat(Icons.timer, course.durationText, 'Duration'),
                        _buildStat(Icons.library_books, '${course.totalLessons}', 'Lessons'),
                      ],
                    ),
                    const SizedBox(height: 24),
            
                    // Access Information
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bottomBarColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (course.type == CourseType.hard) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\$${course.price}',
                                  style: const TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'or ${course.points} points',
                                  style: const TextStyle(
                                    color: AppColors.textColorInactive,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor.withValues(alpha:0.1),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                // todo: Implement enrollment
                              },
                              child: const Text(
                                'Enroll Now',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ] else ...[
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withValues(alpha:0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.stars_rounded,
                                      color: AppColors.primaryColor,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '+${course.points}',
                                              style: const TextStyle(
                                                color: AppColors.primaryColor,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Text(
                                              'POINTS',
                                              style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'Complete all lessons to earn points',
                                          style: TextStyle(
                                            color: AppColors.textColorInactive,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
            
                    // Lessons Header
                    const Text(
                      'Course Content',
                      style: TextStyle(
                        color: AppColors.textColorLight,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
            
                    // Lessons List
                    ...course.lessons.map((lesson) => LessonCard(
                          lesson: lesson,
                          onTap: () => controller.startLesson(lesson),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
            }));
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textColorLight,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textColorInactive,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
