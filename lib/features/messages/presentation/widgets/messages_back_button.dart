import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

Widget messagesBackButton(BuildContext context, {VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Icon(
      color: context.cardColor,
      Icons.chevron_left,
      size: 30.w,
    ),
  );
}
