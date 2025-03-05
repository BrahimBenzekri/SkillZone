import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/widgets/notification_icon.dart';
import 'package:skillzone/features/profile/widgets/profile_option.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          centerTitle: true,
          title: const Text(
            'My Profile',
            style: TextStyle(
              color: AppColors.textColorLight,
              fontSize: 24,
            ),
          ),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textColorLight,
              size: 24,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const NotificationIcon(isThereNotification: true))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 136,
                      height: 136,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.backgroundColor,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 3,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 63,
                      child: Image.asset(
                        'lib/assets/images/profile_image.png',
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text('Cool Guy',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 22,
                    )),
                const SizedBox(
                  height: 50,
                ),
                const ProfileOptionCard(text: "Edit Profile"),
                const ProfileOptionCard(text: "My Points"),
                const ProfileOptionCard(text: "Payments"),
                const ProfileOptionCard(text: "Content"),
                const ProfileOptionCard(text: "About the app"),
                const SizedBox(
                  height: 60,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Log Out",
                    style: TextStyle(
                      color: AppColors.errorColor,
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.errorColor,
                      decorationThickness: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
