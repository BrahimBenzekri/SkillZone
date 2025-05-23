import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/auth/controllers/auth_controller.dart';

class AccountTypePage extends GetView<AuthController> {
  AccountTypePage({super.key});
  
  // Add a variable to track which type was selected
  final RxBool _selectedTeacher = false.obs;
  final RxBool _isSelecting = false.obs;

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 35.0),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Join ',
                        style: const TextStyle(
                          color: AppColors.textColorLight,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'SkillZone',
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
                            ),
                          ),
                          const TextSpan(text: ' as'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTypeCard(
                      title: 'Student',
                      description: 'Access courses, take quizzes, and earn points',
                      icon: Icons.school,
                      onTap: () => _selectType(false), // Student = false
                    ),
                    const SizedBox(height: 20),
                    _buildTypeCard(
                      title: 'Teacher',
                      description: 'Create courses, manage content, and teach others',
                      icon: Icons.person_outline,
                      isTeacher: true,
                      onTap: () => _selectType(true), // Teacher = true
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
    bool isTeacher = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: isTeacher
            ? null
            : const LinearGradient(
                colors: [AppColors.primaryColor, AppColors.secondaryColor],
              ),
        border: isTeacher
            ? Border.all(color: AppColors.primaryColor, width: 2)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: Obx(() => InkWell(
          onTap: (_isSelecting.value || controller.isLoading.value) ? null : onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isTeacher
                        ? AppColors.primaryColor.withValues(alpha: 0.1)
                        : AppColors.backgroundColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: (_isSelecting.value && _selectedTeacher.value == isTeacher)
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: isTeacher
                                ? AppColors.primaryColor
                                : AppColors.backgroundColor,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          icon,
                          size: 30,
                          color: isTeacher
                              ? AppColors.primaryColor
                              : AppColors.backgroundColor,
                        ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isTeacher
                              ? AppColors.primaryColor
                              : AppColors.backgroundColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isTeacher
                              ? AppColors.textColorLight
                              : AppColors.backgroundColor.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: isTeacher
                      ? AppColors.primaryColor
                      : AppColors.backgroundColor,
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  void _selectType(bool isTeacherValue) {
    _selectedTeacher.value = isTeacherValue;
    _isSelecting.value = true;
    
    final signupData = controller.tempSignupData.value;
    controller.signup(
      firstName: signupData['firstName'],
      lastName: signupData['lastName'],
      username: signupData['username'] ?? "",
      email: signupData['email'] ?? "",
      password: signupData['password'] ?? "",
      isTeacherValue: isTeacherValue,
    ).then((_) {
      _isSelecting.value = false;
    }).catchError((_) {
      _isSelecting.value = false;
    });
  }
}
