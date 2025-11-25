import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

class OnboardingTabPage extends StatelessWidget {
  final String image;
  final String body;

  const OnboardingTabPage({super.key, required this.image, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Image.asset(image)),
        SizedBox(
          height: 15.h,
        ),
        Text(
          body,
          textAlign: TextAlign.center,
          style: context.titleMedium?.copyWith(color: context.onPrimary),
        )
      ],
    );
  }
}
