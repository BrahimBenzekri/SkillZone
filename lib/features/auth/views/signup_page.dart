import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/auth/controllers/auth_controller.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  // Change from Get.put() to Get.find()
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textColorLight,
                size: 25,
              ),
              onPressed: () => Get.back(),
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
                      'Create an account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textColorLight,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'First name',
                                    style: TextStyle(
                                      color: AppColors.textColorLight,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.textColorLight,
                                      borderRadius: BorderRadius.circular(23),
                                    ),
                                    child: TextField(
                                      controller: _firstNameController,
                                      decoration: InputDecoration(
                                        hintText: 'John',
                                        hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.backgroundColor
                                                .withValues(alpha: 0.7)),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 14),
                                      ),
                                      style: const TextStyle(
                                          color: AppColors.backgroundColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Last name',
                                    style: TextStyle(
                                      color: AppColors.textColorLight,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.textColorLight,
                                      borderRadius: BorderRadius.circular(23),
                                    ),
                                    child: TextField(
                                      controller: _lastNameController,
                                      decoration: InputDecoration(
                                        hintText: 'Doe',
                                        hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.backgroundColor
                                                .withValues(alpha: 0.7)),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 14),
                                      ),
                                      style: const TextStyle(
                                          color: AppColors.backgroundColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Username',
                          style: TextStyle(
                            color: AppColors.textColorLight,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.textColorLight,
                            borderRadius: BorderRadius.circular(23),
                          ),
                          child: TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              hintText: '@username',
                              hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.backgroundColor
                                      .withValues(alpha: 0.7)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                            style: const TextStyle(
                                color: AppColors.backgroundColor),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Email',
                          style: TextStyle(
                            color: AppColors.textColorLight,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.textColorLight,
                            borderRadius: BorderRadius.circular(23),
                          ),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'example@skillzone.com',
                              hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.backgroundColor
                                      .withValues(alpha: 0.7)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                            style: const TextStyle(
                                color: AppColors.backgroundColor),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Password',
                          style: TextStyle(
                            color: AppColors.textColorLight,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.textColorLight,
                            borderRadius: BorderRadius.circular(23),
                          ),
                          child: Obx(() => TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword.value,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: AppColors.backgroundColor.withValues(alpha: 0.7)
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
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
                                    : () => _authController.signup(
                                          firstName: _firstNameController.text,
                                          lastName: _lastNameController.text,
                                          username: _usernameController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
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
                                        'Sign up',
                                        style: TextStyle(
                                          color: AppColors.backgroundColor,
                                          fontSize: 18,
                                        ),
                                      ),
                              )),
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
