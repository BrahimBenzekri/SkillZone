import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/constants/app_colors.dart';
import 'package:skillzone/controller/onboarding_controller.dart';
import 'package:skillzone/view/pages/welcome_page.dart';
import 'package:skillzone/view/widgets/onboarding_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: GestureDetector(
        onTap: () {
          if (controller.currentPage.value < 2) {
            controller.pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {
            Get.to(() => const WelcomePage());
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SmoothPageIndicator(
                  controller: controller.pageController,
                  count: 3,
                  effect: CustomizableEffect(
                      spacing: 10,
                      dotDecoration: DotDecoration(
                          height: 4,
                          width: 100,
                          color: AppColors.textColorInactive,
                          borderRadius: BorderRadius.circular(5.0)),
                      activeDotDecoration: DotDecoration(
                          height: 4,
                          width: 100,
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(5.0)))),
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: (index) {
                    controller.currentPage.value = index;
                  },
                  children: [
                    OnboardingPage(page: controller.page1),
                    OnboardingPage(page: controller.page2),
                    OnboardingPage(page: controller.page3)
                  ],
                ),
              ),
              const Text(
                'Swipe or Tap Anywhere To Continue',
                style:
                    TextStyle(color: AppColors.textColorInactive, fontSize: 14),
              )
            ],
          ),
        ),
      ),
    );
  }
}
