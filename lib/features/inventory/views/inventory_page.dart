import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/courses/controllers/courses_controller.dart';
import 'package:skillzone/features/inventory/controllers/inventory_controller.dart';
import 'package:skillzone/features/home/widgets/course_card.dart';

class InventoryPage extends StatelessWidget {
  final CoursesController coursesController = Get.find<CoursesController>();
  final InventoryController inventoryController = Get.put(InventoryController());

  InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'My Inventory',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.bottomBarColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Obx(() => Row(
                  children: [
                    _buildTabButton(
                      title: 'Liked Courses',
                      isSelected: inventoryController.selectedTab.value == 0,
                      onTap: () => inventoryController.changeTab(0),
                    ),
                    _buildTabButton(
                      title: 'Enrolled Courses',
                      isSelected: inventoryController.selectedTab.value == 1,
                      onTap: () => inventoryController.changeTab(1),
                    ),
                  ],
                )),
              ),
            ),
            const SizedBox(height: 16),
            // Content based on selected tab
            Expanded(
              child: Obx(() {
                if (inventoryController.selectedTab.value == 0) {
                  return _buildLikedCoursesList();
                } else {
                  return _buildEnrolledCoursesList();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textColorInactive,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLikedCoursesList() {
    return Obx(() {
      final likedCourses = coursesController.likedCourses;
      
      if (likedCourses.isEmpty) {
        return _buildEmptyState('No liked courses yet', 'Like some courses to see them here');
      }
      
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: ListView.separated(
          padding: const EdgeInsets.all(16.0),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: likedCourses.length,
          itemBuilder: (context, index) {
            final course = likedCourses[index];
            final color = coursesController.sectionColors['popular']![index % coursesController.sectionColors['popular']!.length];
            return CourseCard(
              course: course,
              backgroundColor: color,
            );
          },
        ),
      );
    });
  }

  Widget _buildEnrolledCoursesList() {
    return Obx(() {
      final enrolledCourses = inventoryController.enrolledCourses;
      
      if (enrolledCourses.isEmpty) {
        return _buildEmptyState('No enrolled courses yet', 'Enroll in courses to start learning');
      }
      
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: ListView.separated(
          padding: const EdgeInsets.all(16.0),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: enrolledCourses.length,
          itemBuilder: (context, index) {
            final course = enrolledCourses[index];
            final color = coursesController.sectionColors['popular']![index % coursesController.sectionColors['popular']!.length];
            return CourseCard(
              course: course,
              backgroundColor: color,
            );
          },
        ),
      );
    });
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: AppColors.textColorInactive,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textColorLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textColorInactive,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
