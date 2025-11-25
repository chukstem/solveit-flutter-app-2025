import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';
import 'package:solveit/utils/theme/widgets/button/houtlined_button.dart';
import 'package:solveit/utils/theme/widgets/layouts/scollable_column.dart';

class GenericBottomSheet extends StatelessWidget {
  final String title;
  final String body;
  final String actionText;
  final String? subactionText;
  final VoidCallback onAction;
  final VoidCallback? subonAction;
  final String? icon;
  final IconData? iconData;
  final Color? tint;
  final Widget? extraWidget;

  const GenericBottomSheet(
      {super.key,
      required this.title,
      required this.body,
      required this.actionText,
      required this.onAction,
      this.icon,
      this.subactionText,
      this.subonAction,
      this.tint,
      this.extraWidget,
      this.iconData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: horizontalPadding.copyWith(top: 20.h, bottom: 20.h),
      child: HScollableColumn(wrap: true, crossAxisAlignment: CrossAxisAlignment.center, children: [
        if (icon != null)
          SvgPicture.asset(
            icon!,
            width: 50.w,
            height: 50.h,
          ),
        if (iconData != null)
          Icon(
            iconData,
            size: 30.w,
            color: tint,
          ),
        SizedBox(
          height: 5.h,
        ),
        Text(title, style: context.titleMedium),
        SizedBox(
          height: 10.h,
        ),
        Text(
          body,
          style: context.bodySmall,
          textAlign: TextAlign.center,
        ),
        if (extraWidget != null) ...[
          SizedBox(
            height: 16.h,
          ),
          extraWidget!
        ],
        SizedBox(
          height: 30.h,
        ),
        HFilledButton(
            text: actionText,
            onPressed: () async {
              Navigator.of(context).pop();
              onAction();
            }),
        if (subonAction != null && subactionText != null) ...[
          SizedBox(
            height: 10.h,
          ),
          Houtlinedbutton(
              text: subactionText!,
              onPressed: () async {
                Navigator.of(context).pop();
                subonAction!();
              })
        ]
      ]),
    );
  }
}
