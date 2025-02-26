import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/constants/app_colors.dart';
import 'package:skillzone/model/interest.dart';

class SkillCard extends StatelessWidget {
  final Interest skill;
  final VoidCallback onTap; // Function to handle taps

  const SkillCard({super.key, required this.skill, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: onTap, // Call the onTap function when tapped
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: skill.isSelected.value
                ? BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.textColorInactive,
                      width: 2,
                    ),
                  ),
            child: Text(
              skill.name,
              style: TextStyle(
                fontSize: 14,
                color: skill.isSelected.value
                    ? AppColors.backgroundColor
                    : AppColors.textColorInactive,
              ),
            ),
          ),
        ));
  }
}
