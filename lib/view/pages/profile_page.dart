import 'package:flutter/material.dart';
import 'package:skillzone/constants/app_colors.dart';
import 'package:skillzone/view/widgets/notification_icon.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: const Center(
        child: NotificationIcon(
          isThereNotification: true,
        ),
      ),
    );
  }
}
