import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/auth/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Use Get.put() with permanent: true
  final AuthController _authController = Get.put(AuthController(), permanent: true);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RxBool _obscurePassword = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textColorLight,
                    size: 25,
                  ),
                  onPressed: () => Get.back(),
                ),
                const Expanded(
                  child: SizedBox(
                    width: 100,
                  ),
                )
              ],
            ),
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
                        const SizedBox(height: 10),
                        Obx(() {
                          if (_authController.error.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                _authController.error.value,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: Obx(() => ElevatedButton(
                                onPressed: _authController.isLoading.value
                                    ? (){}
                                    : () => _authController.login(
                                          _emailController.text,
                                          _passwordController.text,
                                        ),
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
