import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import '../controllers/course_details_controller.dart';
import '../models/course_type.dart';
import '../widgets/lesson_card.dart';

class CourseDetailsPage extends StatelessWidget {
  final controller = Get.put(CourseDetailsController());

  CourseDetailsPage({super.key}) {
    final String courseId = Get.parameters['id'] ?? '';
    controller.loadCourseDetails(courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ));
        }

        if (controller.hasError.value) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.errorColor, fontSize: 18),
            ),
          ));
        }

        final course = controller.course.value;
        if (course == null) return const SizedBox();

        return CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              backgroundColor: AppColors.primaryColor,
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  course.title,
                  style: const TextStyle(
                      color: AppColors.textColorLight, fontSize: 18),
                ),
                background: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      top: 50,
                      child: SvgPicture.asset(
                        course.thumbnail,
                        fit: BoxFit.cover,
                        height: 150,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Course Info
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Text(
                      course.description,
                      style: const TextStyle(
                        color: AppColors.textColorLight,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(
                          Icons.star,
                          '${course.rating}',
                          'Rating',
                        ),
                        _buildStat(
                          Icons.people,
                          '${course.totalStudents}',
                          'Students',
                        ),
                        _buildStat(
                          Icons.timer,
                          course.durationText,
                          'Duration',
                        ),
                        _buildStat(
                          Icons.library_books,
                          '${course.totalLessons}',
                          'Lessons',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Access Information
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bottomBarColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            course.type == CourseType.soft
                                ? 'Earn ${course.points} points'
                                : course.price != null
                                    ? '\$${course.price}'
                                    : '${course.points} points required',
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // todo: Implement enrollment
                            },
                            child: const Text('Enroll Now'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Lessons Header
                    const Text(
                      'Course Content',
                      style: TextStyle(
                        color: AppColors.textColorLight,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Lessons List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final lesson = course.lessons[index];
                  return LessonCard(
                    lesson: lesson,
                    onTap: () => controller.startLesson(lesson),
                  );
                },
                childCount: course.lessons.length,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textColorLight,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textColorInactive,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
