import 'package:get/get.dart';

class PopularSearchController extends GetxController {
  final popularSearches = <String>[
    'Flutter',
    'Python',
    'JavaScript',
    'Data Analysis',
    'React',
    'AI',
    'AWS',
    'Cybersecurity',
    'DevOps',
    'Blockchain',
  ].obs;

  // Observable selected search
  final selectedSearchIndex = 0.obs;

  // Method to update selected search
  void setSelectedSearch(int index) {
    selectedSearchIndex.value = index;
  }

  // Method to check if a search is selected
  bool isSelected(int index) {
    return selectedSearchIndex.value == index;
  }
}
