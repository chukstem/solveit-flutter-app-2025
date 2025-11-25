import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

class OutlinedCard extends StatelessWidget {
  const OutlinedCard({
    super.key,
    required this.child,
    required this.insets,
    this.radius = 100,
    this.borderColor,
    this.borderWeight,
    this.bgColor,
  });
  final Widget child;
  final Color? borderColor;
  final Color? bgColor;
  final double? borderWeight;
  final EdgeInsets insets;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? context.colorScheme.onSecondary.withValues(alpha: (0.6)), width: borderWeight ?? 1.w),
      ),
      child: Padding(padding: insets, child: child),
    );
  }
}
