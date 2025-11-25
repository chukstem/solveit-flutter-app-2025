import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.isSmall = false,
  });
  final bool? isSmall;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        height: !isSmall! ? 80.w : 30.w,
        width: !isSmall! ? 80.w : 30.w,
        decoration: BoxDecoration(
          color: context.primaryColor.withValues(alpha: (0.1)),
          borderRadius: BorderRadius.circular(10.w),
        ),
        child: CircularProgressIndicator.adaptive(
          strokeWidth: !isSmall! ? 5.h : 3.h,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}
