import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';
import 'package:solveit/utils/theme/widgets/layouts/scollable_column.dart';

class LoginSocialsForm extends StatelessWidget {
  final VoidCallback onGoogleLogin;
  final VoidCallback onFacebookLogin;
  final VoidCallback onAppleLogin;

  const LoginSocialsForm({
    super.key,
    required this.onGoogleLogin,
    required this.onFacebookLogin,
    required this.onAppleLogin,
  });

  @override
  Widget build(BuildContext context) {
    return HScollableColumn(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        HFilledButton(
          text: context.getLocalization()!.continue_with_facebook,
          startIcon2: facebookSvg,
          bgColor: context.colorScheme.surface,
          onPressed: onFacebookLogin,
        ),
        SizedBox(
          height: 20.h,
        ),
        HFilledButton(
          text: context.getLocalization()!.continue_with_google,
          startIcon2: googleSvg,
          bgColor: context.colorScheme.surface,
          onPressed: onGoogleLogin,
        ),
        SizedBox(
          height: 20.h,
        ),
        HFilledButton(
          text: context.getLocalization()!.continue_with_apple,
          startIcon2: appleSvg,
          bgColor: context.colorScheme.surface,
          onPressed: onAppleLogin,
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
