import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/utils/strings.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: Column(
            spacing: 14.h,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Solve-It ',
                  style: context.titleLarge?.copyWith(
                    color: context.secondaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    TextSpan(
                        text: 'is here! 🥰',
                        style: context.titleLarge?.copyWith(color: context.onPrimary)),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: onboardingString1,
                  style: context.titleMedium?.copyWith(
                    color: context.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    TextSpan(
                      text: onboardingString2,
                      style: context.titleMedium?.copyWith(
                        color: context.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                        text: onboardingString3,
                        style: context.titleMedium?.copyWith(color: context.onPrimary)),
                    TextSpan(
                      text: onboardingString4,
                      style: context.titleMedium?.copyWith(
                        color: context.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: onboardingString5,
                      style: context.titleMedium?.copyWith(
                        color: context.onPrimary,
                      ),
                    ),
                    TextSpan(
                      text: onboardingString6,
                      style: context.titleMedium?.copyWith(
                        color: context.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: onboardingString7,
                  style: context.titleMedium?.copyWith(
                    color: context.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: onboardingString8,
                      style: context.titleMedium?.copyWith(
                        color: context.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(left: 0, right: 50, bottom: 0, child: SvgPicture.asset(onboardingArrowSvg)),
      ],
    );
  }
}
