import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:solveit/core/network/utils/exceptions.dart';
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
import 'package:solveit/utils/theme/widgets/textfields/htext_fields.dart';
import 'package:solveit/utils/utils/sheets.dart';

class ResetpasswordscreenContinue extends StatefulWidget {
  const ResetpasswordscreenContinue({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ResetpasswordscreenState();
  }
}

class _ResetpasswordscreenState extends State<ResetpasswordscreenContinue> {
  bool obscurePassword = false;
  bool obscureConfirmPassword = false;
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
      return Scaffold(
        appBar: AppBar(
          leading: backButton(context),
        ),
        bottomNavigationBar: Padding(
          padding: horizontalPadding.copyWith(bottom: context.getBottomPadding() + 16.h),
          child: HFilledButton(
            text: context.getLocalization()!.reset_password,
            enabled:
                viewmodel.state.passwordError == null && viewmodel.state.passwordError2 == null,
            loading: authviewmodel.state.isLoading,
            onPressed: () {
              authviewmodel.resetPassword().then((val) async {
                if (val) {
                  if (context.mounted) {
                    context.showSuccess("Password Reset Successful");
                  }
                  await Future.delayed(const Duration(seconds: 2), () => gotoLogin()).then((s) {
                    viewmodel.clearFields();
                  });
                } else {
                  if (context.mounted) errorState(context, authviewmodel.state);
                }
              });
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: horizontalPadding.copyWith(bottom: context.getBottomPadding(), top: 10.h),
            child: HScollableColumn(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  width: context.getWidth(),
                  child: Text(
                    "New Password",
                    textAlign: TextAlign.start,
                    style: context.titleLarge,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  width: context.getWidth(),
                  child: Text(
                    "Create a new password",
                    textAlign: TextAlign.start,
                    style: context.bodyMedium,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                HTextField(
                  title: 'Code',
                  onChange: (value) {
                    viewmodel.inputType = LoginInputType.token;
                    viewmodel.onTextFieldChanged(value);
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                HTextField(
                  title: context.getLocalization()!.new_password,
                  isPassword: true,
                  error: viewmodel.state.passwordError,
                  value: viewmodel.state.password,
                  obscureText: obscurePassword,
                  onChange: (value) {
                    viewmodel.inputType = LoginInputType.password;
                    viewmodel.onTextFieldChanged(value);
                  },
                  suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                      child: FaIcon(
                        obscureConfirmPassword ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                        size: 15.w,
                      )),
                ),
                SizedBox(
                  height: 16.h,
                ),
                HTextField(
                  title: context.getLocalization()!.confirm_password,
                  isPassword: true,
                  obscureText: obscureConfirmPassword,
                  value: viewmodel.state.password2,
                  error: viewmodel.state.passwordError2,
                  onChange: (value) {
                    viewmodel.inputType = LoginInputType.password2;
                    viewmodel.onTextFieldChanged(value);
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void gotoLogin() {
    context.goToScreen(SolveitRoutes.loginScreen);
  }
}

void errorState(BuildContext context, AuthState state) {
  if (state.failure != null) {
    if (state.failure?.exception is OtherExceptions) {
      context.showError(state.errorMessage ?? "Something went wrong, try again later!");
    } else if (state.failure?.exception is TimeoutException) {
      showPoorNetworkSheet(context, () async {});
    } else if (state.failure?.exception is InternetConnectException) {
      showYouAreOfflineSheet(
        context,
      );
    } else if (state.failure?.exception is SocketException) {
      showYouAreOfflineSheet(context);
    } else {
      context.showError(state.errorMessage ?? "Something went wrong, try again later!");
    }
  }
}
