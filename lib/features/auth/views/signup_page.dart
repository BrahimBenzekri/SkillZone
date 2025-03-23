import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/auth/widgets/account_type_widget.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

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
                        const Text(
                          'Full name',
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
                            decoration: InputDecoration(
                              hintText: 'Cool Guy',
                              hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.backgroundColor
                                      .withValues(alpha:0.7)),
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
                            decoration: InputDecoration(
                              hintText: 'example@skillzone.com',
                              hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.backgroundColor
                                      .withValues(alpha:0.7)),
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
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.backgroundColor
                                      .withValues(alpha:0.7)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                            style: const TextStyle(
                                color: AppColors.backgroundColor),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              showAccountTypeDialog();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                color: AppColors.backgroundColor,
                                fontSize: 18,
                              ),
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
                            height: 20),
                        label: const Text(
                          'Sign up with Google',
                          style: TextStyle(
                            color: AppColors.backgroundColor,
                            fontSize: 18,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.textColorLight,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
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
