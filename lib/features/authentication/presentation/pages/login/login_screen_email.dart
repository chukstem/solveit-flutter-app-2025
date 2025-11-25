import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/login_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/widgets/login_email_form.dart';

class LoginscreenEmail extends StatelessWidget {
  const LoginscreenEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, _) {
        final state = viewModel.state;

        return LoginEmailForm(
          state: state,
          onUpdateField: viewModel.updateField,
          onTogglePasswordVisibility: viewModel.togglePasswordVisibility,
          onNavigateToResetPassword: () {},
          onClearErrors: viewModel.clearErrors,
          onResetPageIndex: viewModel.resetPageIndex,
        );
      },
    );
  }
}
