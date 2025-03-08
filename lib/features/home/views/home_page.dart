import 'package:flutter/material.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/courses/controllers/courses_controller.dart';
import 'package:skillzone/widgets/notification_icon.dart';
import 'package:get/get.dart';

import '../../courses/models/course.dart';
import '../widgets/course_card.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final CoursesController controller = Get.put(CoursesController());

  Widget _buildCoursesList(
      String section, List<Course> courses, List<Color> colors) {
    return SizedBox(
      height: 150,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (courses.isEmpty) {
          return const Center(
              child: Text(
            'No courses available',
            style: TextStyle(color: AppColors.errorColor, fontSize: 18),
          ));
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 16.0),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return CourseCard(
              course: course,
              backgroundColor: controller.sectionColors[section]![
                  index % controller.sectionColors[section]!.length],
            );
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sticky Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16.0,
                25.0,
                16.0,
                16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Points Display
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'lib/assets/images/rocket.png',
                          height: 18,
                          width: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '450 Pts',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Profile and Notification
                  Row(
                    children: [
                      const NotificationIcon(isThereNotification: true),
                      const SizedBox(width: 16),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22.5),
                          child: Image.asset(
                            'lib/assets/images/profile_image.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Message
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Welcome back,\n',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 26,
                              ),
                            ),
                            TextSpan(
                              text: 'Cool Guy',
                              style: TextStyle(
                                color: AppColors.textColorLight,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Popular Courses Section
                    const CourseSection(text: 'Popular Courses'),
                    const SizedBox(height: 16),
                    _buildCoursesList('popular', controller.popularCourses,
                        controller.sectionColors['popular']!),

                    const SizedBox(height: 16),
                    // Hard Skills Section
                    const CourseSection(text: 'Hard Skills'),
                    const SizedBox(height: 16),
                    _buildCoursesList('hard', controller.premiumCourses,
                        controller.sectionColors['hard']!),

                    const SizedBox(height: 16),
                    // Soft Skills Section
                    const CourseSection(text: 'Soft Skills'),
                    const SizedBox(height: 16),
                    _buildCoursesList('soft', controller.freemiumCourses,
                        controller.sectionColors['soft']!),

                    const SizedBox(height: 115),
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

class CourseSection extends StatelessWidget {
  final String text;
  const CourseSection({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: AppColors.textColorLight,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 6),
              height: 1,
              color: AppColors.textColorInactive.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
