import 'package:flutter/material.dart';
import 'package:skillzone/core/theme/app_colors.dart';

class LevelProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  final double width;

  const LevelProgressBar({
    super.key,
    required this.progress,
    this.height = 14,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.textColorInactive.withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.secondaryColor],
                ),
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
