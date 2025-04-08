import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/routes/app_routes.dart';

class NotificationIcon extends StatelessWidget {
  final bool isThereNotification;
  final VoidCallback? onPressed;

  const NotificationIcon({
    super.key, 
    required this.isThereNotification,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Get.toNamed(AppRoutes.notifications),
      child: isThereNotification
          ? SvgPicture.asset('lib/assets/svgs/notification_active.svg')
          : SvgPicture.asset('lib/assets/svgs/notification.svg'),
    );
  }
}
