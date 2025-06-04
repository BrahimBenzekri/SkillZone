import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skillzone/core/routes/app_routes.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/courses/controllers/courses_controller.dart';
import 'package:skillzone/features/inventory/controllers/inventory_controller.dart';
import 'package:skillzone/features/points/services/user_points_service.dart';
import 'package:skillzone/features/profile/services/user_profile_service.dart';
import 'package:skillzone/widgets/notification_icon.dart';
import 'package:get/get.dart';
import 'package:skillzone/widgets/profile_icon.dart';

import '../../courses/models/course.dart';
import '../widgets/course_card.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key}) {
    // Load profile data when HomePage is created
    profileService.loadProfileData();
    profileService.fetchProfileData();
  }

  final controller = Get.put(CoursesController(), permanent: true);
  final profileService = Get.find<UserProfileService>();
  final pointsService = Get.find<UserPointsService>();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    try {
      // Refresh courses data from API
      await controller.loadCourses();

      // Refresh enrolled courses in the inventory controller
      final inventoryController = Get.find<InventoryController>();
      await inventoryController.loadEnrolledCourses();

      // Refresh user profile data
      await profileService.fetchProfileData();

      // Complete the refresh
      _refreshController.refreshCompleted();
    } catch (e) {
      // Handle any errors during refresh
      _refreshController.refreshFailed();
    }
  }

  Widget _buildCoursesList(
      String section, List<Course> courses, List<Color> colors) {
    return SizedBox(
      height: 150,
      child: Obx(() {
        return Skeletonizer(
          enabled: controller.isLoading.value,
          effect: ShimmerEffect(
            baseColor: AppColors.backgroundColor,
            highlightColor: controller.sectionColors[section]!.isNotEmpty
                ? controller.sectionColors[section]![0].withValues(alpha: 0.2)
                : AppColors.backgroundColor.withValues(alpha: 0.2),
          ),
          child: controller.isLoading.value
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16.0),
                  itemCount: 5, // Fixed number of skeleton cards
                  itemBuilder: (context, index) {
                    return Container(
                      width: 225, // Match CourseCard width
                      height: 150, // Match CourseCard height
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: controller.sectionColors[section]![
                            index % controller.sectionColors[section]!.length],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Stack(
                        children: [
                          // Thumbnail placeholder
                          // Positioned(
                          //   right: 20,
                          //   top: 40,
                          //   child: Skeleton.leaf(
                          //     child: Container(
                          //       height: 80,
                          //       width: 75,
                          //       color: AppColors.backgroundColor,
                          //     ),
                          //   ),
                          // ),
                          // Favorite button placeholder
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Bone.circle(
                              size: 30,
                            ),
                          ),
                          // Content
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 160,
                                      child: Bone.text(
                                        words: 2,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Bone.text(
                                        words: 2,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                // Points
                                Bone.text(
                                  width: 50,
                                  fontSize: 14,
                                ),
                                Spacer(),
                                // Bottom row: rating, duration, price
                                Row(
                                  children: [
                                    Expanded(
                                      child: Bone.text(
                                        words: 1,
                                        fontSize: 25,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Bone.text(
                                        words: 1,
                                        fontSize: 25,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Bone.text(
                                        words: 1,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : courses.isEmpty
                  ? const Center(
                      child: Text(
                        'No courses available',
                        style: TextStyle(
                          color: AppColors.errorColor,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 16.0),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        final color = controller.sectionColors[section]![
                            index % controller.sectionColors[section]!.length];
                        return CourseCard(
                          course: course,
                          backgroundColor: color,
                          isEnrolled: false,
                        );
                      },
                    ),
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
                  // Points and Upload Course Row
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
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
                                height: 16,
                                width: 16,
                              ),
                              const SizedBox(width: 8),
                              Obx(() => Skeletonizer(
                                    enabled: controller.isLoading.value,
                                    effect: const ShimmerEffect(
                                        baseColor: AppColors.backgroundColor,
                                        highlightColor: AppColors.primaryColor),
                                    child: Text(
                                      '${profileService.points} Pts',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Upload Course Button
                        if (profileService.isTeacher)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: GestureDetector(
                              onTap: () => Get.toNamed(AppRoutes.uploadCourse),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.add_circle_outline_rounded,
                                    color: AppColors.primaryColor,
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Upload Course',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Profile and Notification
                  const Row(
                    children: [
                      NotificationIcon(isThereNotification: true),
                      SizedBox(width: 8),
                      ProfileIcon()
                    ],
                  ),
                ],
              ),
            ),
            // Scrollable Content
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true, // Enable pull-to-refresh
                header: const WaterDropMaterialHeader(
                  backgroundColor: AppColors.primaryColor,
                  distance: 40.0,
                  semanticsLabel: "Completed",
                ), // Default refresh indicator style
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Message
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Obx(() => SizedBox(
                              width: 250,
                              child: Skeletonizer(
                                enabled: controller.isLoading.value,
                                effect: const ShimmerEffect(
                                    baseColor: AppColors.backgroundColor,
                                    highlightColor:
                                        AppColors.textColorInactive),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Welcome back,\n',
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 26,
                                        ),
                                      ),
                                      TextSpan(
                                        text: profileService
                                                .firstName.value.isNotEmpty
                                            ? profileService.firstName.value
                                            : profileService.username.value,
                                        style: const TextStyle(
                                          color: AppColors.textColorLight,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
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
              color: AppColors.textColorInactive.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
