import 'package:get/get.dart';
import 'package:skillzone/features/courses/models/course.dart';
import 'package:skillzone/features/courses/models/course_type.dart';

class InventoryController extends GetxController {
  // Tab selection (0 for Liked, 1 for Enrolled)
  final selectedTab = 0.obs;
  
  // List of enrolled courses (will be populated from API in real app)
  final enrolledCourses = <Course>[].obs;
  
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
    // For demo purposes, we'll create some dummy enrolled courses
    // In a real app, this would be an API call
    enrolledCourses.assignAll([
      Course(
        id: 'e1',
        title: 'Flutter Development Masterclass',
        description: 'Learn to build beautiful mobile apps with Flutter',
        rating: 4.8,
        duration: const Duration(hours: 12, minutes: 30),
        type: CourseType.hard,
        points: 250,
        thumbnail: 'assets/images/flutter.svg',
        progress: 0.35,
      ),
      Course(
        id: 'e2',
        title: 'Leadership Essentials',
        description: 'Master the art of leading teams effectively',
        rating: 4.6,
        duration: const Duration(hours: 8, minutes: 45),
        type: CourseType.soft,
        points: 180,
        thumbnail: 'assets/images/leadership.svg',
        progress: 0.7,
      ),
    ]);
  }
}
