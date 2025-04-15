import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/auth/controllers/auth_controller.dart';

class EmailVerificationPage extends StatelessWidget {
  EmailVerificationPage({super.key});

  final List<TextEditingController> codeControllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  // Use Get.find() instead of Get.put()
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/cubes_background.png',
              repeat: ImageRepeat.repeat,
              fit: BoxFit.fitWidth,
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        Text.rich(
                          TextSpan(
                            text: 'Verify Your ',
                            style: const TextStyle(
                              color: AppColors.textColorLight,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: 'Email',
                                style: TextStyle(
                                  foreground: Paint()
                                    ..shader = const LinearGradient(
                                      colors: [
                                        AppColors.primaryColor,
                                        AppColors.secondaryColor,
                                      ],
                                    ).createShader(
                                      const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                                    ),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: ' !',
                                style: TextStyle(
                                  color: AppColors.textColorLight,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            style: const TextStyle(
                              color: AppColors.textColorLight,
                              fontSize: 16,
                            ),
                            children: [
                              const TextSpan(text: "We've sent a "),
                              const TextSpan(
                                text: '4-digit verification code',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const TextSpan(text: ' to '),
                              TextSpan(
                                text: _authController.userEmail.value,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const TextSpan(
                                  text:
                                      '. Please enter the code below to verify your account'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SvgPicture.asset(
                          'lib/assets/svgs/email.svg',
                          height: 200,
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            4,
                            (index) => SizedBox(
                              width: 60,
                              height: 60,
                              child: TextField(
                                controller: codeControllers[index],
                                focusNode: focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.characters,
                                maxLength: 1,
                                cursorColor: AppColors.primaryColor,
                                style: const TextStyle(
                                  color: AppColors.textColorLight,
                                  fontSize: 24,
                                ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: AppColors.bottomBarColor.withValues(alpha: 0.5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.textColorLight,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.textColorLight,
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    // Convert to uppercase
                                    final upperValue = value.toUpperCase();
                                    if (value != upperValue) {
                                      codeControllers[index].text = upperValue;
                                    }
                                    // Move to next field if input is valid
                                    if (index < 3) {
                                      focusNodes[index + 1].requestFocus();
                                    }
                                  }
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Z]')),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "If you didn't receive a code!",
                              style: TextStyle(
                                color: AppColors.textColorLight,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () => _authController.resendVerificationCode(),
                              child: const Text(
                                'Resend',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primaryColor,
                                AppColors.secondaryColor,
                              ],
                            ),
                          ),
                          child: Obx(() => ElevatedButton(
                            onPressed: _authController.isLoading.value
                                ? (){}
                                : () {
                                    final code = codeControllers
                                        .map((controller) => controller.text)
                                        .join();
                                    _authController.verifyEmail(code);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
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
                                    'Verify and Proceed',
                                    style: TextStyle(
                                      color: AppColors.backgroundColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          )),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
