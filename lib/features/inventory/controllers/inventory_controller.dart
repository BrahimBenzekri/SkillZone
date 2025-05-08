import 'package:get/get.dart';
import 'package:skillzone/features/courses/controllers/courses_controller.dart';
import 'package:skillzone/features/courses/models/course.dart';

class InventoryController extends GetxController {
  // Tab selection (0 for Liked, 1 for Enrolled)
  final selectedTab = 0.obs;
  
  // List of enrolled course IDs (will be populated from API in real app)
  final enrolledCourseIds = <String>[].obs;
  
  // Reference to the courses controller
  final CoursesController _coursesController = Get.find<CoursesController>();
  
  @override
  void onInit() {
    super.onInit();
    // Load enrolled courses (dummy data for now)
    loadEnrolledCourses();
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
  
  // Get enrolled courses by looking up IDs in the courses controller
  List<Course> get enrolledCourses {
    final allCourses = [..._coursesController.softSkillsCourses, ..._coursesController.hardSkillsCourses];
    return allCourses.where((course) => enrolledCourseIds.contains(course.id)).toList();
  }
  
  // Enroll in a course
  void enrollInCourse(String courseId) {
    if (!enrolledCourseIds.contains(courseId)) {
      enrolledCourseIds.add(courseId);
      // In a real app, this would make an API call
      // dio.post('/api/courses/$courseId/enroll');
    }
  }
  
  // Unenroll from a course
  void unenrollFromCourse(String courseId) {
    enrolledCourseIds.remove(courseId);
    // In a real app, this would make an API call
    // dio.delete('/api/courses/$courseId/enroll');
  }
}
