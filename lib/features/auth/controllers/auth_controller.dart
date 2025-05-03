import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import 'package:skillzone/core/config/env_config.dart';
import 'package:skillzone/core/utils/error_helper.dart';

import '../models/user_type.dart';

class AuthController extends GetxController {
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userTypeKey = 'user_type';
  
  final storage = GetStorage();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString userEmail = ''.obs;
  final Rx<UserType?> userType = Rx<UserType?>(null);
  final RxBool isLoggingOut = false.obs;
  final RxString logoutError = ''.obs;
  final Rx<Map<String, String>> tempSignupData = Rx<Map<String, String>>({
    'firstName': '',
    'lastName': '',
    'username': '',
    'email': '',
    'password': '',
  });

  // Add a property to track if the user is a teacher
  final isTeacher = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load user type from storage when controller initializes
    final savedType = storage.read<String>(userTypeKey);
    if (savedType != null) {
      userType.value = UserType.values.firstWhere(
        (type) => type.toString() == savedType,
        orElse: () => UserType.student,
      );
    }
  }

  Future<String> determineInitialRoute() async {
    try {
      final isFirstLaunch = storage.read<bool>('isFirstLaunch') ?? true;

      if (isFirstLaunch) {
        await storage.write('isFirstLaunch', false);
        log("First launch detected");
        return AppRoutes.welcome;
      }

      // If no tokens exist, go to login
      if (accessToken == null || refreshToken == null) {
        log("No tokens found, navigating to login");
        return AppRoutes.login;
      }

      // Try to refresh the tokens
      final isValid = await _refreshTokens();
      if (isValid) {
        return AppRoutes.main;
      } else {
        log("Tokens are invalid, clearing and navigating to login");
        await _clearAuthData();
        return AppRoutes.login;
      }
    } catch (e) {
      log('Error in determineInitialRoute: $e');
      await _clearAuthData();
      return AppRoutes.login;
    }
  }

  Future<bool> _refreshTokens() async {
    try {
      log('Starting token refresh process...');
      
      final refreshToken = storage.read<String>(refreshTokenKey);
      if (refreshToken == null) {
        log('Refresh token not found in storage');
        return false;
      }
      log('Found refresh token: $refreshToken');

      final response = await GetConnect().post(
        EnvConfig.refreshToken,
        {
          'refresh': refreshToken
        },
        headers: {
          'Content-Type': 'application/json',
        },
      );

      log('Refresh token response status: ${response.statusCode}');
      log('Refresh token response body: ${response.body}');

      if (response.statusCode == 200 && response.body != null) {
        final newAccessToken = response.body['access'];
        final newRefreshToken = response.body['refresh'];
        // final userType = UserType.values.firstWhere(
        //   (type) => type.toString() == response.body['user_type'],
        //   orElse: () => UserType.student,
        // );
        
        if (newAccessToken != null && newRefreshToken != null) {
          await _saveAuthData(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
            // userType: userType,
          );
          return true;
        }
      }
      return false;
    } catch (e) {
      log('Error refreshing tokens: $e');
      return false;
    }
  }

  Map<String, dynamic>? _extractAuthData(Response response) {
    try {
      if (response.body['status'] == true) {
        final data = response.body['data'];
        return {
          'access': data['access'],
          'refresh': data['refresh'],
        };
      }
      return null;
    } catch (e) {
      log('Error extracting auth data: $e');
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = '';
      userEmail.value = email;
      final response = await GetConnect().post(
        EnvConfig.loginEndpoint,
        {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final authData = _extractAuthData(response);
        if (authData != null) {
          await _saveAuthData(
            accessToken: authData['access'],
            refreshToken: authData['refresh'],
          );
          log(accessToken!);
          log(refreshToken!);
          Get.offAllNamed(AppRoutes.main);
        } else {
          throw 'Invalid response format';
        }
      } else {
        throw response.body['message'] ?? 'Login failed';
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
    required UserType userType,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      userEmail.value = email;

      final response = await GetConnect().post(
        EnvConfig.registerEndpoint,
        {
          'first_name': firstName,
          'last_name': lastName,
          'username': username,
          'email': email,
          'password': password,
          'password2': password,
          'accept_terms': true,
          'user_type': userType.toString(),
        },
      );

      if (response.statusCode == 201) {
        await storage.write(userTypeKey, userType.toString());
        this.userType.value = userType;
        Get.offAllNamed(AppRoutes.emailVerification);
      } else {
        error.value = response.body['message'] ?? 'Signup failed';
      }
    } catch (e) {
      error.value = 'Connection error, please wait while the server starts!';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyEmail(String code) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await GetConnect().post(
        EnvConfig.verifyEmail,
        {
          'email': userEmail.value,
          'code': code,
        },
      );

      if (response.statusCode == 200) {
        Get.offAllNamed(AppRoutes.interests);
      } else {
        error.value = response.body['message'] ?? 'Verification failed';
        log('Verification Error: ${response.body}');
      }
    } catch (e) {
      error.value = 'Connection error';
      log('Verification Exception: $e');
    } finally {
      isLoading.value = false;
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
        log('Resend Code Error: ${response.body}');
      }
    } catch (e) {
      error.value = 'Connection error';
      log('Resend Code Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserType(UserType type) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await GetConnect().post(
        '${EnvConfig.apiUrl}/update-user-type/',
        {
          'email': userEmail.value,
          'user_type': type.toString(),
        },
      );

      if (response.statusCode == 200) {
        await storage.write(userTypeKey, type.toString());
        userType.value = type;
      } else {
        throw response.body['message'] ?? 'Failed to update user type';
      }
    } catch (e) {
      error.value = e.toString();
      ErrorHelper.showAuthError(
        message: e.toString(),
        onRetry: () => updateUserType(type),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to save auth data
  Future<void> _saveAuthData({
    required String accessToken,
    required String refreshToken,
    // required UserType userType,
  }) async {
    try {
      await storage.write(accessTokenKey, accessToken);
      await storage.write(refreshTokenKey, refreshToken);
      await storage.write(userTypeKey, userType.toString());
      // this.userType.value = userType;
    } catch (e) {
      throw Exception('Failed to save auth data');
    }
  }

  // Helper method to clear auth data
  Future<void> _clearAuthData() async {
    await storage.remove(accessTokenKey);
    await storage.remove(refreshTokenKey);
    await storage.remove(userTypeKey);
    userType.value = null;
  }

  // Getter methods for stored data
  String? get accessToken => storage.read(accessTokenKey);
  String? get refreshToken => storage.read(refreshTokenKey);

  bool get isStudent => userType.value?.isStudent ?? false;

  // Update logout method to clear stored data
  Future<void> logout() async {
    try {
      if (refreshToken == null) {
        throw 'No refresh token found';
      }

      final response = await GetConnect().post(
        EnvConfig.logout,
        {
          'refresh_token': refreshToken
        },
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      
      log("Logout response: ${response.body}");

      if (response.body["success"]) {
        await _clearAuthData();
        log("Cleared the tokens from storage");
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
