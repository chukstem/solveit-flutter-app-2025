import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/auth_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/login_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/otp_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/registeration_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/reset_password.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/state_provider.dart';

final authViewmodels = <SingleChildWidget>[
  ChangeNotifierProvider<AuthViewModel>(create: (_) => sl<AuthViewModel>()),
  ChangeNotifierProvider<LoginViewModel>(create: (_) => sl<LoginViewModel>()),
  ChangeNotifierProvider<ResetPasswordViewModel>(
      create: (_) => sl<ResetPasswordViewModel>()),
  ChangeNotifierProvider<RegistrationViewModel>(
      create: (_) => sl<RegistrationViewModel>()),
  ChangeNotifierProvider<OtpVerificationViewModel>(
      create: (_) => sl<OtpVerificationViewModel>()),
  ChangeNotifierProvider<UserStateManager>(
      create: (_) => sl<UserStateManager>()),
];
