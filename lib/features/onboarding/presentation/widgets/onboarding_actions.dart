import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';
import 'package:solveit/utils/theme/widgets/button/houtlined_button.dart';

class OnboardingActions extends StatelessWidget {
  final VoidCallback? onRegisterPressed;
  final VoidCallback? onLoginPressed;

  const OnboardingActions({
    super.key,
    this.onRegisterPressed,
    this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.h,
      children: [
        HFilledButton(
          onPressed:
              onRegisterPressed ?? () => context.goToScreen(SolveitRoutes.registrationScreenHome),
          text: context.getLocalization()!.create_account,
        ),
        Houtlinedbutton(
          onPressed: onLoginPressed ?? () => context.goToScreen(SolveitRoutes.loginScreen),
          text: context.getLocalization()!.login,
          borderColor: context.secondaryColor,
          padding: EdgeInsets.symmetric(horizontal: 50.w),
        ),
        const SizedBox(), // Spacer at the bottom
      ],
    );
  }
}
