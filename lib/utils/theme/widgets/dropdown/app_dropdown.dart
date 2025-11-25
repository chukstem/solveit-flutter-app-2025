import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

class AppDropDownField extends StatefulWidget {
  final String hintText;
  final Map<String, String> values;
  final Function(String?) onChanged;
  final String? selectedValue;
  final bool? isExpanded;
  final double? height;

  const AppDropDownField({
    super.key,
    required this.hintText,
    required this.values,
    required this.onChanged,
    this.selectedValue,
    this.isExpanded = true,
    this.height,
  });

  @override
  State<AppDropDownField> createState() => _SimpleDropdownFieldState();
}

class _SimpleDropdownFieldState extends State<AppDropDownField> {
  bool _isFocused = false;
  @override
  Widget build(BuildContext context) {
    return Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _isFocused = hasFocus;
          });
        },
        child: Container(
          height: widget.height ?? 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
          ),
          child: DropdownButtonHideUnderline(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: DropdownButton<String>(
                  hint: Text(
                    widget.hintText,
                    style: context.bodySmall,
                  ),
                  value: widget.selectedValue,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: _isFocused ? context.primaryColor : context.pendingColor,
                  ),
                  isExpanded: widget.isExpanded!,
                  items: widget.values.entries.map((MapEntry<String, String> entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(
                        entry.value,
                        style: context.bodySmall,
                      ),
                    );
                  }).toList(),
                  onChanged: widget.onChanged,
                )),
          ),
        ));
  }
}
