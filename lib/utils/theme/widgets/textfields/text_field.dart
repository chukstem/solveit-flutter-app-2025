import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatefulWidget {
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final bool obscureText;
  final String obscuringCharacter;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final double? height;

  const AppTextField({
    super.key,
    this.hint,
    this.errorText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.contentPadding,
    this.hintStyle,
    this.textStyle,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.validator,
    this.height,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode = FocusNode();
  late final TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    final isFocused = _focusNode.hasFocus;

    Color backgroundColor =
        isFocused ? Colors.white : const Color(0xFFF7F1F5); // idle color

    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: color, width: 1.2),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: widget.height ?? 40.h,
          child: TextFormField(
            controller: _internalController,
            focusNode: _focusNode,
            readOnly: widget.readOnly,
            obscureText: widget.obscureText,
            obscuringCharacter: widget.obscuringCharacter,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            style: widget.textStyle ?? const TextStyle(fontSize: 16),
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            onFieldSubmitted: widget.onSubmitted,
            validator: widget.validator,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle:
                  widget.hintStyle ?? const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: backgroundColor,
              contentPadding: widget.contentPadding ??
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              prefix: widget.prefixIcon,
              suffix: widget.suffixIcon,
              border: border(Colors.transparent),
              enabledBorder: hasError
                  ? border(Colors.red)
                  : (isFocused
                      ? border(Colors.orange)
                      : border(Colors.transparent)),
              focusedBorder: border(hasError ? Colors.red : Colors.orange),
              errorBorder: border(Colors.red),
              focusedErrorBorder: border(Colors.red),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: Colors.red),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
