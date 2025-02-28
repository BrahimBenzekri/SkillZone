import 'package:flutter/material.dart';
import 'package:skillzone/constants/app_colors.dart';

class ProfileOptionCard extends StatelessWidget {
  final String text;

  const ProfileOptionCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
                fontSize: 20.0, color: AppColors.textColorLight),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 20.0,
            color: AppColors.textColorLight,
          ),
        ],
      ),
    );
  }
}
