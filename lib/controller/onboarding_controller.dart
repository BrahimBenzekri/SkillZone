import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/model/onboarding.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();
  final PageController pageController = PageController();
  var currentPage = 0.obs;

  Onboarding page1 = Onboarding(
      image: 'lib/assets/svgs/on_boarding1.svg',
      titleText1: 'Learn',
      titleText2: ' & Grow',
      subTitleText1: 'Watch',
      subTitleText2: ' Free',
      subTitleText3: ' Soft Skills Courses',
      descriptionText:
          'Enhance your communication, leadership, and problem-solving skills');

  Onboarding page2 = Onboarding(
      image: 'lib/assets/svgs/on_boarding2.svg',
      titleText1: 'Earn',
      titleText2: ' Rewards',
      subTitleText1: 'Gain',
      subTitleText2: ' Points',
      subTitleText3: ' For Learning',
      descriptionText:
          'Complete soft skills courses, earn points, and track your progress. The more you learn, the more you earn!');

  Onboarding page3 = Onboarding(
      image: 'lib/assets/svgs/on_boarding3.svg',
      titleText1: 'Unlock',
      titleText2: ' Hard Skills',
      subTitleText1: 'Access',
      subTitleText2: ' Advandced',
      subTitleText3: ' Courses',
      descriptionText:
          'Use your points to unlock premium hard skills courses and level up your expertise in technical fields.');
}
