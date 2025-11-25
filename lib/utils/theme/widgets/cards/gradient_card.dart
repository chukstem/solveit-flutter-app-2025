import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/utils/extensions.dart';

class GradientCard extends StatelessWidget {
  final Widget children;
  final BoxShape? shape;
  final bool isLoading;
  final EdgeInsets? insets;
  final Color? color;
  final Color? borderColor;

  const GradientCard(
      {super.key,
      required this.children,
      this.insets,
      this.shape,
      this.color,
      this.borderColor,
      this.isLoading = false})
      : super();

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? ClipRRect(
            borderRadius: BorderRadius.circular(context.getWidth()),
            child: Container(
              color: Colors.green,
              width: 30.w,
              height: 30.h,
            ),
          )
        : Container(
            decoration: BoxDecoration(
                gradient: color != null
                    ? null
                    : const LinearGradient(
                        colors: [
                          Color(0xFFFFB629),
                          Color(0xFFFFDA56),
                          Color(0xFFFFD7A6),
                        ],
                        stops: [0.0, 0.5, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                color: color,
                border: Border.fromBorderSide(BorderSide(
                    color: borderColor ?? Colors.transparent, width: 2.w)),
                shape: shape ?? BoxShape.rectangle,
                borderRadius:
                    shape == null ? BorderRadius.circular(10.w) : null),
            padding:
                insets ?? EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            child: Center(child: children),
          );
  }
}
