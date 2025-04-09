import 'package:get/get.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import '../models/course.dart';
import '../models/lesson.dart';

class CourseDetailsController extends GetxController {
  final Rx<Course?> course = Rx<Course?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Add available course IDs
  static const availableCourseIds = ['s1', 'h1'];

  Future<void> loadCourseDetails(String courseId) async {
    isLoading.value = true;
    hasError.value = false;

    try {
      await Future.delayed(const Duration(seconds: 1));
      final Map<String, dynamic> arguments = Get.arguments as Map<String, dynamic>;
      final currentCourse = arguments['course'] as Course; // Fix the casting here

      if (!availableCourseIds.contains(currentCourse.id)) {
        throw 'This course is not available yet. Stay tuned for updates!';
      }

      // Add dummy lessons only for available courses
      final updatedCourse = currentCourse.copyWith(
        lessons: _getDummyLessons(currentCourse.id),
      );

      course.value = updatedCourse;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  List<Lesson> _getDummyLessons(String courseId) {
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

  Future<void> startLesson(Lesson lesson) async {
    // Using named route with arguments
    await Get.toNamed(
      AppRoutes.lessonVideo,
      arguments: lesson,
    );
  }
}
