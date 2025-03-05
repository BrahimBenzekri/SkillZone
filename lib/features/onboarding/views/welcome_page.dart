import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/auth/views/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => const LoginPage(),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 500));
          },
          backgroundColor: AppColors.primaryColor,
          child: const Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.backgroundColor,
            size: 28,
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SvgPicture.asset(
                'lib/assets/svgs/oval_shapes.svg',
                height: 500,
                width: 500,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: SvgPicture.asset(
                'lib/assets/svgs/oval_shapes2.svg',
                height: 665,
                width: 665,
              ),
            ),
            Positioned(
              top: 25,
              left: 25,
              child: SvgPicture.asset(
                'lib/assets/svgs/crystal_shape3.svg',
                height: 40,
                width: 40,
              ),
            ),
            const Positioned(
                top: 100,
                left: 40,
                child: Text.rich(TextSpan(
                  text: "LEARNING",
                  style:
                      TextStyle(fontSize: 38, color: AppColors.secondaryColor),
                  children: [
                    TextSpan(
                      text: "\nMakes\nYou",
                      style: TextStyle(
                        fontSize: 38,
                        color: AppColors.textColorLight,
                      ),
                    ),
                    TextSpan(
                      text: " HAPPY",
                      style: TextStyle(
                        fontSize: 38,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ))),
            Positioned(
              top: 300,
              left: 50,
              child: SvgPicture.asset(
                'lib/assets/svgs/chat_shape.svg',
                height: 75,
                width: 75,
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                child: SvgPicture.asset(
                  'lib/assets/svgs/welcome_image.svg',
                  height: 400,
                  width: 350,
                )),
          ],
        ));
  }
}
