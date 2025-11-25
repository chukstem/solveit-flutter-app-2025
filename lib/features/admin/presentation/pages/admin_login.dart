import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/admin/presentation/viewmodel/admin_viewmodel.dart';
import 'package:solveit/features/admin/presentation/widgets/admin_login_form.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AdminViewModel>(
          builder: (context, viewModel, _) {
            final state = viewModel.state;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Admin Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.getWidth() * 0.3),
                      child: AdminLoginForm(
                        isLoading: state.isLoading,
                        onLogin: (email, password) async {
                          final success = await viewModel.login(
                            email: email,
                            password: password,
                          );

                          if (success && context.mounted) {
                            context.showSuccess('Login successful!');
                            context.go(SolveitRoutes.adminDashboard.route);
                          } else if (context.mounted) {
                            final errorMessage = state.errorMessage;
                            context.showError(errorMessage ?? 'Login failed. Please try again.');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
