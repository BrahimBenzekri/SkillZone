import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skillzone/constants/app_colors.dart';
import 'package:skillzone/model/onboarding.dart';

class OnboardingPage extends StatelessWidget {
  final Onboarding page;

  const OnboardingPage({
    super.key,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          height: 20,
        ),
        SvgPicture.asset(
          page.image,
          height: MediaQuery.of(context).size.height / 3,
          fit: BoxFit.contain,
        ),
        Text.rich(TextSpan(
            text: page.titleText1,
            style: const TextStyle(
              color: AppColors.secondaryColor,
              fontFamily: 'K2D',
              fontSize: 34,
            ),
            children: [
              TextSpan(
                text: page.titleText2,
                style: const TextStyle(
                  color: AppColors.textColorLight,
                  fontFamily: 'K2D',
                  fontSize: 34,
                ),
              )
            ])),
        Text.rich(
          TextSpan(
              text: page.subTitleText1,
              style: const TextStyle(
                color: AppColors.textColorLight,
                fontSize: 25,
              ),
              children: [
                TextSpan(
                  text: page.subTitleText2,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 25,
                  ),
                ),
                TextSpan(
                  text: page.subTitleText3,
                  style: const TextStyle(
                    color: AppColors.textColorLight,
                    fontSize: 25,
                  ),
                )
              ]),
          textAlign: TextAlign.center,
        ),
        Text(
          page.descriptionText,
          style:
              const TextStyle(fontSize: 14.0, color: AppColors.textColorLight),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
