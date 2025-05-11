import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/auth/controllers/auth_controller.dart';
import 'package:skillzone/core/utils/validation_helper.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Change from Get.put() to Get.find()
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RxBool _obscurePassword = true.obs;

  // Add this method to validate login form
  bool _validateLoginForm() {
    // Check if any field is empty
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ValidationHelper.showValidationError('Please enter both email and password');
      return false;
    }

    // Validate email format
    if (!ValidationHelper.isValidEmail(_emailController.text)) {
      ValidationHelper.showValidationError('Please enter a valid email address');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ListView(
                  children: [
                    const Center(
                      child: Text.rich(
                        TextSpan(
                            text: 'SKILL',
                            style: TextStyle(
                              color: AppColors.textColorLight,
                              fontFamily: 'K2D',
                              fontSize: 34,
                            ),
                            children: [
                              TextSpan(
                                text: 'Z',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontFamily: 'K2D',
                                  fontSize: 34,
                                ),
                              ),
                              TextSpan(
                                text: 'ONE',
                                style: TextStyle(
                                  color: AppColors.textColorLight,
                                  fontFamily: 'K2D',
                                  fontSize: 34,
                                ),
                              ),
                            ]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Log in to your account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textColorLight,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                            color: AppColors.textColorLight,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.textColorLight,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'example@skillzone.com',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: AppColors.backgroundColor.withValues(alpha: 0.7),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            style: const TextStyle(color: AppColors.backgroundColor),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Password',
                          style: TextStyle(
                            color: AppColors.textColorLight,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.textColorLight,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Obx(() => TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword.value,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: AppColors.backgroundColor.withValues(alpha: 0.7),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword.value 
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                  color: AppColors.backgroundColor.withValues(alpha: 0.7),
                                ),
                                onPressed: () => _obscurePassword.value = !_obscurePassword.value,
                              ),
                            ),
                            style: const TextStyle(color: AppColors.backgroundColor),
                          )),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: Obx(() => ElevatedButton(
                                onPressed: _authController.isLoading.value
                                    ? (){}
                                    : (){ 
                                      
                                      if (!_validateLoginForm()) {
                                          return;
                                      }
                                      _authController.login(
                                        _emailController.text,
                                        _passwordController.text,
                                      );},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                                child: _authController.isLoading.value
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: AppColors.backgroundColor,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Login',
                                        style: TextStyle(
                                          color: AppColors.backgroundColor,
                                          fontSize: 20,
                                        ),
                                      ),
                              )),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    color: AppColors.textColorLight,
                                    fontSize: 20,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Get.toNamed(AppRoutes.signup),
                                  child: const Text(
                                    'Join us',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
