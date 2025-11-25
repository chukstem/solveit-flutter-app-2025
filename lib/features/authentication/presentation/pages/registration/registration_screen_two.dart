import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/login.dart';
import 'package:solveit/features/authentication/presentation/pages/reset/reset_password_screen_continue.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/auth_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/login_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/registeration_viewmodel.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/utils.dart';
import 'package:solveit/utils/theme/widgets/button/back_button.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';
import 'package:solveit/utils/theme/widgets/layouts/scollable_column.dart';
import 'package:solveit/utils/theme/widgets/textfields/htext_fields.dart';
import 'package:solveit/utils/utils/getters.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegistrationScreenState();
  }
}

class RegistrationScreenState extends State<RegistrationScreen> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((duration) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    changeNavigationBarColorCustomizable(
      "registration",
      context,
      statusBarColor: context.colorScheme.surface,
      navigationBarColor: context.colorScheme.surface,
    );
    final auth = Provider.of<AuthViewModel>(context);
    return Consumer<RegistrationViewModel>(builder: (context, viewmodel, child) {
      return Scaffold(
        appBar: AppBar(
          leading: backButton(context),
        ),
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: horizontalPadding.copyWith(bottom: context.getBottomPadding(), top: 10.h),
          child: HScollableColumn(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Text(
                context.getLocalization()!.account_details,
                style: context.titleLarge,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                context.getLocalization()!.enter_your_account_information,
                style: context.bodyMedium,
              ),
              SizedBox(
                height: 30.h,
              ),
              HTextField(
                title: "Full Name",
                hint: 'Enter full name seperated by a space.',
                value: viewmodel.state.fullName,
                error: viewmodel.state.fullNameError,
                onChange: (value) {
                  viewmodel.state.inputType = LoginInputType.name;
                  viewmodel.onTextFieldChanged(value);
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              HTextField(
                title: "Enter your email",
                value: viewmodel.state.email,
                error: viewmodel.state.emailError,
                onChange: (value) {
                  viewmodel.state.inputType = LoginInputType.email;
                  viewmodel.onTextFieldChanged(value);
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              HTextField(
                hideBorder: false,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: SvgPicture.asset(
                    nigerianFlag,
                    width: 28.w,
                    height: 28.h,
                  ),
                ),
                prefixIconConstraints: BoxConstraints(maxWidth: 28.w),
                title: context.getLocalization()!.enter_your_number,
                value: viewmodel.state.phoneNumber,
                error: viewmodel.state.phoneNumberError,
                onChange: (value) {
                  viewmodel.state.inputType = LoginInputType.phone;
                  viewmodel.onTextFieldChanged(value);
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              HTextField(
                title: viewmodel.state.gender != null ? viewmodel.state.gender! : 'Gender',
                readOnly: true,
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20.w,
                ),
                onTap: () {
                  context.showBottomSheet(GenderSelectionBottomSheet(viewmodel: viewmodel));
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              HTextField(
                value: viewmodel.state.dateOfBirth,
                title: context.getLocalization()!.date_of_birth,
                readOnly: true,
                onTap: () async {
                  final date = await selectDate(context);
                  if (date != null) {
                    addDateMethod(date);
                  }
                },
                suffixIcon: SvgPicture.asset(
                  dateOfBirthSvg,
                  width: 24.w,
                  height: 24.w,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              HTextField(
                obscureText: obscurePassword,
                value: viewmodel.state.password,
                error: viewmodel.state.passwordError,
                onChange: (value) {
                  viewmodel.state.inputType = LoginInputType.password;
                  viewmodel.onTextFieldChanged(value);
                },
                title: context.getLocalization()!.create_password,
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                  child: FaIcon(
                    obscurePassword ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                    size: 15.w,
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              HTextField(
                title: context.getLocalization()!.confirm_password,
                obscureText: obscureConfirmPassword,
                value: viewmodel.state.password2,
                error: viewmodel.state.password2Error,
                onChange: (value) {
                  viewmodel.state.inputType = LoginInputType.password2;
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
                height: 30.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: viewmodel.state.accepted,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    shape: const CircleBorder(),
                    onChanged: (changed) {
                      viewmodel.state.accepted = changed!;
                    },
                  ),
                  Expanded(
                    child: Text(
                      context.getLocalization()!.by_registerin_you_accept,
                      style: context.bodySmall
                          ?.copyWith(color: SolveitColors.textColorHint, fontSize: 11.sp),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              HFilledButton(
                text: context.getLocalization()!.continuee,
                enabled: viewmodel.state.canEnableSignupButton(),
                loading: auth.state.isLoading,
                onPressed: () {
                  viewmodel.signUp().then((value) async {
                    if (value && context.mounted) {
                      context.showSuccess('Registeration was successful!');
                      final login = context.read<LoginViewModel>();
                      auth.loginRequest = LoginRequest(
                          password: viewmodel.state.password, phoneNo: viewmodel.state.phoneNumber);
                      final val = await login.login(isEmail: false);
                      if (val) {
                        gotoNextPage();
                        if (context.mounted) {
                          getAllSchoolElements(context);
                        }
                        viewmodel.clearFields(shouldRebuild: false);
                      } else {
                        if (context.mounted) {
                          errorState(context, auth.state);
                        }
                      }
                    } else {
                      if (context.mounted) {
                        errorState(context, auth.state);
                      }
                    }
                  });
                },
              ),
              SizedBox(
                height: 16.h,
              ),
            ],
          ),
        ),
      );
    });
  }

  void addDateMethod(String date) {
    context.read<RegistrationViewModel>().state.dateOfBirth = date;
    context.read<RegistrationViewModel>().updateUi();
  }

  void gotoNextPage() {
    context.go(SolveitRoutes.verifyEmailScreen.route);
  }
}

class GenderSelectionBottomSheet extends StatefulWidget {
  const GenderSelectionBottomSheet({
    super.key,
    required this.viewmodel,
  });

  final RegistrationViewModel viewmodel;

  @override
  State<GenderSelectionBottomSheet> createState() => _GenderSelectionBottomSheetState();
}

List<String> genders = [
  "Male",
  "Female",
];
String _selectedLevel = "";

class _GenderSelectionBottomSheetState extends State<GenderSelectionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.sp)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select your gender',
                style: context.titleSmall,
              ),
              IconButton(
                icon: SvgPicture.asset(closeIconSvg),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 2,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final gender = genders[index];

                return GestureDetector(
                  onTap: () {
                    _selectedLevel = gender;
                    widget.viewmodel.state.gender = gender;

                    _selectedLevel = '';
                    widget.viewmodel.updateUi();
                    Navigator.pop(context);
                  },
                  child: Container(
                      padding: EdgeInsets.all(14.sp),
                      decoration: BoxDecoration(
                        color: _selectedLevel == gender ? Colors.purple.shade50 : null,
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      child: Text(
                        gender,
                        style: context.bodySmall,
                      )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
