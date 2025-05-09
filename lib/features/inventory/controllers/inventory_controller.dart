import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/courses/controllers/courses_controller.dart';
import 'package:skillzone/features/courses/models/course.dart';
import 'package:skillzone/features/courses/models/lesson.dart';

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
  
  // This would fetch from API in a real app
  void loadEnrolledCourses() {
    // For demo purposes, we'll use some dummy enrolled course IDs
    // In a real app, this would be an API call
    enrolledCourseIds.assignAll(['h1', 's1']);
  }
  
  // Initialize progress tracking for enrolled courses
  void _initializeProgressTracking() {
    log('DEBUG: Initializing progress tracking for enrolled courses');
    log('DEBUG: Enrolled course IDs: $enrolledCourseIds');

    for (final courseId in enrolledCourseIds) {
      // Get course to access its lessons
      final course = _getCourseById(courseId);
      if (course != null) {
        log('DEBUG: Initializing progress for course: ${course.title}');
        
        // Initialize lesson completion map for this course if not exists
        if (!completedLessons.containsKey(courseId)) {
          completedLessons[courseId] = RxMap<String, bool>();
          log('DEBUG: Created completedLessons map for courseId: $courseId');
        }
        
        // Initialize each lesson as not completed
        for (final lesson in course.lessons) {
          completedLessons[courseId]![lesson.id] = false;
          log('DEBUG: Initialized lesson ${lesson.id} as not completed');
        }
        
        // Initialize course progress
        _updateCourseProgress(courseId);
        log('DEBUG: Initial progress for course $courseId: ${courseProgress[courseId]}');
      } else {
        log('ERROR: Could not find course with ID: $courseId');
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
    log('DEBUG: markLessonAsCompleted called with courseId: $courseId, lessonId: $lessonId');
    
    // Ensure maps are initialized
    if (!completedLessons.containsKey(courseId)) { 
      log('DEBUG: Initializing completedLessons map for courseId: $courseId');
      completedLessons[courseId] = <String, bool>{}.obs;
    }
    
    // Log current completion status
    final previousStatus = completedLessons[courseId]?[lessonId];
    log('DEBUG: Previous completion status for lesson $lessonId: $previousStatus');
    
    // Mark lesson as completed
    completedLessons[courseId]![lessonId] = true;
    log('DEBUG: Marked lesson $lessonId as completed');
    
    // Log the updated completedLessons map for this course
    log('DEBUG: Updated completedLessons for courseId $courseId: ${completedLessons[courseId]}');
    
    // Update course progress
    final previousProgress = courseProgress[courseId];
    log('DEBUG: Previous progress for course $courseId: $previousProgress');
    
    _updateCourseProgress(courseId);
    
    // Log the new progress
    final newProgress = courseProgress[courseId];
    log('DEBUG: New progress for course $courseId: $newProgress');
    
    log('DEBUG: markLessonAsCompleted completed successfully');
                          
    log('DEBUG: Showing snackbar and navigating back');
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
    log('DEBUG: _updateCourseProgress called for courseId: $courseId');
    
    final course = _getCourseById(courseId);
    if (course == null) {
      log('ERROR: Course not found with ID: $courseId');
      if (!courseProgress.containsKey(courseId)) {
        courseProgress[courseId] = 0.0.obs;
      } else {
        courseProgress[courseId]!.value = 0.0;
      }
      return;
    }
    
    log('DEBUG: Course found: ${course.title}, with ${course.lessons.length} lessons');
    
    // Ensure the completedLessons map is initialized for this course
    if (!completedLessons.containsKey(courseId)) {
      log('DEBUG: Initializing completedLessons map for courseId: $courseId');
      completedLessons[courseId] = <String, bool>{}.obs;
    }
    
    // Count completed lessons
    int completedCount = 0;
    for (final lesson in course.lessons) {
      if (completedLessons[courseId]?[lesson.id] == true) {
        completedCount++;
        log('DEBUG: Lesson ${lesson.id} is completed');
      } else {
        log('DEBUG: Lesson ${lesson.id} is not completed');
      }
    }
    
    log('DEBUG: Completed lessons count: $completedCount out of ${course.lessons.length}');
    
    // Calculate progress percentage (handle division by zero)
    double progress = 0.0;
    if (course.lessons.isNotEmpty) {
      progress = completedCount / course.lessons.length;
    }
    
    log('DEBUG: Calculated progress: $progress');
    
    // Update the reactive progress value
    if (!courseProgress.containsKey(courseId)) {
      courseProgress[courseId] = progress.obs;
    } else {
      courseProgress[courseId]!.value = progress;
    }
  }
  
  // Enroll in a course
  void enrollInCourse(String courseId) {
    if (!enrolledCourseIds.contains(courseId)) {
      enrolledCourseIds.add(courseId);
      
      // Initialize progress tracking for this course
      final course = _getCourseById(courseId);
      if (course != null) {
        completedLessons[courseId] = <String, bool>{}.obs;
        for (final lesson in course.lessons) {
          completedLessons[courseId]![lesson.id] = false;
        }
        courseProgress[courseId] = 0.0.obs;
      }
    }
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
