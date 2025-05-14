
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/config/env_config.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/core/utils/error_helper.dart';
import 'package:skillzone/features/courses/controllers/courses_controller.dart';
import 'package:skillzone/features/courses/models/course.dart';
import 'package:skillzone/features/courses/models/course_type.dart';
import 'package:skillzone/features/courses/models/lesson.dart';
import 'package:skillzone/features/points/services/user_points_service.dart';

class InventoryController extends GetxController {
  // Tab selection (0 for Liked, 1 for Enrolled)
  final selectedTab = 0.obs;
  
  // List of enrolled course IDs (will be populated from API in real app)
  final enrolledCourseIds = <String>[].obs;
  
  // Map to track completed lessons by course ID and lesson ID
  // Format: {courseId: {lessonId: isCompleted}}
  final completedLessons = <String, RxMap<String, bool>>{}.obs;
  
  // Map to track course progress by course ID
  // Format: {courseId: progressPercentage}
  final courseProgress = <String, RxDouble>{}.obs;
  
  // Reference to the courses controller
  final CoursesController _coursesController = Get.find<CoursesController>();
  
  @override
  void onInit() {
    super.onInit();
    // Load enrolled courses (dummy data for now)
    loadEnrolledCourses();
    // Initialize progress tracking
    _initializeProgressTracking();
  }
  
  void changeTab(int index) {
    selectedTab.value = index;
  }
  
