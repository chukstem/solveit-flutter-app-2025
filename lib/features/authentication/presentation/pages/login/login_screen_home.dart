import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/authentication/presentation/pages/login/login_screen.dart';
import 'package:solveit/features/authentication/presentation/pages/login/login_screen_email.dart';
import 'package:solveit/features/authentication/presentation/pages/login/login_screen_socials.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/auth_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/login_viewmodel.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/back_button.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';
import 'package:solveit/utils/theme/widgets/tab/h_tab.dart';
import 'package:solveit/utils/theme/widgets/text/clickable_text.dart';
import 'package:solveit/utils/utils/getters.dart';

class LoginscreenHome extends StatefulWidget {
  const LoginscreenHome({super.key});

  @override
  State<LoginscreenHome> createState() => _LoginscreenHomeState();
}

class _LoginscreenHomeState extends State<LoginscreenHome> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<LoginViewModel, AuthViewModel>(
      builder: (context, loginViewModel, authViewModel, _) {
        final loginState = loginViewModel.state;
        final authState = authViewModel.state;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: false,
          appBar: _buildAppBar(context, loginViewModel),
          bottomNavigationBar: _buildBottomNavBar(
            context,
            loginViewModel,
            authViewModel,
            loginState.pageIndex,
            loginState.isLoginButtonEnabled(),
            authState.isLoading,
          ),
          body: SafeArea(
            child: Padding(
              padding: horizontalPadding.copyWith(bottom: context.getBottomPadding(), top: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h),
                  _buildHeader(context),
                  SizedBox(height: 30.h),
                  _buildTabsRow(context, loginViewModel, loginState.pageIndex),
                  SizedBox(height: 30.h),
                  Expanded(
                    child: PageView(
                      onPageChanged: loginViewModel.onPageChanged,
                      pageSnapping: true,
                      controller: loginViewModel.controller,
                      children: const [
                        Loginscreen(),
                        LoginscreenEmail(),
                        LoginscreenSocials(),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, LoginViewModel viewModel) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: context.canPop()
          ? backButton(context, onTap: () {
              context.pop();
              viewModel.clearValues();
              viewModel.resetPageIndex();
            })
          : const SizedBox.shrink(),
      actions: [
        HClickableText(
          text: context.getLocalization()!.sign_up,
          onClick: () {
            context.goToScreen(SolveitRoutes.registrationScreenHome);
            viewModel.clearValues();
            viewModel.resetPageIndex();
          },
        )
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: context.getWidth(),
          child: Text(
            context.getLocalization()!.welcome_back,
            textAlign: TextAlign.start,
            style: context.titleMedium,
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          width: context.getWidth(),
          child: Text(
            context.getLocalization()!.log_in_to_your_account,
            textAlign: TextAlign.start,
            style: context.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildTabsRow(BuildContext context, LoginViewModel viewModel, int currentIndex) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          HTab(
              text: context.getLocalization()!.phone_number,
              isActive: currentIndex == 0,
              onTap: () {
                viewModel.controller.animateToPage(0,
                    duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              }),
          SizedBox(width: 20.w),
          HTab(
              text: context.getLocalization()!.email,
              isActive: currentIndex == 1,
              onTap: () {
                viewModel.controller.animateToPage(1,
                    duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              }),
          SizedBox(width: 20.w),
          HTab(
              text: context.getLocalization()!.social,
              isActive: currentIndex == 2,
              onTap: () {
                viewModel.controller.animateToPage(2,
                    duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              }),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(
    BuildContext context,
    LoginViewModel loginViewModel,
    AuthViewModel authViewModel,
    int pageIndex,
    bool isLoginEnabled,
    bool isLoading,
  ) {
    return Padding(
      padding: horizontalPadding.copyWith(bottom: context.getBottomPadding() + 16.h),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        child: pageIndex == 2
            ? const SizedBox()
            : HFilledButton(
                text: context.getLocalization()!.continuee,
                enabled: isLoginEnabled,
                onPressed: () async {
                  await loginViewModel.login().then((val) {
                    if (val && context.mounted) {
                      context.showSuccess('Login successful!');
                      getAllSchoolElements(context);
                      context.go(SolveitRoutes.homeScreen.route);
                    } else {
                      if (context.mounted) {
                        _showAuthError(context, authViewModel.state);
                      }
                    }
                  });
                },
                loading: isLoading,
              ),
      ),
    );
  }

  void _showAuthError(BuildContext context, AuthState state) {
    if (state.errorMessage != null) {
      context.showError(state.errorMessage!);
    } else {
      context.showError('Login failed. Please try again.');
    }
  }
}
