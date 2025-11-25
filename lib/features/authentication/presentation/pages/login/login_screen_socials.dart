import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/login_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/widgets/login_socials_form.dart';

class LoginscreenSocials extends StatelessWidget {
  const LoginscreenSocials({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, _) {
        // Handle social login callbacks
        void handleGoogleLogin() {
          // Implement Google login
        }

        void handleFacebookLogin() {
          // Implement Facebook login
        }

        void handleAppleLogin() {
          // Implement Apple login
        }

        return LoginSocialsForm(
          onGoogleLogin: handleGoogleLogin,
          onFacebookLogin: handleFacebookLogin,
          onAppleLogin: handleAppleLogin,
        );
      },
    );
  }
}
