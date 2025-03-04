import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/features/navigation/controllers/navigation_controller.dart';
import 'package:skillzone/features/navigation/widgets/animated_bottom_bar.dart';
import '../../card/views/card_page.dart';
import '../../home/views/home_page.dart';
import '../../profile/views/profile_page.dart';

class MainScreen extends StatelessWidget {
  final NavigationController navController = Get.put(NavigationController());

  final List<Widget> pages = [
    const HomePage(),
    const CardPage(),
    const ProfilePage(),
  ];

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: navController.pageController,
        physics:
            const NeverScrollableScrollPhysics(), // Disable swipe navigation
        children: pages,
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedBottomBar(),
    );
  }
}
