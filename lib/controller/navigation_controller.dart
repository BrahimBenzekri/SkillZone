import 'package:get/get.dart';
import 'package:flutter/material.dart';

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
      activeIcon: 'lib/assets/svgs/card_active.svg',
      inactiveIcon: 'lib/assets/svgs/card_inactive.svg',
      name: 'Card',
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

class BarItem {
  String activeIcon;
  String inactiveIcon;
  String name;
  BarItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.name,
  });
}
