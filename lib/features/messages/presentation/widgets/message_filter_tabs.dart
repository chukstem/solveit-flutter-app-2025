import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';
import 'package:solveit/utils/theme/widgets/tab/h_tab.dart';

class MessageFilterTabs extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final List<String> filters;

  const MessageFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    this.filters = const ["All Chats", "Market Place", "Services"],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: horizontalPadding.copyWith(top: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20.w,
        children: [
          for (final filter in filters)
            HTab(
              text: filter,
              isActive: selectedFilter == filter,
              onTap: () => onFilterChanged(filter),
            ),
        ],
      ),
    );
  }
}
