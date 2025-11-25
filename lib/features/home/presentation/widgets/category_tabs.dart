import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';
import 'package:solveit/utils/theme/widgets/tab/h_tab.dart';

class CategoryTabs extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryTabs({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: horizontalPadding.copyWith(top: 15.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 20.w,
          children: [
            for (final category in categories)
              HTab(
                text: category,
                isActive: selectedCategory == category.toLowerCase(),
                onTap: () => onCategorySelected(category.toLowerCase()),
              ),
          ],
        ),
      ),
    );
  }
}
