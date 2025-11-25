import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

class StatisticsCard extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final Color bgColor;
  final String statsTitle;
  final String? statesValue;
  final bool isMinimum;

  const StatisticsCard(
      {super.key,
      required this.icon,
      required this.iconColor,
      required this.bgColor,
      required this.statsTitle,
      this.isMinimum = false,
      required this.statesValue})
      : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12.w)),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            width: 30.w,
            height: 25.h,
          ),
          SizedBox(
            height: 2.h,
          ),
          if (statesValue != null)
            Text(
              statesValue!,
              textAlign: TextAlign.center,
              style: isMinimum ? context.headlineMedium : context.titleMedium,
            ),
          Text(
            textAlign: TextAlign.center,
            statsTitle,
            maxLines: 1,
            style: isMinimum ? context.bodySmall?.copyWith(fontSize: 10.sp) : context.bodySmall,
          )
        ],
      ),
    );
  }
}
