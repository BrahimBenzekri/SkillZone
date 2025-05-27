import 'dart:developer';

import 'package:get/get.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import 'package:skillzone/core/config/env_config.dart';
import 'package:skillzone/core/services/storage_service.dart';
import 'package:skillzone/core/utils/error_helper.dart';

class AuthController extends GetxController {
  // Use constants from StorageService
  final _storageService = Get.find<StorageService>();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString userEmail = ''.obs;
  final RxBool isTeacher =
      false.obs; // Main property to track if user is a teacher
  final RxBool isLoggingOut = false.obs;
  final RxString logoutError = ''.obs;
  final Rx<Map<String, String>> tempSignupData = Rx<Map<String, String>>({
    'firstName': '',
    'lastName': '',
    'username': '',
    'email': '',
    'password': '',
  });

  @override
  void onInit() {
    super.onInit();
    log('DEBUG: AuthController initializing');

    // Load isTeacher value from storage when controller initializes
    // final savedIsTeacher = _storageService.read<bool>(StorageService.isTeacherKey);
    // if (savedIsTeacher != null) {
    //   isTeacher.value = savedIsTeacher;
    //   log('DEBUG: Loaded isTeacher from storage: ${isTeacher.value}');
    // } else {
    //   log('DEBUG: No isTeacher value found in storage');
    // }
  }

  Future<String> determineInitialRoute() async {
    try {
      final isFirstLaunch = _storageService.read<bool>('isFirstLaunch') ?? true;

      if (isFirstLaunch) {
        await _storageService.write('isFirstLaunch', false);
        return AppRoutes.welcome;
      }

      // If no tokens exist, go to login
      if (accessToken == null || refreshToken == null) {
        return AppRoutes.login;
      }

      // Try to refresh the tokens
      final isValid = await _refreshTokens();
      if (isValid) {
        return AppRoutes.main;
      } else {
        await _clearAuthData();
        return AppRoutes.login;
      }
    } catch (e) {
      await _clearAuthData();
      return AppRoutes.login;
    }
  }

  Future<bool> _refreshTokens() async {
    log('DEBUG: Starting token refresh process');
    try {
      final refreshToken =
          _storageService.read<String>(StorageService.refreshTokenKey);
      if (refreshToken == null) {
        log('DEBUG: No refresh token found in storage');
        return false;
      }

      log('DEBUG: Sending refresh token request');
      // Use centralized API service
      final response = await EnvConfig.apiService.post(
          EnvConfig.refreshToken, {'refresh': refreshToken},
          requiresAuth: false);

      log('DEBUG: Received response with status code: ${response.statusCode}');
      if (response.statusCode == 200 && response.body != null) {
        final newAccessToken = response.body['access'];
        final newRefreshToken = response.body['refresh'];

        if (newAccessToken != null && newRefreshToken != null) {
          log('DEBUG: New tokens received, saving auth data');
          await _saveAuthData(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );
          log('DEBUG: Token refresh successful');
          return true;
        } else {
          log('DEBUG: New tokens are null');
        }
      } else {
        log('DEBUG: Token refresh failed with status code: ${response.statusCode}');
      }
      return false;
    } catch (e) {
      log('ERROR: Exception during token refresh: $e');
      return false;
    }
  }

