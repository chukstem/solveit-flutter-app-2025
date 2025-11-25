import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/login_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/widgets/login_form.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, _) {
        final state = viewModel.state;

        return LoginForm(
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
