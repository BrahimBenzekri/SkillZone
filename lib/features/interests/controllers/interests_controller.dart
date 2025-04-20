import 'package:get/get.dart';
import 'package:skillzone/features/interests/models/interest.dart';
import 'package:skillzone/core/utils/error_helper.dart';

class InterestController extends GetxController {
  var hardSkills = <Interest>[
    Interest("Mobile Development"),
    Interest("Cybersecurity"),
    Interest("Data Science"),
    Interest("Game Development"),
    Interest("AI & Machine Learning"),
    Interest("DevOps"),
    Interest("Blockchain"),
    Interest("Software Architecture"),
    Interest("Linux"),
    Interest("Other"),
  ].obs;

  var softSkills = <Interest>[
    Interest("Leadership"),
    Interest("Public Speaking"),
    Interest("Time Management"),
    Interest("Creativity"),
    Interest("Critical Thinking"),
    Interest("Problem Solving"),
    Interest("Negotiation"),
    Interest("Networking"),
    Interest("Teamwork"),
    Interest("Other"),
  ].obs;

  /// Checks if at least one hard skill and one soft skill are selected
  bool get isSelectionValid =>
      hardSkills.any((skill) => skill.isSelected.value) &&
      softSkills.any((skill) => skill.isSelected.value);

  void showWarningSnackbar() {
    ErrorHelper.showValidationError(
      message: "Please select at least one hard skill and one soft skill.",
    );
  }

  void toggleInterest(Interest interest) {
    interest.isSelected.toggle();
  }
}
