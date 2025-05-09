import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/inventory/controllers/inventory_controller.dart';
import '../controllers/course_details_controller.dart';
import '../models/course_type.dart';
import '../widgets/lesson_card.dart';

class CourseDetailsPage extends StatelessWidget {
  final controller = Get.put(CourseDetailsController());
  final InventoryController inventoryController = Get.find<InventoryController>();
  final Color backgroundColor;
  final bool isEnrolled;

  CourseDetailsPage({super.key})
      : backgroundColor = (Get.arguments as Map)['backgroundColor'] as Color,
        isEnrolled = (Get.arguments as Map)['isEnrolled'] as bool? ?? false {
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
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textColorLight,
                  size: 24,
                ),
                onPressed: () => Get.back(),
              ),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.errorColor, fontSize: 18),
                ),
              ),
            ),
          );
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
                        Colors.black.withValues(alpha: 0.8),
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
                  top: 30,
                  left: 0,
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
            
                    // Access Information - Show only if not enrolled
                    if (!isEnrolled) ...[
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
                                  backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
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
                                  // Enroll in the course
                                  Get.find<InventoryController>().enrollInCourse(course.id);
                                  // No need to show a snackbar here as it's handled in the controller
                                  // Only go back if this is a new enrollment
                                  if (!Get.find<InventoryController>().enrolledCourseIds.contains(course.id)) {
                                    Get.back(); // Return to previous screen
                                  }
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
                                        color: AppColors.primaryColor.withValues(alpha: 0.1),
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
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
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
                                  // Enroll in the course
                                  Get.find<InventoryController>().enrollInCourse(course.id);
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
                            ],
                          ],
                        ),
                      ),
                    ] else ...[
                      // Show progress if enrolled
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.bottomBarColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Progress',
                              style: TextStyle(
                                color: AppColors.textColorLight,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Get progress directly from inventory controller
                            Obx(() {
                              final progress = Get.find<InventoryController>().getCourseProgress(course.id);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: AppColors.backgroundColor,
                                    valueColor: AlwaysStoppedAnimation<Color>(backgroundColor),
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${(progress * 100).toInt()}% Complete',
                                    style: const TextStyle(
                                      color: AppColors.textColorInactive,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
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
                          onTap: isEnrolled 
                              ? () => controller.startLesson(course.id, lesson)
                              : () => _showEnrollPrompt(context, course),
                          isLocked: !isEnrolled,
                          courseId: course.id,
                        )),

                    // Add Quiz Button (only show if enrolled)
                    if (isEnrolled) ...[
                      const SizedBox(height: 32),
                      
                      // Quiz Button
                      Obx(() {
                        final progress = Get.find<InventoryController>().getCourseProgress(course.id);
                        final allLessonsCompleted = progress >= 1.0;
                        
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: (){
                              if (allLessonsCompleted) {
                                Get.toNamed(
                                  AppRoutes.quiz, 
                                  arguments: {'courseId': course.id}
                                );
                              }else{
                                Get.snackbar(
                                  'Complete All Lessons',
                                  'You need to complete all lessons before taking the quiz',
                                  backgroundColor: AppColors.errorColor,
                                  colorText: AppColors.backgroundColor,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: const EdgeInsets.all(16),
                                );
                              }
                            },
                            icon: Icon(
                              Icons.quiz_rounded,
                              color: allLessonsCompleted ? AppColors.backgroundColor : AppColors.textColorInactive,
                            ),
                            label: Text(
                              'Take Quiz',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: allLessonsCompleted ? AppColors.backgroundColor : AppColors.textColorInactive,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: allLessonsCompleted 
                                  ? AppColors.primaryColor 
                                  : AppColors.bottomBarColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: allLessonsCompleted ? 2 : 0,
                            ),
                          ),
                        );
                      }),
                      
                      // Add a message explaining why the button is disabled
                      Obx(() {
                        final progress = Get.find<InventoryController>().getCourseProgress(course.id);
                        final allLessonsCompleted = progress >= 1.0;
                        
                        if (!allLessonsCompleted) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Complete all lessons to unlock the quiz',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textColorInactive,
                                fontSize: 14,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                      
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      );
            }));
  }

  void _showEnrollPrompt(BuildContext context, course) {
    // Check if already enrolled first
    if (Get.find<InventoryController>().enrolledCourseIds.contains(course.id)) {
      Get.snackbar(
        'Already Enrolled',
        'You are already enrolled in this course',
        backgroundColor: AppColors.secondaryColor,
        colorText: AppColors.backgroundColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.bottomBarColor,
        title: const Text(
          'Enroll Required',
          style: TextStyle(
            color: AppColors.textColorLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'You need to enroll in this course to access the lessons.',
          style: TextStyle(
            color: AppColors.textColorLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textColorInactive,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            onPressed: () {
              Get.back(); // Close dialog
              // Enroll in the course
              Get.find<InventoryController>().enrollInCourse(course.id);
            },
            child: const Text('Enroll Now'),
          ),
        ],
      ),
    );
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
