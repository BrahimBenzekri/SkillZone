import 'dart:developer';

import 'package:get/get.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import 'package:skillzone/core/config/env_config.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await GetConnect().post(
        EnvConfig.loginEndpoint,
        {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // TODO: Save token/user data to local storage
        Get.offAllNamed(AppRoutes.main);
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
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

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
        // Successfully created account
        Get.offAllNamed(AppRoutes.interests);
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
}
