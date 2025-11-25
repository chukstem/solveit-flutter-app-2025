import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

class HTab extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const HTab({super.key, required this.text, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isActive ? context.primaryColor : context.cardColor,
          borderRadius: BorderRadius.circular(14.w),
          border: Border.fromBorderSide(BorderSide(
            color: context.colorScheme.surface,
          ))),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Text(
          text,
          style: context.bodySmall?.copyWith(
            fontSize: 12.sp,
            color: isActive ? context.onPrimary : context.onSurface,
          ),
        ),
      ),
    );
  }
}
