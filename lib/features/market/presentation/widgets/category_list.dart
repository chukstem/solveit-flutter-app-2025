import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/features/market/domain/models/response/tags.dart';
import 'package:solveit/features/market/presentation/widgets/widgets.dart';

class CategoryList extends StatelessWidget {
  final List<MarketTag> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final bool isScrolling;

  const CategoryList({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.isScrolling = false,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isScrolling ? 0 : 50,
      child: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: categories
                .map(
                  (cat) => CategoryChip(
                    label: cat.name,
                    selected: selectedCategory == cat.name.toLowerCase(),
                    onPressed: () => onCategorySelected(cat.name),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
