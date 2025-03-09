import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/core/utils/media_query_helper.dart';
import 'package:skillzone/features/navigation/controllers/navigation_controller.dart';

class AnimatedBottomBar extends StatelessWidget {
  final NavigationController navigationController =
      Get.put(NavigationController());

  AnimatedBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.all(10),
      height: 70,
      width: MediaQueryHelper.getScreenWidth(context) - 60,
      decoration: BoxDecoration(
        color: AppColors.bottomBarColor,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Obx(
        () => Row(
          children: List.generate(
            navigationController.barItems.length,
            (index) => Expanded(
              child: GestureDetector(
                behavior:
                    HitTestBehavior.opaque, // Makes the entire area touchable
                onTap: () => navigationController.changePage(index),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: navigationController.selectedIndex.value == index
                          ? 1.2
                          : 1.0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity:
                            navigationController.selectedIndex.value == index
                                ? 1.0
                                : 0.5,
                        child: SvgPicture.asset(
                          navigationController.selectedIndex.value == index
                              ? navigationController.barItems[index].activeIcon
                              : navigationController
                                  .barItems[index].inactiveIcon,
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: navigationController.selectedIndex.value == index
                            ? AppColors.textColorLight
                            : AppColors.textColorInactive,
                        fontSize:
                            navigationController.selectedIndex.value == index
                                ? 12
                                : 10,
                        fontFamily: 'Oddval',
                      ),
                      child: Text(navigationController.barItems[index].name),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
