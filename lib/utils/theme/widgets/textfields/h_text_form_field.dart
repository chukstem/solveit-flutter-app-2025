import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/text/text_with_icon.dart';

class HTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChange;
  final String? hint;
  final String? error;
  final TextStyle? hintStyle;

  const HTextFormField(
      {super.key, this.controller, this.onChange, this.hint, this.hintStyle, this.error})
      : super();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      child: TextFormField(
        controller: controller,
        onChanged: onChange,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlignVertical: TextAlignVertical.top,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        minLines: 10,
        maxLines: null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
          fillColor: context.colorScheme.surfaceContainer,
          filled: true,
          error: error != null
              ? HTextWithIcon(
                  text: error!,
                  isExpanded: true,
                  align: TextAlign.start,
                  iconSize: 12.w,
                  maxLines: 2,
                  tint: context.errorColor,
                  icon: Icons.error_outline,
                  style: context.bodySmall?.copyWith(fontSize: 12.sp, color: context.errorColor),
                )
              : null,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.w),
            borderSide: BorderSide(width: 1.w, color: context.errorColor),
          ),
          hintText: hint,
          hintStyle: hintStyle ?? context.bodySmall,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(width: 0.w, color: Colors.transparent),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.w),
            borderSide: BorderSide(
              width: 1.w,
              color: error != null ? context.errorColor : context.colorScheme.surfaceContainer,
            ),
          ),
        ),
      ),
    );
  }
}
