
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/routes/app_routes.dart';
// import 'package:skillzone/core/routes/app_routes.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/courses/controllers/courses_controller.dart';
import 'package:skillzone/features/courses/models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final Color backgroundColor;

  const CourseCard({
    super.key,
    required this.course,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.courseDetails,
          arguments: {
            'course': course,
            'backgroundColor': backgroundColor,
          },
        );
      }
      ,
      child: Container(
        width: 225,
        height: 150,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            // Thumbnail
            Positioned(
              right: 20,
              top: 40,
              child: SizedBox(
                height: 80, // 3/2 of card height
                width: 75,
                child: SvgPicture.asset(
                  course.thumbnail,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Favorite Button
            Positioned(
              top: 12,
              right: 12,
              child: Obx(() => GestureDetector(
                    onTap: () =>
                        Get.find<CoursesController>().toggleLike(course),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.textColorDark,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        course.isLiked.value
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            course.isLiked.value ? Colors.red : backgroundColor,
                        size: 22,
                      ),
                    ),
                  )),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  SizedBox(
                    width:
                        160, // Limit width to prevent overlap with favorite icon
                    child: Text(
                      course.title,
                      style: const TextStyle(
                        color: AppColors.textColorDark,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Points
                  const Spacer(),
                  Text(
                    '${course.points} Points',
                    style: const TextStyle(
                      color: AppColors.textColorDark,
                      fontSize: 14,
                    ),
                  ),

                  const Spacer(),

                  // Bottom row with rating, duration, and price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rating
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star_border_rounded,
                              color:
                                  backgroundColor, // Using the card's background color
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              course.rating.toString(),
                              style: TextStyle(
                                color: backgroundColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Duration
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          course.durationText,
                          style: TextStyle(
                            color: backgroundColor,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      // Price or Free
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          course.price != null ? '\$${course.price}' : 'Free',
                          style: TextStyle(
                            color: backgroundColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