  Map<String, dynamic>? _extractAuthData(Response response) {
    try {
      log('DEBUG: Extracting auth data from response');

      if (response.body['status'] == true) {
        final data = response.body['data'];
        log('DEBUG: Data extracted: ${data.keys}');

        // Extract isTeacher value if available
        if (data['is_teacher'] != null) {
          final isTeacherValue = data['is_teacher'] == true;
          isTeacher.value = isTeacherValue;
          log('DEBUG: isTeacher value extracted: ${isTeacher.value}');
        }

        return {
          'access': data['access'],
          'refresh': data['refresh'],
          'is_teacher': data['is_teacher'],
        };
      }
      return null;
    } catch (e) {
      log('DEBUG: Exception while extracting auth data: $e');
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = '';

      log('DEBUG: Attempting login with email: $email');

      // Use centralized API service
      final response = await EnvConfig.apiService.post(
          EnvConfig.loginEndpoint,
          {
            'email': email,
            'password': password,
          },
          requiresAuth: false);

      log("DEBUG: Response body: ${response.body}");

      if (response.statusCode == 200) {
        final authData = _extractAuthData(response);

        if (authData != null) {
          await _saveAuthData(
            accessToken: authData['access'],
            refreshToken: authData['refresh'],
            isTeacherValue: authData['is_teacher'],
          );

          Get.offAllNamed(AppRoutes.main);
        } else {
          throw 'Invalid response format';
        }
      } else {
        if (response.body == null) {
          throw 'Connection error, please wait while the server starts!';
        } else {
          throw 'Login failed';
        }
      }
    } catch (e) {
      error.value = e.toString();
      ErrorHelper.showAuthError(
        message: e.toString(),
        onRetry: () => login(email, password),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup({
    required String? firstName,
    required String? lastName,
    required String username,
    required String email,
    required String password,
    required bool isTeacherValue,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      userEmail.value = email;

      log('DEBUG: Preparing signup request with firstName: $firstName, lastName: $lastName, username: $username');
      log('DEBUG: Preparing signup request with email: $email, password: $password, isTeacher: $isTeacherValue');
      log('DEBUG:Sending request to endpoint: ${EnvConfig.registerEndpoint}');

      // Use centralized API service
      final response = await EnvConfig.apiService.post(
          EnvConfig.registerEndpoint,
          {
            'first_name': firstName,
            'last_name': lastName,
            'username': username,
            'email': email,
            'password': password,
            'password2': password,
            'accept_terms': true,
            'is_teacher': isTeacherValue
          },
          requiresAuth: false);

      log('DEBUG: Signup response received with body: ${response.body}');

      if (response.statusCode == 201) {
        log('DEBUG: Signup successful, saving isTeacher value: $isTeacherValue');
        // Save isTeacher value to storage
        await _storageService.write(
            StorageService.isTeacherKey, isTeacherValue);
        log('DEBUG: isTeacher value saved to storage: $isTeacherValue');

        log('DEBUG: Navigating to email verification page');
        Get.offAllNamed(AppRoutes.emailVerification);
      } else {
        log('DEBUG: Signup failed with response: ${response.body}');
        error.value = response.body['message'] ?? 'Signup failed';
        log('DEBUG: Error set to: ${error.value}');
        ErrorHelper.showAuthError(
          message: error.value,
          onRetry: () => signup(
            firstName: firstName,
            lastName: lastName,
            username: username,
            email: email,
            password: password,
            isTeacherValue: isTeacherValue,
          ),
        );
      }
    } catch (e) {
      log('DEBUG: Exception during signup: $e');
      error.value = 'Connection error, please wait while the server starts!';
      log('DEBUG: Error set to: ${error.value}');
      ErrorHelper.showAuthError(
        message: error.value,
        onRetry: () => signup(
          firstName: firstName,
          lastName: lastName,
          username: username,
          email: email,
          password: password,
          isTeacherValue: isTeacherValue,
        ),
      );
    } finally {
      isLoading.value = false;
      log('DEBUG: Signup process completed, isLoading set to false');
    }
  }

  Future<void> verifyEmail(String code) async {
    try {
      log('DEBUG: Starting email verification with code: $code');
      isLoading.value = true;
      error.value = '';

      log('DEBUG: User email for verification: ${userEmail.value}');

      // Use centralized API service
      final response = await EnvConfig.apiService.post(
          EnvConfig.verifyEmail,
          {
            'email': userEmail.value,
            'code': code,
          },
          requiresAuth: false);

      log('DEBUG: Verification response received with status code: ${response.statusCode}');
      log('DEBUG: Response body: ${response.body}');

      if (response.statusCode == 200) {
        log('DEBUG: Email verification successful');

        // Saving tokens from response
        _saveAuthData(
            accessToken: response.body["data"]["access"],
            refreshToken: response.body["data"]["refresh"]);

        // Refresh tokens after successful verification
        log('DEBUG: Attempting to refresh tokens after verification');
        await _refreshTokens();

        log('DEBUG: Navigating to interests page');
        Get.offAllNamed(AppRoutes.interests);
      } else {
        log('DEBUG: Email verification failed');
        error.value = response.body['message'] ?? 'Verification failed';
        log('DEBUG: Error set to: ${error.value}');
      }
    } catch (e) {
      log('DEBUG: Exception during email verification: $e');
      error.value = 'Connection error';
      log('DEBUG: Error set to: ${error.value}');
    } finally {
      isLoading.value = false;
      log('DEBUG: Email verification process completed, isLoading set to false');
    }
  }

  Future<void> resendVerificationCode() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await GetConnect().post(
        '${EnvConfig.apiUrl}/resend-verification/',
        {
          'email': userEmail.value,
        },
      );

      if (response.statusCode != 200) {
        error.value = response.body['message'] ?? 'Failed to resend code';
      }
    } catch (e) {
      error.value = 'Connection error';
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to save auth data
  Future<void> _saveAuthData({
    required String accessToken,
    required String refreshToken,
    bool? isTeacherValue,
  }) async {
    try {
      log('DEBUG: Saving auth data to storage');

      await _storageService.saveAuthData(
        accessToken: accessToken,
        refreshToken: refreshToken,
        isTeacher: isTeacherValue,
      );

      // Update isTeacher value if provided
      if (isTeacherValue != null) {
        isTeacher.value = isTeacherValue;
        log('DEBUG: isTeacher value updated: $isTeacherValue');
      }
    } catch (e) {
      log('DEBUG: Failed to save auth data: $e');
      throw Exception('Failed to save auth data');
    }
  }

  // Helper method to clear auth data
  Future<void> _clearAuthData() async {
    await _storageService.clearAuthData();
    await _storageService.remove(StorageService.isTeacherKey);
    isTeacher.value = false;
  }

  // Getter methods for stored data
  String? get accessToken =>
      _storageService.read<String>(StorageService.accessTokenKey);
  String? get refreshToken =>
      _storageService.read<String>(StorageService.refreshTokenKey);
  bool get isStudent => !isTeacher.value;

  // Update logout method to clear stored data
  Future<void> logout() async {
    try {
      if (refreshToken == null) {
        throw 'No refresh token found';
      }

      // Use centralized API service
      final response = await EnvConfig.apiService
          .post(EnvConfig.logout, {'refresh_token': refreshToken});

      if (response.body["success"]) {
        await _clearAuthData();
        Get.delete<AuthController>();
        Get.offAllNamed(AppRoutes.login);
      } else {
        throw response.body["message"] ?? 'Logout failed';
      }
    } catch (e) {
      ErrorHelper.showAuthError(
        message: 'Failed to logout. Please try again.',
        onRetry: logout,
      );
    }
  }
}
