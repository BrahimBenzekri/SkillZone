import 'dart:developer';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/core/utils/error_helper.dart';
import 'package:skillzone/core/config/env_config.dart';
import '../models/course.dart';
import '../models/course_type.dart';
import '../models/lesson.dart';
import 'package:skillzone/features/auth/controllers/auth_controller.dart';

class CoursesController extends GetxController {
  // Observable lists for both course types
  final softSkillsCourses = <Course>[].obs;
  final hardSkillsCourses = <Course>[].obs;

  // Add new observable for popular courses
  final _popularCourses = <Course>[].obs;
  
  // Add new observable for teacher's uploaded courses
  final _teacherCourses = <Course>[].obs;

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
    loadCourses();
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
    log('DEBUG: Updating popular courses');
    final allCourses = [...softSkillsCourses, ...hardSkillsCourses];
    
    // Sort by rating (highest first)
    allCourses.sort((a, b) => b.rating.compareTo(a.rating));
    
    // Take top 5 or fewer if not enough courses
    final topCourses = allCourses.take(5).toList();
    log('DEBUG: Selected ${topCourses.length} popular courses');
    
    _popularCourses.assignAll(topCourses);
  }

  // Load courses from API
  Future<void> loadCourses() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      log('DEBUG: Loading courses from API');
      // Create GetConnect instance for API calls
      final connect = GetConnect();
      
      // Add auth token to headers if user is logged in
      final authController = Get.find<AuthController>();
      final token = authController.accessToken;
      log('DEBUG: Using access token: ${token != null ? 'Present' : 'Not present'}');
      
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };
      
      log('DEBUG: Sending API request to ${EnvConfig.getCourses}');
      
      // Properly await the API response
      final Response allCoursesResponse = await connect.get(
        EnvConfig.getCourses,
        headers: headers,
      );
      
      log('DEBUG: API response received with status: ${allCoursesResponse.statusCode}');
      
      // Ensure response is valid before processing
      if (allCoursesResponse.statusCode != 200) {
        log('ERROR: Failed to fetch courses: ${allCoursesResponse.statusCode}');
        throw 'Failed to fetch courses: ${allCoursesResponse.statusCode}';
      }
      
      // Validate response body exists
      if (allCoursesResponse.body == null) {
        log('ERROR: Empty response body');
        throw 'Empty response body';
      }
      
      log('DEBUG: Processing response body');
      
      // Safely extract courses data with null checks
      final data = allCoursesResponse.body['data'];
      if (data == null) {
        log('ERROR: Missing data field in response');
        throw 'Missing data field in response';
      }
      
      final List<dynamic> coursesData = data['courses'] ?? [];
      log('DEBUG: Extracted ${coursesData.length} courses from response');
      
      // Prepare temporary lists
      final tempSoftSkills = <Course>[];
      final tempHardSkills = <Course>[];
      
      // Process each course sequentially
      for (var i = 0; i < coursesData.length; i++) {
        final courseData = coursesData[i];
        log('DEBUG: Processing course ${i+1}/${coursesData.length}');
        
        try {
          // Ensure courseData is valid
          if (courseData == null) {
            log('ERROR: Null course data at index $i');
            continue;
          }
          
          log('DEBUG: Creating Course object from JSON');
          final course = Course.fromJson(courseData);
          log('DEBUG: Successfully created Course object: ${course.title}');
          
          // Create a new course with thumbnail set
          final courseWithThumbnail = course.copyWith(
            thumbnail: getRandomThumbnail()
          );
          
          // Classify by type
          if (courseWithThumbnail.type == CourseType.soft) {
            tempSoftSkills.add(courseWithThumbnail);
            log('DEBUG: Added to soft skills: ${courseWithThumbnail.title}');
          } else {
            tempHardSkills.add(courseWithThumbnail);
            log('DEBUG: Added to hard skills: ${courseWithThumbnail.title}');
          }

          log('DEBUG: Course attributes:');
          log('DEBUG: ID: ${courseWithThumbnail.id}');
          log('DEBUG: Title: ${courseWithThumbnail.title}');
          log('DEBUG: Description: ${courseWithThumbnail.description}');
          log('DEBUG: Rating: ${courseWithThumbnail.rating}');
          log('DEBUG: Duration: ${courseWithThumbnail.duration}');
          log('DEBUG: Type: ${courseWithThumbnail.type}');
          log('DEBUG: Price: ${courseWithThumbnail.price}');
          log('DEBUG: Points: ${courseWithThumbnail.points}');
          log('DEBUG: Thumbnail: ${courseWithThumbnail.thumbnail}');
          log('DEBUG: Number of lessons: ${courseWithThumbnail.lessons.length}');
        } catch (e) {
          log('ERROR: Failed to process course at index $i: $e');
          // Continue processing other courses
        }
      }
      
      log('DEBUG: Finished processing all courses');
      log('DEBUG: Soft skills: ${tempSoftSkills.length}, Hard skills: ${tempHardSkills.length}');
      
      // Update lists all at once to minimize reactivity triggers
      softSkillsCourses.assignAll(tempSoftSkills);
      hardSkillsCourses.assignAll(tempHardSkills);
      
      log('DEBUG: Course lists updated');
      
      // Update popular courses based on fetched data
      _updatePopularCourses();
      
      // If API returns empty data, use dummy data for development
      if (softSkillsCourses.isEmpty && hardSkillsCourses.isEmpty) {
        log('DEBUG: No courses received, loading dummy data');
        _loadDummyData();
      }
    } catch (e) {
      log('ERROR: Error loading courses: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to load courses: $e';
      // Load dummy data as fallback
      _loadDummyData();
    } finally {
      isLoading.value = false;
      log('DEBUG: Course loading completed');
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
    log('DEBUG: Loading dummy data');
    
    // Create temporary lists
    final tempSoftSkills = <Course>[];
    final tempHardSkills = <Course>[];
    
    // Add soft skills courses
    tempSoftSkills.addAll([
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

    // Add hard skills courses
    tempHardSkills.addAll([
      Course(
        id: 'h1',
        title: 'Flutter Advanced Concepts',
        description:
            'Deep dive into advanced Flutter development concepts including state management, custom widgets, and performance optimization.',
        rating: 4.7,
        duration: const Duration(hours: 8),
        type: CourseType.hard,
        points: 500,
        price: '199',
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
        price: '99',
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
        price: '149',
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
        price: '199',
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
        price: '129',
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
        price: '199',
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
        price: '149',
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
        price: '89',
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
        price: '79',
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
    String? price,
    required int points,
    CourseType type = CourseType.hard,
    List<Lesson> lessons = const [],
  }) async {
    try {
      isLoading.value = true;
      
      // Try to upload to API first
      await uploadCourseToApi(
        title: title,
        description: description,
        duration: duration,
        price: price,
        points: points,
        type: type,
        lessons: lessons,
      );
      
      // If API fails, fall back to local implementation
    } catch (e) {
      // Create new course locally
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
      
      // Update popular courses
      _updatePopularCourses();
      
      Get.back();
      Get.snackbar(
        'Success',
        'Course uploaded successfully (local only)',
        backgroundColor: AppColors.primaryColor,
        colorText: AppColors.backgroundColor,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Add method to get dummy lessons for a course
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
            isCompleted: false,
          ),
          Lesson(
            number: 2,
            id: 's1l2',
            title: 'Verbal Communication Techniques',
            duration: const Duration(minutes: 45),
            videoUrl: 'https://drive.google.com/file/d/1WRuqlqEFj4vorPakJ46yaVASOfF2UWVi/view?usp=sharing',
            isCompleted: false,
          ),
          Lesson(
            number: 3,
            id: 's1l3',
            title: 'Non-verbal Communication',
            duration: const Duration(minutes: 35),
            videoUrl: 'https://drive.google.com/file/d/1WRuqlqEFj4vorPakJ46yaVASOfF2UWVi/view?usp=sharing',
            isCompleted: false,
          ),
          Lesson(
            number: 4,
            id: 's1l4',
            title: 'Active Listening Skills',
            duration: const Duration(minutes: 40),
            videoUrl: 'https://drive.google.com/file/d/1WRuqlqEFj4vorPakJ46yaVASOfF2UWVi/view?usp=sharing',
            isCompleted: false,
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

  // Add method to upload course to API
  Future<void> uploadCourseToApi({
    required String title,
    required String description,
    required Duration duration,
    String? price,
    required int points,
    required CourseType type,
    required List<Lesson> lessons,
  }) async {
    try {
      log('DEBUG: Uploading course to API: $title');
      final connect = GetConnect();
      final authController = Get.find<AuthController>();
      final token = authController.accessToken;
      
      if (token == null) {
        throw 'User not authenticated';
      }
      
      // Convert lessons to JSON
      final lessonsJson = lessons.map((lesson) => {
        'title': lesson.title,
        'duration': lesson.duration.inMinutes,
        'video_url': lesson.videoUrl,
      }).toList();
      
      // Prepare course data
      final courseData = {
        'title': title,
        'description': description,
        'duration': duration.inMinutes,
        'type': type == CourseType.hard ? 'hard' : 'soft',
        'price': price,
        'points': points,
        'lessons': lessonsJson,
      };
      
      log('DEBUG: Sending course data: $courseData');
      
      // Send API request
      final response = await connect.post(
        '${EnvConfig.apiUrl}/courses',
        courseData,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      log('DEBUG: Upload response status: ${response.statusCode}');
      
      if (response.statusCode != 201) {
        log('DEBUG: Upload failed: ${response.body}');
        throw response.body['message'] ?? 'Failed to upload course';
      }
      
      log('DEBUG: Course uploaded successfully');
      
      // If successful, add the new course to the appropriate lists
      final newCourse = Course.fromJson(response.body['data']);
      
      if (type == CourseType.hard) {
        hardSkillsCourses.add(newCourse);
      } else {
        softSkillsCourses.add(newCourse);
      }
      
      // Add to teacher's courses
      _teacherCourses.add(newCourse);
      
      // Update popular courses
      _updatePopularCourses();
      
      Get.back();
      Get.snackbar(
        'Success',
        'Course uploaded successfully',
        backgroundColor: AppColors.primaryColor,
        colorText: AppColors.backgroundColor,
      );
    } catch (e) {
      log('DEBUG: Error uploading course: $e');
      ErrorHelper.showError(
        title: 'Error',
        message: 'Failed to upload course: $e',
      );
      rethrow; // Re-throw to be caught by the calling method
    }
  }
}
