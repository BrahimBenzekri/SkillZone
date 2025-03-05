import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/navigation/controllers/navigation_controller.dart';

class AnimatedBottomBar extends StatelessWidget {
  final NavigationController navigationController =
      Get.put(NavigationController());

  AnimatedBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          padding: const EdgeInsets.all(10),
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.bottomBarColor,
            borderRadius: BorderRadius.circular(35),
          ),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: navigationController.barItems
                  .map(
                    (item) => GestureDetector(
                      onTap: () {
                        navigationController.changePage(
                            navigationController.barItems.indexOf(item));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            navigationController.selectedIndex.value ==
                                    navigationController.barItems.indexOf(item)
                                ? item.activeIcon
                                : item.inactiveIcon,
                            height: 25,
                            width: 25,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item.name,
                            style: TextStyle(
                              color: navigationController.selectedIndex.value ==
                                      navigationController.barItems
                                          .indexOf(item)
                                  ? AppColors.textColorLight
                                  : AppColors.textColorInactive,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          )),
    );
  }
}
