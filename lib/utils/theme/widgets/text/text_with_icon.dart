import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

class HTextWithIcon extends StatelessWidget {
  final String text;
  final double? fontSize;
  final double? iconSize;
  final FontWeight fontWeight;
  final Color? textColor;
  final bool isExpanded;
  final String? assets;
  final IconData? icon;
  final IconData? icon2;
  final String? assets2;
  final Color? tint;
  final TextAlign align;
  final int? maxLines;
  final double? spacing;
  final MainAxisAlignment? alignment;
  final TextStyle? style;

  const HTextWithIcon({
    super.key,
    required this.text,
    this.fontSize,
    this.iconSize,
    this.alignment,
    this.style,
    this.isExpanded = false,
    this.fontWeight = FontWeight.normal,
    this.textColor,
    this.align = TextAlign.center,
    this.maxLines,
    this.assets,
    this.icon,
    this.icon2,
    this.tint,
    this.spacing,
    this.assets2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment ?? MainAxisAlignment.start,
      children: [
        if (assets != null) ...[
          SvgPicture.asset(
            assets!,
            width: iconSize ?? 16.w,
            height: iconSize ?? 16.h,
            colorFilter: tint != null ? ColorFilter.mode(tint!, BlendMode.srcIn) : null,
          ),
          SizedBox(
            width: spacing ?? 4.w,
          ),
        ],
        if (icon != null) ...[
          Icon(
            icon!,
            size: iconSize ?? 16.w,
            color: tint,
          ),
          SizedBox(
            width: spacing ?? 4.w,
          ),
        ],
        isExpanded
            ? Expanded(
                child: Text(
                  text,
                  softWrap: true,
                  textAlign: align,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: (style ?? context.bodyMedium)?.copyWith(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    color: textColor,
                  ),
                ),
              )
            : Text(
                text,
                softWrap: true,
                textAlign: align,
                maxLines: maxLines,
                overflow: TextOverflow.clip,
                style: (style ?? context.bodyMedium)?.copyWith(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  color: textColor,
                ),
              ),
        if (assets2 != null) ...[
          SizedBox(
            width: spacing ?? 4.w,
          ),
          SvgPicture.asset(
            assets2!,
            width: iconSize ?? 16.w,
            height: iconSize ?? 16.h,
            colorFilter: tint != null ? ColorFilter.mode(tint!, BlendMode.srcIn) : null,
          ),
        ],
        if (icon2 != null) ...[
          SizedBox(
            width: spacing ?? 4.w,
          ),
          Icon(
            icon2!,
            size: iconSize ?? 16.w,
            color: tint,
          ),
        ],
      ],
    );
  }
}