  // Load enrolled courses from API
  Future<void> loadEnrolledCourses() async {
    try {
      final response = await EnvConfig.apiService.get(EnvConfig.unlockedCourses);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.body['data']['courses'];
        enrolledCourseIds.assignAll(data.map((course) => course['id'].toString()).toList());
        log("DEBUG: Enrolled courses loaded: ${enrolledCourseIds.length}");
      } else {
        throw 'Failed to load enrolled courses: ${response.statusCode}';
      }
    } catch (e) {
      log('DEBUG: Error loading enrolled courses: $e');
    }
  }
  
  // Initialize progress tracking for enrolled courses
  void _initializeProgressTracking() {



    for (final courseId in enrolledCourseIds) {
      // Get course to access its lessons
      final course = _getCourseById(courseId);
      if (course != null) {

        
        // Initialize lesson completion map for this course if not exists
        if (!completedLessons.containsKey(courseId)) {
          completedLessons[courseId] = RxMap<String, bool>();

        }
        
        // Initialize each lesson as not completed
        for (final lesson in course.lessons) {
          completedLessons[courseId]![lesson.id] = false;

        }
        
        // Initialize course progress
        _updateCourseProgress(courseId);

      } else {

      }
    }
  }
  
  // Get enrolled courses by looking up IDs in the courses controller
  List<Course> get enrolledCourses {
    final allCourses = [..._coursesController.softSkillsCourses, ..._coursesController.hardSkillsCourses];
    return allCourses.where((course) => enrolledCourseIds.contains(course.id)).map((course) {
      // Add progress information to each course
      return course.copyWith(
        // progress: courseProgress[course.id] ?? 0.0,
        lessons: course.lessons.map((lesson) {
          // Update lesson completion status
          final isCompleted = completedLessons[course.id]?[lesson.id] ?? false;
          return Lesson(
            id: lesson.id,
            title: lesson.title,
            number: lesson.number,
            duration: lesson.duration,
            isCompleted: isCompleted,
            videoUrl: lesson.videoUrl,
          );
        }).toList(),
      );
    }).toList();
  }
  
  // Helper to get a course by ID
  Course? _getCourseById(String courseId) {
    final allCourses = [..._coursesController.softSkillsCourses, ..._coursesController.hardSkillsCourses];
    return allCourses.firstWhereOrNull((course) => course.id == courseId);
  }
  
  // Mark a lesson as completed
  void markLessonAsCompleted(String courseId, String lessonId) {

    
    // Ensure maps are initialized
    if (!completedLessons.containsKey(courseId)) { 

      completedLessons[courseId] = <String, bool>{}.obs;
    }
    
    // Skip if already completed
    if (completedLessons[courseId]?[lessonId] == true) {

      Get.back();
      return;
    }
    
    // Mark lesson as completed
    completedLessons[courseId]![lessonId] = true;

    
    // Update course progress
    final previousProgress = courseProgress[courseId]?.value ?? 0.0;
    _updateCourseProgress(courseId);
    final newProgress = courseProgress[courseId]?.value ?? 0.0;
    
    // Get the course to check its type
    final course = _getCourseById(courseId);
    
    // Check if this completion resulted in course completion
    if (newProgress == 1.0 && previousProgress < 1.0 && course != null) {
      // Course just completed
      if (course.type == CourseType.soft) {
        // Award points for completing soft skill course
        final pointsService = Get.find<UserPointsService>();
        pointsService.addPoints(course.points);
        
        // Show points earned message
        Get.snackbar(
          'Points Earned',
          'You earned ${course.points} points for completing this course!',
          backgroundColor: AppColors.primaryColor,
          colorText: AppColors.backgroundColor,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        );
      }
    }
    
    // Navigate back
    Get.back();
    
    // Show success message
    Get.snackbar(
      'Lesson Completed',
      'Great job! You\'ve completed this lesson.',
      backgroundColor: AppColors.primaryColor,
      colorText: AppColors.backgroundColor,
      margin: const EdgeInsets.all(16),
    );
  }
  
  // Calculate and update course progress
  void _updateCourseProgress(String courseId) {

    
    final course = _getCourseById(courseId);
    if (course == null) {

      if (!courseProgress.containsKey(courseId)) {
        courseProgress[courseId] = 0.0.obs;
      } else {
        courseProgress[courseId]!.value = 0.0;
      }
      return;
    }
    

    
    // Ensure the completedLessons map is initialized for this course
    if (!completedLessons.containsKey(courseId)) {

      completedLessons[courseId] = <String, bool>{}.obs;
    }
    
    // Count completed lessons
    int completedCount = 0;
    for (final lesson in course.lessons) {
      if (completedLessons[courseId]?[lesson.id] == true) {
        completedCount++;

      } else {

      }
    }
    

    
    // Calculate progress percentage (handle division by zero)
    double progress = 0.0;
    if (course.lessons.isNotEmpty) {
      progress = completedCount / course.lessons.length;
    }
    

    
    // Update the reactive progress value
    if (!courseProgress.containsKey(courseId)) {
      courseProgress[courseId] = progress.obs;
    } else {
      courseProgress[courseId]!.value = progress;
    }
  }
  
  // Handle course enrollment with points or payment
  Future<bool> enrollInCourse(String courseId) async {
 
    
    // Check if already enrolled
    if (enrolledCourseIds.contains(courseId)) {
 
      Get.snackbar(
        'Already Enrolled',
        'You are already enrolled in this course',
        backgroundColor: AppColors.errorColor,
        colorText: AppColors.backgroundColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return true;
    }
    
    // Get the course
    final course = _getCourseById(courseId);
    if (course == null) {
      Get.snackbar(
        'Error',
        'Course not found',
        backgroundColor: AppColors.errorColor,
        colorText: AppColors.backgroundColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return false;
    }
    
 
    final pointsService = Get.find<UserPointsService>();
    
    if (course.type == CourseType.hard) {
 
      // Show dialog to choose payment method
      final payWithPoints = await _showPaymentChoiceDialog(course);
 
      
      if (payWithPoints == null) {
        // User cancelled
 
        return false;
      } else if (payWithPoints) {
        // User chose to pay with points
 
        if (!pointsService.hasEnoughPoints(course.points)) {
 
          Future.delayed(Duration.zero, () {Get.snackbar(
            'Not Enough Points',
            'You need ${course.points} points to unlock this course',
            backgroundColor: AppColors.errorColor,
            colorText: AppColors.backgroundColor,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
          );});
          return false;
        }
        
        // Send Unlock course request to API
        try {
          final response = await EnvConfig.apiService.post(
            EnvConfig.unlockCourse(courseId),
            {},
          );
          
          if (response.statusCode != 200) {
            throw 'Failed to unlock course: ${response.body}';
          }
          log('DEBUG: Unlock course response: ${response.body}');
          // Update user points in the service and storage
          final remainingPoints = response.body['data']['points_remaining'];
          await pointsService.updatePoints(remainingPoints);
          log('DEBUG: Updated user points: $remainingPoints');
        } catch (e) {
          log('DEBUG: Error unlocking course: $e');
          ErrorHelper.showError(
            title: 'Error',
            message: 'Failed to unlock course: $e',
          );
        }
 
      } else {
        Future.delayed(Duration.zero, (){Get.snackbar(
          'Payment Not Available',
          'Payment functionality is not available in this demo',
          backgroundColor: AppColors.errorColor,
          colorText: AppColors.backgroundColor,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );});
        // User chose to pay with money - show payment not available message
 
        return false;
      }
    } else {
      // Soft skill course - free to enroll, will earn points upon completion
      // Send unlock request to api
      try {
          final response = await EnvConfig.apiService.post(
            EnvConfig.unlockCourse(courseId),
            {},
          );
          
          if (response.statusCode != 200) {
            throw 'Failed to unlock course: ${response.body}';
          }
          log('DEBUG: Unlock course response: ${response.body}');
        } catch (e) {
          log('DEBUG: Error unlocking course: $e');
          ErrorHelper.showError(
            title: 'Error',
            message: 'Failed to unlock course: $e',
          );
        }
    }
    
    // If we got here, enrollment is successful
 
    enrolledCourseIds.add(courseId);
    
    // Initialize progress tracking for this course
 
    completedLessons[courseId] = <String, bool>{}.obs;
    for (final lesson in course.lessons) {
      completedLessons[courseId]![lesson.id] = false;
 
    }
    courseProgress[courseId] = 0.0.obs;
    
    Get.snackbar(
      'Success',
      'You have enrolled in this course',
      backgroundColor: AppColors.primaryColor,
      colorText: AppColors.backgroundColor,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
    
 
    return true;
  }

  // Helper method to show payment choice dialog
  Future<bool?> _showPaymentChoiceDialog(Course course) async {
    return await Get.dialog<bool>(
      Dialog(
        backgroundColor: AppColors.bottomBarColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button (X) at top right
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.textColorLight,
                  ),
                  onPressed: () => Get.back(result: null),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              
              // Title
              const Text(
                "How would you like to pay?",
                style: TextStyle(
                  color: AppColors.textColorLight,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              
              // Money button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    foregroundColor: AppColors.backgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Get.back(result: false),
                  child: Text(
                    'Pay \$${course.price}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              
              // Points button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.backgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Get.back(result: true),
                  child: Text(
                    'Use ${course.points} points',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
  
  // Unenroll from a course
  void unenrollFromCourse(String courseId) {
    enrolledCourseIds.remove(courseId);
    completedLessons.remove(courseId);
    courseProgress.remove(courseId);
    
    // In a real app, this would make an API call
    // dio.delete('/api/courses/$courseId/enroll');
  }
  
  // Get progress for a specific course
  double getCourseProgress(String courseId) {
    if (!courseProgress.containsKey(courseId)) {
      return 0.0;
    }
    return courseProgress[courseId]!.value;
  }
  
  // Check if a lesson is completed
  bool isLessonCompleted(String courseId, String lessonId) {
    return completedLessons[courseId]?[lessonId] ?? false;
  }
}
