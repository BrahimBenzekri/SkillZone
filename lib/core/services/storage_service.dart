import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  // Storage keys
  static const String userPointsKey = 'user_points';
  static const String firstNameKey = 'user_first_name';
  static const String lastNameKey = 'user_last_name';
  static const String usernameKey = 'username';
  static const String avatarImageKey = 'avatar_image';
  static const String avatarColorIndexKey = 'avatar_color_index';
  static const String isTeacherKey = 'is_teacher';
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String likedCoursesKey = 'liked_courses';
  
  final _storage = GetStorage();
  
  // Initialize storage
  Future<StorageService> init() async {
    await GetStorage.init();
    log('DEBUG: Storage service initialized');
    return this;
  }
  
  // Generic read method with type safety
  T? read<T>(String key) {
    try {
      return _storage.read<T>(key);
    } catch (e) {
      log('ERROR: Failed to read $key from storage: $e');
      return null;
    }
  }
  
  // Generic write method
  Future<void> write(String key, dynamic value) async {
    try {
      await _storage.write(key, value);
      log('DEBUG: Wrote value to storage key: $key');
    } catch (e) {
      log('ERROR: Failed to write to storage key $key: $e');
    }
  }
  
  // Remove a key from storage
  Future<void> remove(String key) async {
    try {
      await _storage.remove(key);
      log('DEBUG: Removed key from storage: $key');
    } catch (e) {
      log('ERROR: Failed to remove key $key from storage: $e');
    }
  }
  
  // Clear all storage
  Future<void> clearAll() async {
    try {
      await _storage.erase();
      log('DEBUG: Cleared all storage');
    } catch (e) {
      log('ERROR: Failed to clear storage: $e');
    }
  }
  
  // User profile specific methods
  Future<void> saveUserProfile({
    String? firstName,
    String? lastName,
    String? username,
  }) async {
    if (firstName != null) await write(firstNameKey, firstName);
    if (lastName != null) await write(lastNameKey, lastName);
    if (username != null) await write(usernameKey, username);
  }
  
  // Avatar specific methods
  Future<void> saveAvatarSettings(String avatarPath, int colorIndex) async {
    await write(avatarImageKey, avatarPath);
    await write(avatarColorIndexKey, colorIndex);
  }
  
  // Auth specific methods
  Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    bool? isTeacher,
  }) async {
    await write(accessTokenKey, accessToken);
    await write(refreshTokenKey, refreshToken);
    if (isTeacher != null) await write(isTeacherKey, isTeacher);
  }
  
  Future<void> clearAuthData() async {
    await remove(accessTokenKey);
    await remove(refreshTokenKey);
  }
  
  // Points specific methods
  Future<void> savePoints(int points) async {
    await write(userPointsKey, points);
  }
  
  // Liked courses specific methods
  Future<void> saveLikedCourses(List<String> courseIds) async {
    await write(likedCoursesKey, courseIds);
  }
  
  List<String> getLikedCourses() {
    final likedIds = read<List<dynamic>>(likedCoursesKey);
    if (likedIds != null) {
      return likedIds.map((id) => id.toString()).toList();
    }
    return [];
  }
}