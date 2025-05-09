import 'dart:ui';

import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/core/utils/error_helper.dart';
import '../models/course.dart';
import '../models/course_type.dart';
import '../models/lesson.dart';

class CoursesController extends GetxController {
  // Observable lists for both course types
  final softSkillsCourses = <Course>[].obs;
  final hardSkillsCourses = <Course>[].obs;

  // Add new observable for popular courses
  final _popularCourses = <Course>[].obs;
  
  // Add new observable for teacher's uploaded courses
  final _teacherCourses = <Course>[].obs;

  // Add workers as class properties
  late Worker _softSkillsWorker;
  late Worker _hardSkillsWorker;

  // Loading states
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Section colors for UI
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
      AppColors.courseColor6,
      AppColors.courseColor5,
      AppColors.courseColor1,
      AppColors.courseColor4,
      AppColors.courseColor2,
      AppColors.courseColor3,
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
    // Initialize workers
    _softSkillsWorker = ever(softSkillsCourses, (_) => _updatePopularCourses());
    _hardSkillsWorker = ever(hardSkillsCourses, (_) => _updatePopularCourses());
    loadCourses();
  }

  @override
  void onClose() {
    // Dispose of workers
    _softSkillsWorker.dispose();
    _hardSkillsWorker.dispose();
    super.onClose();
  }

  // Get freemium courses (free soft skills)
  List<Course> get freemiumCourses => softSkillsCourses;

  // Get premium courses (paid hard skills)
  List<Course> get premiumCourses => hardSkillsCourses;

  // Get popular courses (most rated courses from both categories)
  List<Course> get popularCourses => _popularCourses;
  
  // Get teacher's uploaded courses
  List<Course> get teacherCourses => _teacherCourses;

  // Add method to update popular courses
  void _updatePopularCourses() {
    final allCourses = [...softSkillsCourses, ...hardSkillsCourses];
    allCourses.sort((a, b) => b.rating.compareTo(a.rating));
    _popularCourses.assignAll(allCourses.take(5));
  }

  // Load courses from API
  Future<void> loadCourses() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      _loadDummyData();
      await Future.delayed(
          const Duration(seconds: 5)); // Simulate network delay
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

  // Get user's liked courses
  List<Course> get likedCourses => [...softSkillsCourses, ...hardSkillsCourses]
      .where((course) => course.isLiked.value)
      .toList();

  // Helper function to get random thumbnail
  String getRandomThumbnail() {
    return courseThumbnails[
        DateTime.now().microsecond % courseThumbnails.length];
  }

  // Private method to load dummy data
  void _loadDummyData() {
    softSkillsCourses.assignAll([
      Course(
        id: 's1',
        title: 'Effective Communication Skills',
        description:
            'Master the art of clear and impactful communication in professional settings. Learn key strategies for better verbal and non-verbal communication.',
        rating: 4.5,
        duration: const Duration(hours: 2, minutes: 30),
        type: CourseType.soft,
        points: 100,
        thumbnail: getRandomThumbnail(),
        lessons: _getDummyLessonsForCourse('s1'),
      ),
      Course(
        id: 's2',
        title: 'Leadership Fundamentals',
        description:
            'Develop essential leadership skills and learn how to inspire and guide teams effectively. Perfect for aspiring managers and team leaders.',
        rating: 4.8,
        duration: const Duration(hours: 3),
        type: CourseType.soft,
        points: 150,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 's3',
        title: 'Time Management Mastery',
        description:
            'Learn proven techniques to maximize productivity and achieve better work-life balance through effective time management strategies.',
        rating: 4.6,
        duration: const Duration(hours: 1, minutes: 45),
        type: CourseType.soft,
        points: 80,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 's4',
        title: 'Emotional Intelligence at Work',
        description:
            'Enhance your emotional intelligence to build better relationships and navigate workplace dynamics more effectively.',
        rating: 4.9,
        duration: const Duration(hours: 2, minutes: 15),
        type: CourseType.soft,
        points: 120,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 's5',
        title: 'Public Speaking Excellence',
        description:
            'Overcome stage fright and master the art of public speaking. Learn to deliver compelling presentations with confidence.',
        rating: 4.7,
        duration: const Duration(hours: 4),
        type: CourseType.soft,
        points: 200,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 's6',
        title: 'Conflict Resolution Strategies',
        description:
            'Learn effective techniques for managing and resolving workplace conflicts. Transform challenges into opportunities for growth.',
        rating: 4.4,
        duration: const Duration(hours: 2),
        type: CourseType.soft,
        points: 100,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 's7',
        title: 'Team Building Essentials',
        description:
            'Discover proven methods for building and maintaining high-performing teams. Foster collaboration and team spirit.',
        rating: 4.3,
        duration: const Duration(hours: 1, minutes: 30),
        type: CourseType.soft,
        points: 75,
        thumbnail: getRandomThumbnail(),
      ),
    ]);

    hardSkillsCourses.assignAll([
      Course(
        id: 'h1',
        title: 'Flutter Advanced Concepts',
        description:
            'Deep dive into advanced Flutter development concepts including state management, custom widgets, and performance optimization.',
        rating: 4.7,
        duration: const Duration(hours: 8),
        type: CourseType.hard,
        points: 500,
        price: 199,
        thumbnail: getRandomThumbnail(),
        lessons: _getDummyLessonsForCourse('h1'),
      ),
      Course(
        id: 'h2',
        title: 'AWS Cloud Architecture',
        description:
            'Master cloud computing with AWS. Learn to design, deploy and manage scalable cloud infrastructure.',
        rating: 4.6,
        duration: const Duration(hours: 10),
        type: CourseType.hard,
        price: 99,
        points: 400,
        thumbnail: getRandomThumbnail(),
      ),
      Course(
        id: 'h3',
        title: 'Machine Learning Fundamentals',
        description:
            'Introduction to machine learning algorithms, data preprocessing, and model training. Includes hands-on projects.',
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
        description:
            'Learn blockchain technology and smart contract development. Build decentralized applications from scratch.',
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
        description:
            'Master advanced Python concepts including metaclasses, decorators, and concurrent programming.',
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
        description:
            'Comprehensive guide to network security, threat detection, and security best practices.',
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
        description:
            'Learn modern DevOps practices, continuous integration, and deployment automation techniques.',
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
        description:
            'Build cross-platform mobile applications using React Native. Includes real-world project development.',
        rating: 4.5,
        duration: const Duration(hours: 10),
        type: CourseType.hard,
        price: 89,
        points: 400,
        thumbnail: getRandomThumbnail(),
      ),
      
    ]);


    // Add some dummy teacher courses
    _teacherCourses.assignAll([
      Course(
        id: 't1',
        title: 'Introduction to Flutter',
        description: 'Learn the basics of Flutter development and build your first app.',
        rating: 4.2,
        duration: const Duration(hours: 5, minutes: 30),
        type: CourseType.hard,
        price: 79,
        points: 300,
        thumbnail: getRandomThumbnail(),
        lessons: [
          Lesson(
            id: 'l1',
            title: 'Getting Started with Flutter',
            number: 1,
            duration: const Duration(minutes: 45),
            videoUrl: 'https://example.com/videos/flutter-intro',
          ),
          Lesson(
            id: 'l2',
            title: 'Building Your First Widget',
            number: 2,
            duration: const Duration(minutes: 60),
            videoUrl: 'https://example.com/videos/flutter-widgets',
          ),
        ],
      ),
      Course(
        id: 't2',
        title: 'Effective Team Communication',
        description: 'Master the art of communication within teams for better collaboration.',
        rating: 4.8,
        duration: const Duration(hours: 3, minutes: 15),
        type: CourseType.soft,
        points: 150,
        thumbnail: getRandomThumbnail(),
        lessons: [
          Lesson(
            id: 'l1',
            title: 'Understanding Communication Styles',
            number: 1,
            duration: const Duration(minutes: 30),
            videoUrl: 'https://example.com/videos/comm-styles',
          ),
          Lesson(
            id: 'l2',
            title: 'Active Listening Techniques',
            number: 2,
            duration: const Duration(minutes: 45),
            videoUrl: 'https://example.com/videos/active-listening',
          ),
        ],
      ),
    ]);

  }

  Future<void> uploadCourse({
    required String title,
    required String description,
    required Duration duration,
    int? price,
    required int points,
    CourseType type = CourseType.hard,
    List<Lesson> lessons = const [],
  }) async {
    try {
      isLoading.value = true;
      
      // Create new course
      final newCourse = Course(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        rating: 0.0,
        duration: duration,
        type: type,
        price: price,
        points: points,
        lessons: lessons,
        thumbnail: getRandomThumbnail()
      );
      
      // Add to appropriate category list
      if (type == CourseType.hard) {
        hardSkillsCourses.add(newCourse);
      } else {
        softSkillsCourses.add(newCourse);
      }
      
      // Add to teacher's courses
      _teacherCourses.add(newCourse);
      
      Get.back();
      Get.snackbar(
        'Success',
        'Course uploaded successfully',
        backgroundColor: AppColors.primaryColor,
        colorText: AppColors.backgroundColor,
      );
    } catch (e) {
      ErrorHelper.showError(
        title: 'Error',
        message: 'Failed to upload course: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Add a method to get dummy lessons for a course
  List<Lesson> _getDummyLessonsForCourse(String courseId) {
    switch (courseId) {
      case 's1': // Effective Communication Skills
        return [
          Lesson(
            number: 1,
            id: 's1l1',
            title: 'Understanding Communication Basics',
            duration: const Duration(minutes: 30),
            videoUrl: 'https://drive.google.com/file/d/1WRuqlqEFj4vorPakJ46yaVASOfF2UWVi/view?usp=sharing',
            isCompleted: true,
          ),
          Lesson(
            number: 2,
            id: 's1l2',
            title: 'Verbal Communication Techniques',
            duration: const Duration(minutes: 45),
            videoUrl: 'https://drive.google.com/file/d/1WRuqlqEFj4vorPakJ46yaVASOfF2UWVi/view?usp=sharing',
            isCompleted: true,
          ),
          Lesson(
            number: 3,
            id: 's1l3',
            title: 'Non-verbal Communication',
            duration: const Duration(minutes: 35),
            videoUrl: 'https://drive.google.com/file/d/1WRuqlqEFj4vorPakJ46yaVASOfF2UWVi/view?usp=sharing',
            isCompleted: true,
          ),
          Lesson(
            number: 4,
            id: 's1l4',
            title: 'Active Listening Skills',
            duration: const Duration(minutes: 40),
            videoUrl: 'https://drive.google.com/file/d/1WRuqlqEFj4vorPakJ46yaVASOfF2UWVi/view?usp=sharing',
            isCompleted: true,
          ),
        ];
      case 'h1': // Flutter Advanced Concepts
        return [
          Lesson(
            number: 1,
            id: 'h1l1',
            title: 'Advanced State Management',
            duration: const Duration(minutes: 60),
            videoUrl: 'https://drive.google.com/file/d/1WRuqlqEFj4vorPakJ46yaVASOfF2UWVi/view?usp=sharing',
            isCompleted: false,
          ),
          Lesson(
            number: 2,
            id: 'h1l2',
            title: 'Custom Widgets and Inheritance',
            duration: const Duration(minutes: 55),
            videoUrl: 'https://drive.google.com/file/d/1WRuqlqEFj4vorPakJ46yaVASOfF2UWVi/view?usp=sharing',
            isCompleted: false,
          ),
          Lesson(
            number: 3,
            id: 'h1l3',
            title: 'Performance Optimization Techniques',
            duration: const Duration(minutes: 50),
            videoUrl: 'https://drive.google.com/file/d/1WRuqlqEFj4vorPakJ46yaVASOfF2UWVi/view?usp=sharing',
            isCompleted: false,
          ),
          Lesson(
            number: 4,
            id: 'h1l4',
            title: 'Advanced Animation and Gestures',
            duration: const Duration(minutes: 65),
            videoUrl: 'https://drive.google.com/file/d/1WRuqlqEFj4vorPakJ46yaVASOfF2UWVi/view?usp=sharing',
            isCompleted: false,
          ),
        ];
      default:
        return [];
    }
  }
}
