import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

Widget backButton(BuildContext context, {void Function()? onTap, IconData? icon}) {
  return context.canPop()
      ? Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: InkWell(
            onTap: onTap ?? () => (context.canPop()) ? context.pop() : null,
            child: Container(
              decoration: BoxDecoration(
                color: context.cardColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.colorScheme.surface,
                  width: 2.w,
                ),
              ),
              child: Icon(
                icon ?? Icons.chevron_left,
                size: 25.w,
              ),
            ),
          ),
        )
      : const SizedBox.shrink();
}
