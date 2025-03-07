import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';

import '../controllers/popular_search_controller.dart';

class PopularSearchesList extends StatelessWidget {
  PopularSearchesList({super.key});

  final PopularSearchController controller = Get.put(PopularSearchController());

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Obx(() => GestureDetector(
              onTap: () {
                controller.setSelectedSearch(index);
              },
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                margin: EdgeInsets.only(
                    left: index == 0 ? 16 : 0,
                    right: index == controller.popularSearches.length - 1
                        ? 16
                        : 0),
                decoration: controller.isSelected(index)
                    ? BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      )
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: AppColors.textColorInactive,
                          width: 2,
                        ),
                      ),
                child: Text(
                  controller.popularSearches[index],
                  style: TextStyle(
                    fontSize: 14,
                    color: controller.isSelected(index)
                        ? AppColors.backgroundColor
                        : AppColors.textColorInactive,
                  ),
                ),
              ),
            ));
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 10,
      ),
      itemCount: controller.popularSearches.length,
      scrollDirection: Axis.horizontal,
    );
  }
}
