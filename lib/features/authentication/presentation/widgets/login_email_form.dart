import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/login_viewmodel.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/layouts/scollable_column.dart';
import 'package:solveit/utils/theme/widgets/textfields/htext_fields.dart';

class LoginEmailForm extends StatefulWidget {
  final LoginState state;
  final Function(LoginField, String) onUpdateField;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onNavigateToResetPassword;
  final VoidCallback onClearErrors;
  final VoidCallback onResetPageIndex;

  const LoginEmailForm({
    super.key,
    required this.state,
    required this.onUpdateField,
    required this.onTogglePasswordVisibility,
    required this.onNavigateToResetPassword,
    required this.onClearErrors,
    required this.onResetPageIndex,
  });

  @override
  State<LoginEmailForm> createState() => _LoginEmailFormState();
}

class _LoginEmailFormState extends State<LoginEmailForm> {
  @override
  Widget build(BuildContext context) {
    return HScollableColumn(crossAxisAlignment: CrossAxisAlignment.center, children: [
      HTextField(
        title: context.getLocalization()!.email,
        hint: "Enter your email",
        value: widget.state.email,
        error: widget.state.emailError,
        onChange: (value) => widget.onUpdateField(LoginField.email, value),
      ),
      SizedBox(
        height: 20.h,
      ),
      HTextField(
        hint: context.getLocalization()!.enter_password,
        title: context.getLocalization()!.password,
        obscureText: widget.state.obscurePassword,
        value: widget.state.password,
        error: widget.state.passwordError,
        onChange: (value) => widget.onUpdateField(LoginField.password, value),
        suffixIcon: InkWell(
            onTap: widget.onTogglePasswordVisibility,
            child: widget.state.obscurePassword
                ? SvgPicture.asset(
                    eyeClosedSvg,
                    width: 15.w,
                  )
                : FaIcon(
                    FontAwesomeIcons.eye,
                    size: 15.w,
                  )),
      ),
      SizedBox(
        height: 10.h,
      ),
      Row(
        children: [
          const Spacer(),
          InkWell(
            onTap: () {
              widget.onClearErrors();
              context.goToScreen(SolveitRoutes.resetPassword);
              widget.onResetPageIndex();
            },
            child: Text(context.getLocalization()!.reset_password, style: context.headlineSmall),
          ),
        ],
      ),
    ]);
  }
}
