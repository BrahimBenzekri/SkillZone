import 'package:flutter/material.dart';
import 'package:skillzone/core/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Text(
          'Home Page',
          style: TextStyle(fontSize: 40, color: AppColors.textColorLight),
        ),
      ),
    );
  }
}
