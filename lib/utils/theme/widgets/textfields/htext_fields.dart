// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/text/text_with_icon.dart';

class HTextField extends StatefulWidget {
  final String? title;
  final GlobalKey? widgetkey;
  final String? toolTip;
  final String? hint;
  final BoxConstraints? suffixIconConstraints;
  final BoxConstraints? prefixIconConstraints;
  final EdgeInsets? padding;
  final Color? bg;
  final int? maxLength;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  final TextStyle? style;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextStyle? hintStyle;
  final bool readOnly;
  final bool? isDense;
  final String? error;
  final BoxConstraints? constraints;

  final List<TextInputFormatter>? formatters;
  final VoidCallback? onTap;
  final Function(String)? onChange;
  final Function(String, String?, String?)? onChange2;
  final TextAlign? titleAlign;
  final TextStyle? titleStyle;
  final bool? hideBorder;
  final bool isPassword;
  final void Function(String)? onSubmitted;
  final bool? obscureText;
  final String? obscureCharacter;
  final bool? hideBorderMain;
  final bool isGooglePlace;
  final String? value;
  final String? placeCountry;
  final String? Function(String?)? validator;
  final TextInputAction? keyboardAction;

  const HTextField({
    super.key,
    this.title,
    this.widgetkey,
    this.toolTip,
    this.hint,
    this.suffixIconConstraints,
    this.prefixIconConstraints,
    this.padding,
    this.bg,
    this.maxLength,
    this.controller,
    this.keyboardType,
    this.style,
    this.suffixIcon,
    this.prefixIcon,
    this.hintStyle,
    this.readOnly = false,
    this.error,
    this.constraints,
    this.formatters,
    this.onTap,
    this.onChange,
    this.onChange2,
    this.titleAlign,
    this.titleStyle,
    this.hideBorder = true,
    this.isPassword = false,
    this.onSubmitted,
    this.obscureText = false,
    this.obscureCharacter = "*",
    this.hideBorderMain = false,
    this.isGooglePlace = false,
    this.value,
    this.placeCountry,
    this.validator,
    this.keyboardAction,
    this.isDense = false,
  });

  @override
  State<HTextField> createState() => _IkookTextFieldState();
}

class _IkookTextFieldState extends State<HTextField> {
  String inpit = "";
  late FocusNode myFocusNode = FocusNode();

  // Use it to change color for border when textFiled in focus
  final FocusNode _focusNode = FocusNode();
  bool obscurePassword = false;

// Color for border
  Color _borderColor = Colors.transparent;

  late final TextEditingController controller =
      widget.controller ?? TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(covariant HTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && controller.text != widget.value) {
      setState(() {
        controller.text = widget.value ?? "";
      });
    }
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Change color for border if focus was changed
    _focusNode.addListener(() {
      setState(() {
        _borderColor = _focusNode.hasFocus
            ? widget.error != null
                ? context.colorScheme.error
                : context.colorScheme.secondary
            : Colors.transparent;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: widget.widgetkey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: widget.hideBorder == true
                ? const Border.fromBorderSide(BorderSide.none)
                : Border.all(
                    color: widget.error != null ? context.colorScheme.error : _borderColor),
            borderRadius: BorderRadius.circular(8.w),
            color: _focusNode.hasFocus
                ? context.cardColor
                : widget.bg ?? context.colorScheme.surfaceContainer,
          ),
          padding: (widget.padding ?? EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h)),
          child: SizedBox(
            height: 40.h,
            child: TextFormField(
              controller: controller,
              readOnly: widget.readOnly,
              focusNode: _focusNode,
              obscureText: widget.obscureText ?? false,
              obscuringCharacter: widget.obscureCharacter ?? "*",
              onFieldSubmitted: widget.onSubmitted,
              validator: widget.validator,
              autovalidateMode: AutovalidateMode.disabled,
              onTap: widget.onTap,
              onChanged: widget.onChange,
              keyboardType:
                  widget.formatters?.contains(FilteringTextInputFormatter.digitsOnly) == true
                      ? const TextInputType.numberWithOptions(signed: true, decimal: true)
                      : null,
              maxLength: widget.maxLength,
              inputFormatters: widget.formatters,
              style: widget.style ?? context.bodySmall,
              decoration: InputDecoration(
                isDense: widget.isDense,
                constraints: widget.constraints ?? const BoxConstraints(),
                fillColor: _focusNode.hasFocus
                    ? context.cardColor
                    : widget.bg ?? context.colorScheme.surfaceContainer,
                filled: true,
                contentPadding: EdgeInsets.zero,
                hintText: widget.hint ?? widget.title,
                hintStyle: widget.hintStyle ??
                    context.bodySmall?.copyWith(color: SolveitColors.textColorHint),
                prefixIcon: widget.prefixIcon,
                prefixIconColor: context.colorScheme.onSurface.withValues(alpha: (0.6)),
                prefixIconConstraints:
                    widget.prefixIconConstraints ?? BoxConstraints.loose(Size.fromWidth(20.w)),
                suffixIcon: widget.isPassword
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        child: obscurePassword
                            ? SvgPicture.asset(
                                eyeClosedSvg,
                                width: 15.w,
                              )
                            : FaIcon(
                                FontAwesomeIcons.eye,
                                size: 15.w,
                              ))
                    : widget.suffixIcon,
                suffixIconColor: context.colorScheme.onSurface.withValues(alpha: (0.6)),
                suffixIconConstraints:
                    widget.suffixIconConstraints ?? BoxConstraints.loose(Size.fromWidth(20.w)),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      widget.hideBorder == true ? BorderRadius.zero : BorderRadius.circular(8),
                  borderSide: widget.hideBorder == true
                      ? const BorderSide(color: Colors.transparent, width: 0)
                      : BorderSide(width: 0.w, color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      widget.hideBorder == true ? BorderRadius.zero : BorderRadius.circular(8),
                  borderSide: widget.hideBorder == true
                      ? const BorderSide(color: Colors.transparent, width: 0)
                      : BorderSide(width: 0.w, color: Colors.transparent),
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      widget.hideBorder == true ? BorderRadius.zero : BorderRadius.circular(8),
                  borderSide: widget.hideBorder == true
                      ? const BorderSide(color: Colors.transparent, width: 0)
                      : BorderSide(width: 0.w, color: Colors.transparent),
                ),
              ),
            ),
          ),
        ),
        if (widget.error != null) ...[
          SizedBox(
            height: 5.h,
          ),
          HTextWithIcon(
            text: widget.error!,
            isExpanded: true,
            align: TextAlign.start,
            iconSize: 12.w,
            maxLines: 2,
            tint: context.errorColor,
            icon: Icons.error_outline,
            style: context.bodySmall?.copyWith(
              fontSize: 12.sp,
              color: context.colorScheme.error,
            ),
          )
        ]
      ],
    );
  }
}
