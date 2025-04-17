import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import 'package:skillzone/core/config/env_config.dart';

class AuthController extends GetxController {
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  
  final storage = GetStorage();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString userEmail = ''.obs;

  Map<String, dynamic>? _extractAuthData(Response response) {
    try {
      if (response.body['success'] == true) {
        final data = response.body['data'];
        return {
          'access': data['access'],
          'refresh': data['refresh'],
          'user': data['user'],
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
          Get.offAllNamed(AppRoutes.main);
        } else {
          error.value = 'Invalid response format';
          log('Login Error: Invalid response format');
        }
      } else {
        error.value = response.body['message'] ?? 'Login failed';
        log('Login Error: ${response.body}');
      }
    } catch (e) {
      error.value = 'Connection error';
      log('Login Exception: $e');
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
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      userEmail.value = email;

      // Log the request payload
      log('Signup Request Body: {first_name: $firstName, last_name: $lastName, username: $username, email: $email, password: $password}');
      final response = await GetConnect().post(
        EnvConfig.registerEndpoint,
        {
          'first_name': firstName,
          'last_name': lastName,
          'username': username,
          'email': email,
          'password': password,
          'password2': password,
          'accept_terms': true
        },
      );

      // Log complete response for debugging
      log('Response Status: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        Get.offAllNamed(AppRoutes.emailVerification);
      } else {
        error.value = response.body['message'] ?? 'Signup failed';
        log('Signup Error: ${response.body}');
      }
    } catch (e) {
      error.value = 'Connection error';
      log('Signup Exception: $e');
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

      // Log complete response for debugging
      log('Response Status: ${response.statusCode}');
      log('Response Body: ${response.body}');

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

      // TODO: Implement resend verification code API call
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

  // Helper method to save auth data
  Future<void> _saveAuthData({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await storage.write(accessTokenKey, accessToken);
      await storage.write(refreshTokenKey, refreshToken);
      log('Auth data saved successfully');
    } catch (e) {
      log('Error saving auth data: $e');
      throw Exception('Failed to save auth data');
    }
  }

  // Helper method to clear auth data
  Future<void> _clearAuthData() async {
    await storage.remove(accessTokenKey);
    await storage.remove(refreshTokenKey);
  }

  // Getter methods for stored data
  String? get accessToken => storage.read(accessTokenKey);
  String? get refreshToken => storage.read(refreshTokenKey);

  // Update logout method to clear stored data
  Future<void> logout() async {
    try {
      await _clearAuthData();
      Get.delete<AuthController>();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      log('Logout Exception: $e');
    }
  }
}
