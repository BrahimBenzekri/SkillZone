import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skillzone/core/theme/app_colors.dart';

class ProfileIcon extends StatelessWidget {

  const ProfileIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    GetStorage storage = GetStorage();
    final savedAvatarImage = storage.read<String>('avatar_image') ?? 'lib/assets/images/avatar13.png';
    final savedColorIndex = storage.read<int>('avatar_color_index') ?? 0;

    return Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.avatarColors[savedColorIndex].withValues(alpha: 0.2),
          border: Border.all(
            color: AppColors.avatarColors[savedColorIndex],
            width: 2,
          ),
        ),
        child: Image.asset(
         savedAvatarImage,
        ),
      );
  }
}