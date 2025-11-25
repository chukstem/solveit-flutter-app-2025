import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

class Houtlinedbutton extends StatelessWidget {
  final String text;
  final double? fontSize;
  final bool? loading;
  final FontWeight? fontWeight;
  final Color? textColor;
  final VisualDensity? visualDensity;
  final Color? bgColor;
  final Color? borderColor;

  final bool? enabled;
  final TextAlign? align;
  final EdgeInsets? padding;

  final IconData? endIcon;
  final IconData? startIcon;
  final String? startIcon2;
  final String? endIcon2;

  final double? radius;
  final bool? hasColorFilter;
  final void Function()? onPressed;

  const Houtlinedbutton(
      {super.key,
      required this.text,
      this.fontSize,
      this.loading = false,
      this.fontWeight,
      this.textColor,
      this.visualDensity,
      this.bgColor,
      this.borderColor,
      this.enabled = true,
      this.align,
      this.padding,
      this.endIcon,
      this.startIcon,
      this.startIcon2,
      this.endIcon2,
      this.radius,
      this.onPressed,
      this.hasColorFilter = true})
      : super();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: context.outlinedButtonTheme.style?.copyWith(
          visualDensity: visualDensity,
          padding: WidgetStatePropertyAll(padding),
          backgroundColor: WidgetStatePropertyAll(
              enabled == true && loading == false ? bgColor ?? Colors.transparent : (bgColor ?? Colors.transparent).withValues(alpha: (0.4))),
          side: WidgetStatePropertyAll(BorderSide(
              color: enabled == true && loading == false
                  ? borderColor ?? context.colorScheme.primary
                  : (borderColor ?? context.colorScheme.primary).withValues(alpha: (0.4))))),
      onPressed: () => enabled == true ? onPressed?.call() : null,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading == true) ...[
              SizedBox(
                width: 15.w,
                height: 15.h,
                child: CircularProgressIndicator(
                  color: context.colorScheme.primary,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
            if (startIcon != null) ...[
              Icon(
                startIcon,
                color: context.colorScheme.primary,
                size: 18.w,
              ),
              SizedBox(
                width: 4.w,
              ),
            ],
            if (startIcon2 != null) ...[
              SvgPicture.asset(
                startIcon2!,
                colorFilter: !hasColorFilter! ? null : ColorFilter.mode(context.colorScheme.primary, BlendMode.srcIn),
                width: 18.w,
                height: 18.w,
                fit: BoxFit.contain,
              ),
              SizedBox(
                width: 4.w,
              ),
            ],
            Text(
              text,
              style: context.headlineMedium?.copyWith(fontSize: fontSize, color: textColor ?? context.onPrimary),
            ),
            if (endIcon != null) ...[
              SizedBox(
                width: 4.w,
              ),
              Icon(
                endIcon,
                color: context.colorScheme.primary,
                size: 17.w,
              )
            ],
            if (endIcon2 != null) ...[
              SvgPicture.asset(
                endIcon2!,
                colorFilter: !hasColorFilter! ? null : ColorFilter.mode(context.colorScheme.primary, BlendMode.srcIn),
                width: 18.w,
                height: 18.w,
                fit: BoxFit.contain,
              ),
              SizedBox(
                width: 4.w,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
