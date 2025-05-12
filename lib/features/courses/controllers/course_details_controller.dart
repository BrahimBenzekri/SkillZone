import 'package:get/get.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import 'package:skillzone/features/courses/controllers/courses_controller.dart';
import 'package:skillzone/features/inventory/controllers/inventory_controller.dart';
import '../models/course.dart';
import '../models/lesson.dart';

class CourseDetailsController extends GetxController {
  final Rx<Course?> course = Rx<Course?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  
  // Reference to inventory controller to get progress
  final InventoryController _inventoryController = Get.find<InventoryController>();
  final CoursesController coursesController = Get.find<CoursesController>();

  Future<void> loadCourseDetails(String courseId) async {
    isLoading.value = true;
    hasError.value = false;

    try {
      await Future.delayed(const Duration(seconds: 1));
      final Map<String, dynamic> arguments = Get.arguments as Map<String, dynamic>;
      final currentCourse = coursesController.allCourses.firstWhereOrNull((c) => c.id == courseId);
      final bool isEnrolled = arguments['isEnrolled'] as bool? ?? false;

      if (currentCourse!.lessons.isEmpty) {
        throw 'This course is not available yet. Stay tuned for updates!';
      }
      
      // Use the course as is - lessons are already included from CoursesController
      var updatedCourse = currentCourse;
      
      // If enrolled, update lessons with completion status
      if (isEnrolled) {
        // Update lessons with completion status
        final updatedLessons = updatedCourse.lessons.map((lesson) {
          final isCompleted = _inventoryController.isLessonCompleted(currentCourse.id, lesson.id);
          // Create a new Lesson instance with updated isCompleted value
          return Lesson(
            id: lesson.id,
            title: lesson.title,
            number: lesson.number,
            duration: lesson.duration,
            isCompleted: isCompleted,
            videoUrl: lesson.videoUrl,
          );
        }).toList();
        
        // Update course with updated lessons
        updatedCourse = updatedCourse.copyWith(
          lessons: updatedLessons,
        );
      }

      course.value = updatedCourse;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startLesson(String courseId, Lesson lesson) async {
    // Using named route with arguments
    await Get.toNamed(
      AppRoutes.lessonVideo,
      arguments: {
        'lesson': lesson,
        'courseId': courseId,
      },
    );
  }

  // Add this method to fetch lessons from API
  // Future<void> fetchLessonsFromApi(String courseId) async {
  //   try {
  //     isLoading.value = true;
  //     // Use the existing method from CoursesController
  //     final lessonsFromApi = await Get.find<CoursesController>().fetchLessonsForCourse(courseId);
      
  //     // Update the course with fetched lessons
  //     if (course.value != null) {
  //       course.value!.lessons = lessonsFromApi;
  //       course.refresh();
  //     }
  //   } catch (e) {
  //     hasError.value = true;
  //     errorMessage.value = 'Failed to load lessons: ${e.toString()}';
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
