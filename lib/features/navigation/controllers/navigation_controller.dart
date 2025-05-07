import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:skillzone/features/navigation/models/bar_item.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;
  final PageController pageController = PageController();

  var barItems = <BarItem>[
    BarItem(
      activeIcon: 'lib/assets/svgs/home_active.svg',
      inactiveIcon: 'lib/assets/svgs/home_inactive.svg',
      name: 'Home',
    ),
    BarItem(
      activeIcon: 'lib/assets/svgs/inventory_active.svg',
      inactiveIcon: 'lib/assets/svgs/inventory_inactive.svg',
      name: 'Inventory',
    ),
    BarItem(
      activeIcon: 'lib/assets/svgs/points_active.svg',
      inactiveIcon: 'lib/assets/svgs/points_inactive.svg',
      name: 'Points',
    ),
    BarItem(
      activeIcon: 'lib/assets/svgs/profile_active.svg',
      inactiveIcon: 'lib/assets/svgs/profile_inactive.svg',
      name: 'Profile',
    ),
  ];

  void changePage(int index) {
    selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
