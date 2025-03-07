import 'package:flutter/material.dart';
import 'package:skillzone/core/theme/app_colors.dart';
import 'package:skillzone/features/search/widgets/popular_categories_list.dart';

import '../widgets/popular_search_list.dart';
import '../widgets/search_input_field.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SearchInputField(),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Popular Search',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(height: 40, child: PopularSearchesList()),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Popular Categories',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: PopularCategoriesList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
