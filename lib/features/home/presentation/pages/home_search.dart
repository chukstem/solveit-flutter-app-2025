import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solveit/features/home/presentation/pages/home_screen.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/back_button.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';
import 'package:solveit/utils/theme/widgets/tab/h_tab.dart';
import 'package:solveit/utils/theme/widgets/text/side_by_side_text.dart';
import 'package:solveit/utils/theme/widgets/textfields/htext_fields.dart';

class HomeSearchScreen extends StatefulWidget {
  const HomeSearchScreen({super.key});

  @override
  State<HomeSearchScreen> createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: backButton(context),
              centerTitle: true,
              title: Text(
                "Search",
                style: context.titleSmall?.copyWith(fontWeight: FontWeight.w500),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    _showLevelSelectionSheet();
                  },
                  child: SvgPicture.asset(filterSvg),
                ),
                SizedBox(
                  width: 20.w,
                ),
              ],
            ),
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              primary: false,
              title: HTextField(
                title: "Search",
                suffixIcon: svgIconButton(searchIcon, () {}),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: horizontalPadding.copyWith(top: 15.h),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      HTab(text: "For you", isActive: true, onTap: () {}),
                      SizedBox(
                        width: 20.w,
                      ),
                      HTab(text: "School", isActive: false, onTap: () {}),
                      SizedBox(
                        width: 20.w,
                      ),
                      HTab(text: "Crypto", isActive: false, onTap: () {}),
                      SizedBox(
                        width: 20.w,
                      ),
                      HTab(text: "Politics", isActive: false, onTap: () {}),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 15.h,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: horizontalPadding.copyWith(top: 20.h),
                child: HSidebySideWidget(
                    left: Text(
                      "Searched results",
                      style: context.bodySmall,
                    ),
                    right: Text(
                      "23 result",
                      style: context.bodySmall?.copyWith(color: SolveitColors.textColorHint),
                    )),
              ),
            ),
            SliverToBoxAdapter(
                child: SizedBox(
              height: 15.h,
            )),
            SliverList.list(children: const [])
          ],
        ),
      ),
    );
  }

  String _selectedFilter = '';
  String _selectedFilterType = '';

  void _showLevelSelectionSheet() {
    context.showBottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return AnimatedContainer(
            duration: Durations.short1,
            padding: EdgeInsets.all(12.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12.h,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Filter result",
                      style: context.titleSmall,
                    ),
                    IconButton(
                      icon: SvgPicture.asset(closeIconSvg),
                      onPressed: () {
                        Navigator.pop(context);
                        // setState(() => _selectedSchool = '');
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 20.w,
                      children: [
                        for (final filterType in [
                          "Post date",
                          "Post type",
                        ])
                          HTab(
                              text: filterType,
                              isActive: _selectedFilterType == filterType.toLowerCase(),
                              onTap: () {
                                setState(() => _selectedFilterType = filterType.toLowerCase());
                              }),
                      ],
                    ),
                  ),
                ),
                if (_selectedFilterType == 'Post date'.toLowerCase())
                  for (final filter in ["This Week", "Last Week", "This Month", "Last Month", "This Year", "Last Year", "Customize"])
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter.toLowerCase();
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(filter, style: context.bodyMedium),
                          Icon(
                            !(_selectedFilter == filter.toLowerCase()) ? Icons.circle_outlined : Icons.check_circle_rounded,
                            color: _selectedFilter == filter.toLowerCase() ? SolveitColors.orangeColor : SolveitColors.textColorHint,
                          )
                        ],
                      ),
                    ),
                if (_selectedFilterType == 'Post type'.toLowerCase())
                  for (final filter in [
                    "All Posts",
                    "Featured Posts",
                    "Trending Posts",
                    "Hot Posts",
                    "Recommended",
                  ])
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter.toLowerCase();
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(filter, style: context.bodyMedium),
                          Icon(
                            !(_selectedFilter == filter.toLowerCase()) ? Icons.circle_outlined : Icons.check_circle_rounded,
                            color: _selectedFilter == filter.toLowerCase() ? SolveitColors.orangeColor : SolveitColors.textColorHint,
                          )
                        ],
                      ),
                    ),
                const HFilledButton(
                  text: "Show Result (43)",
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
