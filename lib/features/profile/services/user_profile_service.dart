import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skillzone/core/config/env_config.dart';
import 'package:skillzone/features/auth/controllers/auth_controller.dart';
import 'package:skillzone/features/points/services/user_points_service.dart';

class UserProfileService extends GetxService {
  // Storage keys
  static const String firstNameKey = 'user_first_name';
  static const String lastNameKey = 'user_last_name';
  static const String usernameKey = 'username';
  static const String avatarImageKey = 'avatar_image';
  static const String avatarColorIndexKey = 'avatar_color_index';
  static const String isTeacherKey = 'is_teacher';
  static const String pointsKey = 'user_points';
  
  final storage = GetStorage();
  
    // Initialize controllers and services permanently at app startup
  final AuthController _authController = Get.put(AuthController(), permanent: true);
  final UserPointsService _pointsService = Get.put(UserPointsService(), permanent: true);
  
  // User profile data
  final firstName = ''.obs;
  final lastName = ''.obs;
  final username = ''.obs;
  final selectedAvatarImage = 'lib/assets/images/avatar13.png'.obs;
  final selectedAvatarColorIndex = 0.obs;
  
  // Computed properties
  String get fullName => '${firstName.value} ${lastName.value}'.trim();
  bool get isTeacher => false;
  int get points => _pointsService.points.value;
  
  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }
  
  // Fetch profile data from API and store locally
  Future<void> fetchProfileData() async {
    try {
      log('DEBUG: Fetching user profile data');
      final token = _authController.accessToken;
      
      if (token == null) {
        log('DEBUG: No access token available');
        return;
      }
      
      log('DEBUG: Making API request to ${EnvConfig.profileUrl}');
      
      // Use centralized API service
      final response = await EnvConfig.apiService.get(EnvConfig.profileUrl);
      
      log('DEBUG: API response status: ${response.statusCode}');
      
      if (response.statusCode == 200 && response.body != null) {
        log('DEBUG: Response body: ${response.body}');
        final data = response.body;
        
        // Update observable values
        firstName.value = data['first_name'] ?? '';
        lastName.value = data['last_name'] ?? '';
        username.value = data['username'] ?? '';
        _pointsService.points.value = data['points'] ?? 0;

        log('DEBUG: Updated profile values - firstName: ${firstName.value}, lastName: ${lastName.value}, username: ${username.value}');
        
        // Save to storage
        await storage.write(firstNameKey, firstName.value);
        await storage.write(lastNameKey, lastName.value);
        await storage.write(usernameKey, username.value);
        await storage.write(pointsKey, _pointsService.points.value);
        
        log('DEBUG: Profile data saved to storage successfully');
      } else {
        log('DEBUG: Failed to fetch profile data: ${response.statusCode}');
        log('DEBUG: Response body: ${response.body}');
      }
    } catch (e) {
      log('DEBUG: Error fetching profile data: $e');
      // Fall back to local data
      log('DEBUG: Falling back to local profile data');
      loadProfileData();
    }
  }
  
  // Load profile data from local storage
  void loadProfileData() {
    try {
      firstName.value = storage.read<String>(firstNameKey) ?? '';
      lastName.value = storage.read<String>(lastNameKey) ?? '';
      username.value = storage.read<String>(usernameKey) ?? 'User';
      
      // Load avatar settings
      final savedAvatarImage = storage.read<String>(avatarImageKey);
      if (savedAvatarImage != null && savedAvatarImage.isNotEmpty) {
        selectedAvatarImage.value = savedAvatarImage;
      }
      
      final savedColorIndex = storage.read<int>(avatarColorIndexKey);
      if (savedColorIndex != null && savedColorIndex >= 0) {
        selectedAvatarColorIndex.value = savedColorIndex;
      }
      
      log('DEBUG: Loaded profile data from storage');
    } catch (e) {
      log('DEBUG: Error loading profile data: $e');
    }
  }
  
  // Save avatar settings
  Future<void> saveAvatarSettings(String avatarPath, int colorIndex) async {
    try {
      selectedAvatarImage.value = avatarPath;
      selectedAvatarColorIndex.value = colorIndex;
      
      await storage.write(avatarImageKey, avatarPath);
      await storage.write(avatarColorIndexKey, colorIndex);
      
      log('DEBUG: Avatar settings saved');
    } catch (e) {
      log('DEBUG: Error saving avatar settings: $e');
    }
  }
}
