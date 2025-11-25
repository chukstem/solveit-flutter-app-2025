import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HSidebySideWidget extends StatelessWidget {
  final Widget left;
  final Widget right;
  final bool hide;
  final double? spacing;
  const HSidebySideWidget(
      {super.key,
      required this.left,
      this.hide = false,
      required this.right,
      this.spacing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        left,
        if (!hide) const Spacer(),
        SizedBox(
          width: spacing ?? 15.w,
        ),
        right
      ],
    );
  }
}
