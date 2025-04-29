import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/auth/controllers/auth_controller.dart';
import 'package:skillzone/features/auth/models/user_type.dart';

class AccountTypePage extends GetView<AuthController> {
  const AccountTypePage({super.key});

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
            padding: const EdgeInsets.all(16.0),
            child: Column(
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
                  onTap: () => _selectType(UserType.student),
                ),
                const SizedBox(height: 20),
                _buildTypeCard(
                  title: 'Teacher',
                  description: 'Create courses, manage content, and teach others',
                  icon: Icons.person_outline,
                  isTeacher: true,
                  onTap: () => _selectType(UserType.teacher),
                ),
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
        child: InkWell(
          onTap: onTap,
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
                  child: Icon(
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
        ),
      ),
    );
  }

  void _selectType(UserType type) {
    controller.updateUserType(type);
    Get.toNamed(AppRoutes.interests);
  }
}