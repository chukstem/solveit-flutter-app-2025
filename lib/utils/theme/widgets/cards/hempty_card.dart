import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';
import 'package:solveit/utils/theme/widgets/cards/gradient_card.dart';
import 'package:solveit/utils/extensions.dart';

class HEmptyCard extends StatelessWidget {
  final String noun;
  final String? custom;
  final String icon;

  const HEmptyCard({super.key, required this.noun, required this.icon, this.custom}) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          child: GradientCard(
            shape: BoxShape.circle,
            children: Padding(
              padding: EdgeInsets.all(4.w),
              child: SvgPicture.asset(
                icon,
                width: 25.w,
                height: 25.h,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          custom ?? context.getLocalization()!.you_dont_have_any_template(noun, noun),
          style: context.bodySmall,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

class HErrorCard extends StatelessWidget {
  final String noun;
  final String? custom;
  final String icon;
  final VoidCallback action;

  const HErrorCard({super.key, required this.noun, required this.icon, required this.action, this.custom}) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          icon,
          width: 125.w,
          height: 125.h,
        ),
        SizedBox(
          height: 15.h,
        ),
        Text(
          custom ?? context.getLocalization()!.you_dont_have_any_template(noun, noun),
          style: context.labelLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20.h,
        ),
        FittedBox(
          child: HFilledButton(
            text: context.getLocalization()!.retry,
            onPressed: action,
          ),
        )
      ],
    );
  }
}
