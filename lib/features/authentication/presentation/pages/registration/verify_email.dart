import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/resend_code.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/auth_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/otp_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/registeration_viewmodel.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/back_button.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OtpVerificationViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leadingWidth: 45.w,
            leading: backButton(context, icon: Icons.close, onTap: () {
              context.popToScreen(SolveitRoutes.homeScreen);
            }),
          ),
          bottomNavigationBar: Padding(
            padding:
                EdgeInsets.only(left: 16.h, right: 16.h, bottom: context.getBottomPadding() + 16.h),
            child: HFilledButton(
              text: context.getLocalization()!.verify,
              enabled: viewModel.state.isComplete,
              loading: context.watch<AuthViewModel>().state.isLoading,
              onPressed: () async {
                final authViewModel = context.read<AuthViewModel>();
                final registrationViewModel = context.read<RegistrationViewModel>();
                
                // Get email from registration state
                final email = registrationViewModel.state.email;
                
                if (email.isEmpty) {
                  context.showError('Email not found. Please register again.');
                  return;
                }
                
                // Verify email with OTP code
                final otpCode = viewModel.state.otpCode;
                if (otpCode.length != 6) {
                  context.showError('Please enter a valid 6-digit code');
                  return;
                }
                
                // Call verify email API
                final success = await registrationViewModel.verifyEmail(otpCode);
                
                if (success && context.mounted) {
                  context.showSuccess('Email verification successful!');
                  await Future.delayed(const Duration(seconds: 1), () {
                    if (context.mounted) {
                      context.go(SolveitRoutes.homeScreen.route);
                      viewModel.clearValues();
                    }
                  });
                } else if (context.mounted) {
                  viewModel._setState(
                    isError: true,
                    errorMessage: authViewModel.state.errorMessage ?? 'Invalid verification code. Please try again.',
                  );
                }
              },
            ),
          ),
          body: Padding(
            padding: horizontalPadding.copyWith(bottom: context.getBottomPadding(), top: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Verification 🤗",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "Enter the 6 digits code sent to your phone number for verification",
                  textAlign: TextAlign.start,
                  style: context.bodyMedium?.copyWith(),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    6,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: SizedBox(
                        width: 45,
                        height: 50,
                        child: Focus(
                          onKeyEvent: (node, event) {
                            if (event.logicalKey == LogicalKeyboardKey.backspace &&
                                event is KeyDownEvent &&
                                viewModel.otpControllers[index].text.isEmpty &&
                                index > 0) {
                              FocusScope.of(node.context!)
                                  .requestFocus(viewModel.focusNodes[index - 1]);
                              viewModel.otpControllers[index - 1].clear();
                              return KeyEventResult.handled;
                            }
                            viewModel.updateUi();
                            return KeyEventResult.ignored;
                          },
                          child: TextField(
                            controller: viewModel.otpControllers[index],
                            focusNode: viewModel.focusNodes[index],
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: context.bodyLarge,
                            decoration: InputDecoration(
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: viewModel.state.isError
                                      ? context.errorColor
                                      : Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: viewModel.state.isError
                                      ? context.errorColor
                                      : context.secondaryColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) => viewModel.onOtpChanged(value, index, context),
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (viewModel.state.isError)
                  Column(
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.info_outline, color: Colors.red, size: 18),
                          const SizedBox(width: 5),
                          Text(
                            viewModel.state.errorMessage,
                            style: const TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Center(
                      child: Text(
                        "You didn't receive any code?",
                        style: context.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    viewModel.state.remainingTime > 0
                        ? _buildCircularCountdown(viewModel)
                        : ElevatedButton(
                            onPressed: () async {
                              final authViewModel = context.read<AuthViewModel>();
                              final registrationViewModel = context.read<RegistrationViewModel>();
                              
                              // Get email from registration state
                              final email = registrationViewModel.state.email;
                              
                              if (email.isEmpty) {
                                context.showError('Email not found. Please register again.');
                                return;
                              }
                              
                              // Resend code
                              authViewModel.resendCodeRequest = ResendCodeRequest(email: email);
                              final success = await authViewModel.resendCode();
                              
                              if (success && context.mounted) {
                                context.showSuccess('Verification code sent successfully!');
                                viewModel.resendCode();
                              } else if (context.mounted) {
                                context.showError(authViewModel.state.errorMessage ?? 'Failed to resend code. Please try again.');
                              }
                            },
                            style: ElevatedButton.styleFrom(),
                            child: Text("Resend Code",
                                style: context.bodySmall?.copyWith(
                                  color: context.primaryColor,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _buildCircularCountdown(OtpVerificationViewModel viewModel) {
  return SizedBox(
    width: 70,
    height: 70,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: CircularProgressIndicator(
            value: viewModel.state.remainingTime / 60, // Progress
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
            backgroundColor: Colors.grey.shade300,
            strokeWidth: 5,
            strokeCap: StrokeCap.round,
            strokeAlign: CircularProgressIndicator.strokeAlignInside,
          ),
        ),
        Text(
          "0:${viewModel.state.remainingTime.toString().padLeft(2, '0')}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}
