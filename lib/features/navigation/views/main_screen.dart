import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/features/navigation/controllers/navigation_controller.dart';
import 'package:skillzone/features/navigation/widgets/animated_bottom_bar.dart';
import 'package:skillzone/features/inventory/views/inventory_page.dart';
import '../../home/views/home_page.dart';
import '../../points/views/points_page.dart';
import '../../profile/views/profile_page.dart';

class MainScreen extends StatelessWidget {
  final NavigationController navController = Get.put(NavigationController());

  final List<Widget> pages = [
    HomePage(),
    InventoryPage(),
    PointsPage(),
    const ProfilePage(),
  ];

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: navController.pageController,
            physics:
                const NeverScrollableScrollPhysics(), // Disable swipe navigation
            children: pages,
          ),
          Positioned(bottom: 20, child: AnimatedBottomBar()),
        ],
      ),
    );
  }
}
