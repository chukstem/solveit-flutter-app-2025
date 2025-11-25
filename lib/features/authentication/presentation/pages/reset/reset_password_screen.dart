import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/authentication/presentation/pages/reset/reset_password_screen_continue.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/auth_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/registeration_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/reset_password.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/utils.dart';
import 'package:solveit/utils/theme/widgets/button/back_button.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';
import 'package:solveit/utils/theme/widgets/layouts/scollable_column.dart';
import 'package:solveit/utils/theme/widgets/text/text_with_icon.dart';
import 'package:solveit/utils/theme/widgets/textfields/htext_fields.dart';

class Resetpasswordscreen extends StatefulWidget {
  const Resetpasswordscreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ResetpasswordscreenState();
  }
}

class _ResetpasswordscreenState extends State<Resetpasswordscreen> {
  bool obscurePassword = false;

  @override
  Widget build(BuildContext context) {
    changeNavigationBarColorCustomizable(
      "resetpass",
      context,
      statusBarColor: Colors.transparent,
      navigationBarColor: context.colorScheme.surface,
    );
    final authviewmodel = Provider.of<AuthViewModel>(context);
    return Consumer<ResetPasswordViewModel>(builder: (context, viewmodel, child) {
      log((viewmodel.state.emailError != null && !viewmodel.state.linkSent).toString());
      return Scaffold(
        appBar: AppBar(
          leading: backButton(
            context,
            onTap: () {
              context.pop();
              viewmodel.clearFields();
            },
          ),
        ),
        bottomNavigationBar: Padding(
          padding: horizontalPadding.copyWith(bottom: context.getBottomPadding() + 16.h),
          child: HFilledButton(
            text: viewmodel.state.linkSent
                ? context.getLocalization()!.continuee
                : context.getLocalization()!.send_link,
            enabled: viewmodel.state.canRequestResetLink || viewmodel.state.linkSent,
            loading: authviewmodel.state.isLoading,
            onPressed: () async {
              if (viewmodel.state.linkSent) {
                gotoScreenTwo();
              } else {
                viewmodel.forgotPassword().then((val) async {
                  if (val && context.mounted) {
                    context.showSuccess("Password Reset Link has been sent to your email address");
                  } else {
                    if (context.mounted) {
                      errorState(context, authviewmodel.state);
                    }
                  }
                });
              }
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: horizontalPadding.copyWith(bottom: context.getBottomPadding(), top: 10.h),
            child: HScollableColumn(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                width: context.getWidth(),
                child: Text(
                  context.getLocalization()!.reset_your_password,
                  textAlign: TextAlign.start,
                  style: context.titleMedium,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                width: context.getWidth(),
                child: Text(
                  "We'll send a password resent link to your email address",
                  textAlign: TextAlign.start,
                  style: context.bodyMedium,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              HTextField(
                title: context.getLocalization()!.email_address,
                value: viewmodel.state.email,
                error: viewmodel.state.emailError,
                onChange: (value) {
                  viewmodel.inputType = LoginInputType.email;
                  viewmodel.onTextFieldChanged(value);
                },
              ),
              if (viewmodel.state.linkSent) ...[
                SizedBox(
                  height: 5.h,
                ),
                HTextWithIcon(
                  text: context.getLocalization()!.password_rsent_link_has(viewmodel.state.email),
                  style: context.bodySmall?.copyWith(
                    color: context.tertiaryColor,
                  ),
                  icon: Icons.check_circle,
                  align: TextAlign.start,
                  isExpanded: true,
                  tint: context.tertiaryColor,
                  spacing: 5.w,
                  iconSize: 20.w,
                ),
              ],
              SizedBox(
                height: 20.h,
              ),
            ]),
          ),
        ),
      );
    });
  }

  void gotoScreenTwo() {
    context.goToScreen(SolveitRoutes.resetpasswordContinueRoute);
  }
}
