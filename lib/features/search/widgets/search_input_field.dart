import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skillzone/core/theme/app_colors.dart';

class SearchInputField extends StatelessWidget {
  const SearchInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
            color: AppColors.textColorInactive, width: 2), // Border color
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'lib/assets/svgs/search_inactive.svg',
          ),
          const SizedBox(width: 10), // Space between icon and text field
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search ...",
                border: InputBorder.none, // Remove default border
                hintStyle: TextStyle(color: AppColors.textColorInactive),
              ),
              style: TextStyle(color: Colors.white), // Text color
            ),
          ),
        ],
      ),
    );
  }
}
