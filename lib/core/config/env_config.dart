import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/services/api_service.dart';

class EnvConfig {
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  
  static String get apiUrl => '$apiBaseUrl/api/v1/users';
  static String get profileUrl => '$apiUrl/profile/';
  static String get loginEndpoint => '$apiUrl/login/';
  static String get registerEndpoint => '$apiUrl/register/';
  static String get verifyEmail => '$apiUrl/verify-email/';
  static String get logout => '$apiUrl/logout/';
  static String get refreshToken => '$apiBaseUrl/api/token/refresh/';
  static String get getCourses => '$apiBaseUrl/api/v1/courses/';
  static String get unlockedCourses => '$apiBaseUrl/api/v1/courses/inventory/';
  static String get updatePoints => '$apiUrl/update-points/';
  static String getLessonsForCourse(String courseId) => '$apiBaseUrl/api/v1/courses/$courseId/lessons/';
  static String unlockCourse(String courseid) => '$apiBaseUrl/api/v1/courses/$courseid/unlock/';
  static String getQuiz(String courseID) => '$apiBaseUrl/api/v1/quizzes/courses/$courseID/quiz_data/';
  
  // Helper method to get the API service
  static ApiService get apiService => Get.find<ApiService>();
}
