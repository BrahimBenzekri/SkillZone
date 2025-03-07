import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/popular_categories_controller.dart';
import 'category_card.dart';

class PopularCategoriesList extends StatelessWidget {
  PopularCategoriesList({super.key});

  final PopularCategoriesController controller =
      Get.put(PopularCategoriesController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.popularCategories.length,
        itemBuilder: (context, index) {
          return CategoryCard(
            text: controller.popularCategories[index],
          );
        },
      ),
    );
  }
}
