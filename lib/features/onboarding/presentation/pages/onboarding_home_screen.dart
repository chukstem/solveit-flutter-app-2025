import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/features/onboarding/presentation/widgets/onboarding_actions.dart';
import 'package:solveit/features/onboarding/presentation/widgets/onboarding_background.dart';
import 'package:solveit/features/onboarding/presentation/widgets/onboarding_header.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';

class OnboardingModel {
  final String title;
  final String imagePath;

  OnboardingModel({required this.title, required this.imagePath});
}

class Onboardinghomescreen extends StatelessWidget {
  const Onboardinghomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          OnboardingBackground(
            child: Padding(
              padding: horizontalPadding.copyWith(bottom: context.getBottomPadding()),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20.h,
                children: const [
                  OnboardingHeader(),
                  OnboardingActions(),
                ],
              ),
            ),
          ),
          Positioned(
            child: Image.asset(
              onboarding,
              width: double.infinity,
              height: context.getHeight() * 0.6,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
