import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

class HCountryCodePicker extends StatelessWidget {
  final Function(CountryCode) onChange;

  const HCountryCodePicker({super.key, required this.onChange}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: context.colorScheme.surface, borderRadius: BorderRadius.circular(defCornerRadius)),
      padding: EdgeInsets.symmetric(horizontal: 7.w),
      child: CountryCodePicker(
        onChanged: (country) {
          onChange(country);
        },
        padding: EdgeInsets.zero,
        flagWidth: 25.w,
        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
        initialSelection: 'NG',
        favorite: const ['+234', 'NG'],
        // optional. Shows only country name and flag
        showCountryOnly: false,
        // optional. Shows only country name and flag when popup is closed.
        showOnlyCountryWhenClosed: false,
        showDropDownButton: true,
        builder: (code) {
          return Row(
            children: [
              Image.asset(
                code!.flagUri!,
                package: 'country_code_picker',
                width: 25.w,
                height: 15.h,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(width: 10.w),
              FaIcon(
                FontAwesomeIcons.chevronDown,
                size: 12.w,
                color: context.surfaceOnBackground,
              )
            ],
          );
        },
        // optional. aligns the flag and the Text left
        alignLeft: false,
        hideMainText: true,
      ),
    );
  }
}
