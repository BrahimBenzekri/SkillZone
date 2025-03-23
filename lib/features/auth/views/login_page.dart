import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';

import 'signup_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                            decoration: InputDecoration(
                              hintText: 'example@skillzone.com',
                              hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.backgroundColor
                                      .withValues(alpha:0.7)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
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
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.backgroundColor
                                      .withValues(alpha:0.7)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                            ),
                            style: const TextStyle(
                                color: AppColors.backgroundColor),
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: AppColors.backgroundColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
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
                                  onPressed: () {
                                    Get.to(() => const SignupPage(),
                                        transition: Transition.rightToLeft,
                                        duration:
                                            const Duration(milliseconds: 500));
                                  },
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
                    const SizedBox(height: 20),
                    const Row(children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.textColorLight,
                          thickness: 1.3,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'OR',
                        style: TextStyle(
                          color: AppColors.textColorLight,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Divider(
                          color: AppColors.textColorLight,
                          thickness: 1.3,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Image.asset('lib/assets/images/google_logo.png',
                            height: 23),
                        label: const Text(
                          'Sign in with Google',
                          style: TextStyle(
                            color: AppColors.backgroundColor,
                            fontSize: 20,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.textColorLight,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                      ),
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
