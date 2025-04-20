import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import 'package:skillzone/core/config/env_config.dart';
import 'package:skillzone/core/utils/error_helper.dart';

class AuthController extends GetxController {
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  
  final storage = GetStorage();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString userEmail = ''.obs;
  final RxBool isLoggingOut = false.obs;
  final RxString logoutError = ''.obs;

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
        
        log('New tokens received - Access: $newAccessToken, Refresh: $newRefreshToken');
        
        if (newAccessToken != null && newRefreshToken != null) {
          await _saveAuthData(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );
          log('Successfully saved new tokens to storage');
          return true;
        } else {
          log('Error: Received null tokens in response');
        }
      } else {
        log('Error: Invalid response status code or empty body');
      }
      
      return false;
    } catch (e) {
      log('Error refreshing tokens: $e');
      log('Stack trace: ${StackTrace.current}');
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
      error.value = 'Connection error, please wait while the srever starts!';
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
