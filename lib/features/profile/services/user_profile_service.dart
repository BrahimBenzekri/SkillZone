import 'dart:developer';
import 'package:get/get.dart';
import 'package:skillzone/core/config/env_config.dart';
import 'package:skillzone/features/auth/controllers/auth_controller.dart';
import 'package:skillzone/features/points/services/user_points_service.dart';
import 'package:skillzone/core/services/storage_service.dart';

class UserProfileService extends GetxService {
  // Initialize controllers and services permanently at app startup
  final AuthController _authController = Get.put(AuthController(), permanent: true);
  final UserPointsService _pointsService = Get.put(UserPointsService(), permanent: true);
  final StorageService _storageService = Get.find<StorageService>();
  
  // User profile data
  final firstName = ''.obs;
  final lastName = ''.obs;
  final username = ''.obs;
  // ignore: non_constant_identifier_names
  final is_teacher = false.obs;
  final selectedAvatarImage = 'lib/assets/images/avatar13.png'.obs;
  final selectedAvatarColorIndex = 0.obs;
  
  // Computed properties
  String get fullName => '${firstName.value} ${lastName.value}'.trim();
  bool get isTeacher => is_teacher.value;
  int get points => _pointsService.points.value;
  
  @override
  void onInit() {
    super.onInit();
    // First load from local storage
    loadProfileData();
    // Then try to fetch from API
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
        is_teacher.value = data['is_teacher'];
        _pointsService.points.value = data['points'] ?? 0;

        log('DEBUG: Updated profile values - firstName: ${firstName.value}, lastName: ${lastName.value}, username: ${username.value}');
        
        // Save to storage using StorageService
        await _storageService.saveUserProfile(
          firstName: firstName.value,
          lastName: lastName.value,
          username: username.value,
          isTeacher: is_teacher.value,
        );
        await _storageService.savePoints(_pointsService.points.value);
        
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
      firstName.value = _storageService.read<String>(StorageService.firstNameKey) ?? '';
      lastName.value = _storageService.read<String>(StorageService.lastNameKey) ?? '';
      username.value = _storageService.read<String>(StorageService.usernameKey) ?? 'User';
      is_teacher.value = _storageService.read<bool>(StorageService.isTeacherKey) ?? false;
      
      // Load avatar settings with better null handling
      final savedAvatarImage = _storageService.read<String>(StorageService.avatarImageKey);
      if (savedAvatarImage != null && savedAvatarImage.isNotEmpty) {
        log('DEBUG: Loading avatar image from storage: $savedAvatarImage');
        selectedAvatarImage.value = savedAvatarImage;
      } else {
        log('DEBUG: No saved avatar image found, using default');
      }
      
      final savedColorIndex = _storageService.read<int>(StorageService.avatarColorIndexKey);
      if (savedColorIndex != null && savedColorIndex >= 0) {
        log('DEBUG: Loading avatar color index from storage: $savedColorIndex');
        selectedAvatarColorIndex.value = savedColorIndex;
      } else {
        log('DEBUG: No saved color index found, using default');
      }
      
      log('DEBUG: Loaded profile data from storage - username: ${username.value}, avatar: ${selectedAvatarImage.value}, colorIndex: ${selectedAvatarColorIndex.value}, isTecher: ${is_teacher.value}');
    } catch (e) {
      log('DEBUG: Error loading profile data: $e');
    }
  }
  
  // Save avatar settings
  Future<void> saveAvatarSettings(String avatarPath, int colorIndex) async {
    try {
      log('DEBUG: Saving avatar settings - path: $avatarPath, colorIndex: $colorIndex');
      
      // Update observable values
      selectedAvatarImage.value = avatarPath;
      selectedAvatarColorIndex.value = colorIndex;
      
      // Save to storage using StorageService
      await _storageService.saveAvatarSettings(avatarPath, colorIndex);
      
      log('DEBUG: Avatar settings saved successfully');
    } catch (e) {
      log('DEBUG: Error saving avatar settings: $e');
    }
  }
}
