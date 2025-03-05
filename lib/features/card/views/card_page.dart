import 'package:flutter/material.dart';
import 'package:skillzone/core/theme/app_colors.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Text(
          'Card Page',
          style: TextStyle(fontSize: 40, color: AppColors.textColorLight),
        ),
      ),
    );
  }
}
