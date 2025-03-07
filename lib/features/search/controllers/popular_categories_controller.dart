import 'package:get/get.dart';

class PopularCategoriesController extends GetxController {
  // Observable list of popular categories
  final popularCategories = <String>[
    'Web Development',
    'Cloud Computing',
    'Mobile Development',
    'DevOps',
    'Machine Learning',
    'Cybersecurity',
    'UI/UX Design',
  ].obs;

  // Observable selected category
  final selectedCategory = ''.obs;

  // Method to update selected category
  void setSelectedCategory(String category) {
    selectedCategory.value = category;
  }

  // Method to clear selection
  void clearSelection() {
    selectedCategory.value = '';
  }

  // Method to check if a category is selected
  bool isSelected(String category) {
    return selectedCategory.value == category;
  }

  // Optional: Method to filter categories by search term
  List<String> filterCategories(String searchTerm) {
    if (searchTerm.isEmpty) return popularCategories;
    return popularCategories
        .where((category) =>
            category.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
  }
}
