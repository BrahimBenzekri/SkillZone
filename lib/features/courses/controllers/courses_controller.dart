import 'dart:ui';

import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import '../models/course.dart';
import '../models/course_type.dart';

class CoursesController extends GetxController {
  // Observable lists for both course types
  final softSkillsCourses = <Course>[].obs;
  final hardSkillsCourses = <Course>[].obs;

  // Loading states
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Course colors for each section
  final Map<String, List<Color>> sectionColors = {
    'popular': [
      AppColors.courseColor1,
      AppColors.courseColor3,
      AppColors.courseColor5,
      AppColors.courseColor2,
      AppColors.courseColor4,
    ],
    'hard': [
      AppColors.courseColor2,
      AppColors.courseColor4,
      AppColors.courseColor6,
      AppColors.courseColor1,
      AppColors.courseColor3,
      AppColors.courseColor5,
    ],
    'soft': [
      AppColors.courseColor3,
      AppColors.courseColor5,
      AppColors.courseColor1,
      AppColors.courseColor4,
      AppColors.courseColor2,
      AppColors.courseColor6,
    ],
  };

  // Courses Thumbnails
  static const List<String> courseThumbnails = [
    'lib/assets/svgs/course1.svg',
    'lib/assets/svgs/course2.svg',
    'lib/assets/svgs/course3.svg',
    'lib/assets/svgs/course4.svg',
    'lib/assets/svgs/course5.svg',
    'lib/assets/svgs/course6.svg',
  ];

  @override
  void onInit() {
    super.onInit();
    loadCourses();
  }

  // Get freemium courses (free soft skills)
  List<Course> get freemiumCourses => softSkillsCourses;

  // Get premium courses (paid hard skills)
  List<Course> get premiumCourses => hardSkillsCourses;

  // Get popular courses (most rated courses from both categories)
  List<Course> get popularCourses {
    final allCourses = [...softSkillsCourses, ...hardSkillsCourses];
    allCourses.sort((a, b) => b.rating.compareTo(a.rating));
    return allCourses.take(5).toList(); // Return top 5 rated courses
  }

  // Load courses from API
  Future<void> loadCourses() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      await Future.delayed(const Duration(seconds: 1));
      _loadDummyData();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load courses: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle course like status
  void toggleLike(Course course) {
    course.isLiked.toggle();
    // When backend is ready:
    // dio.post('/api/courses/${course.id}/toggle-like');
  }

  // Filter courses by search term
  List<Course> searchCourses(String query) {
    final lowercaseQuery = query.toLowerCase();
    return [...softSkillsCourses, ...hardSkillsCourses]
        .where((course) => course.title.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  // Get user's liked courses
  List<Course> get likedCourses => [...softSkillsCourses, ...hardSkillsCourses]
      .where((course) => course.isLiked.value)
      .toList();

  // Private method to load dummy data
  void _loadDummyData() {
    // Helper function to get random thumbnail
    String getRandomThumbnail() {
      return courseThumbnails[
          DateTime.now().microsecond % courseThumbnails.length];
    }

    softSkillsCourses.value = [
      Course(
        id: 's1',
        title: 'Effective Communication Skills',
        rating: 4.5,
        duration: const Duration(hours: 2, minutes: 30),
        type: CourseType.soft,
        points: 100,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 's2',
        title: 'Leadership Fundamentals',
        rating: 4.8,
        duration: const Duration(hours: 3),
        type: CourseType.soft,
        points: 150,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 's3',
        title: 'Time Management Mastery',
        rating: 4.6,
        duration: const Duration(hours: 1, minutes: 45),
        type: CourseType.soft,
        points: 80,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 's4',
        title: 'Emotional Intelligence at Work',
        rating: 4.9,
        duration: const Duration(hours: 2, minutes: 15),
        type: CourseType.soft,
        points: 120,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 's5',
        title: 'Public Speaking Excellence',
        rating: 4.7,
        duration: const Duration(hours: 4),
        type: CourseType.soft,
        points: 200,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 's6',
        title: 'Conflict Resolution Strategies',
        rating: 4.4,
        duration: const Duration(hours: 2),
        type: CourseType.soft,
        points: 100,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 's7',
        title: 'Team Building Essentials',
        rating: 4.3,
        duration: const Duration(hours: 1, minutes: 30),
        type: CourseType.soft,
        points: 75,
        thumbnail: getRandomThumbnail(),
      ),
    ];

    hardSkillsCourses.value = [
      Course(
        id: 'h1',
        title: 'Flutter Advanced Concepts',
        rating: 4.7,
        duration: const Duration(hours: 8),
        type: CourseType.hard,
        points: 500,
        price: 199,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 'h2',
        title: 'AWS Cloud Architecture',
        rating: 4.6,
        duration: const Duration(hours: 10),
        type: CourseType.hard,
        price: 99,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 'h3',
        title: 'Machine Learning Fundamentals',
        rating: 4.9,
        duration: const Duration(hours: 12),
        type: CourseType.hard,
        price: 149,
        points: 600,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 'h4',
        title: 'Blockchain Development',
        rating: 4.5,
        duration: const Duration(hours: 8),
        type: CourseType.hard,
        points: 800,
        price: 199,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 'h5',
        title: 'Advanced Python Programming',
        rating: 4.8,
        duration: const Duration(hours: 15),
        type: CourseType.hard,
        price: 129,
        points: 700,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 'h6',
        title: 'Cybersecurity Essentials',
        rating: 4.7,
        duration: const Duration(hours: 20),
        type: CourseType.hard,
        price: 199,
        points: 900,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 'h7',
        title: 'DevOps & CI/CD',
        rating: 4.6,
        duration: const Duration(hours: 16),
        type: CourseType.hard,
        points: 750,
        price: 149,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 'h8',
        title: 'React Native Masterclass',
        rating: 4.5,
        duration: const Duration(hours: 10),
        type: CourseType.hard,
        price: 89,
        points: 400,
        thumbnail: getRandomThumbnail(),
      ),
    ];
  }
}
