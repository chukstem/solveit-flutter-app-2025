// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/forgot_pass.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/reset_pass.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/auth_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/registeration_viewmodel.dart';
import 'package:solveit/utils/utils/validators.dart';

/// **Reset Password State Model**
class ResetPasswordState {
  String email;
  String token;
  String password;
  String password2;
  String? emailError;
  String? passwordError;
  String? passwordError2;
  bool linkSent;

  ResetPasswordState({
    this.email = '',
    this.token = '',
    this.password = '',
    this.password2 = '',
    this.emailError,
    this.passwordError,
    this.passwordError2,
    this.linkSent = false,
  });

  bool get canResetPassword =>
      email.isNotEmpty &&
      token.isNotEmpty &&
      password.isNotEmpty &&
      password2.isNotEmpty &&
      password == password2;

  bool get canRequestResetLink => email.isNotEmpty && emailError == null;

  ResetPasswordState copyWith({
    String? email,
    String? token,
    String? password,
    String? password2,
    String? emailError,
    String? passwordError,
    String? passwordError2,
    bool? linkSent,
  }) {
    return ResetPasswordState(
      email: email ?? this.email,
      token: token ?? this.token,
      password: password ?? this.password,
      password2: password2 ?? this.password2,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      passwordError2: passwordError2 ?? this.passwordError2,
      linkSent: linkSent ?? this.linkSent,
    );
  }
}

/// **ResetPasswordViewModel for Password Recovery Flow**
class ResetPasswordViewModel extends ChangeNotifier {
  // State and services
  ResetPasswordState _state = ResetPasswordState();
  ResetPasswordState get state => _state;

  final AuthViewModel authViewModel = sl<AuthViewModel>();
  LoginInputType inputType = LoginInputType.email;

  ResetPasswordViewModel();

  /// ✅ **Updates state and notifies listeners**
  void _setState({
    String? email,
    String? token,
    String? password,
    String? password2,
    String? emailError,
    String? passwordError,
    String? passwordError2,
    bool? linkSent,
  }) {
    _state = _state.copyWith(
      email: email,
      token: token,
      password: password,
      password2: password2,
      emailError: emailError,
      passwordError: passwordError,
      passwordError2: passwordError2,
      linkSent: linkSent,
    );
    notifyListeners();
  }

  /// ✅ **Handles text input validation & updates API requests**
  void onTextFieldChanged(String val) {
    switch (inputType) {
      case LoginInputType.email:
        final error = Validator.emailValidator(val);
        _setState(email: val, emailError: error);
        authViewModel.forgotPasswordRequest = ForgotPasswordRequest(email: val);
        break;
      case LoginInputType.token:
        _setState(token: val);
        break;
      case LoginInputType.password:
        final error = Validator.password(val);
        _setState(password: val, passwordError: error);
        break;
      case LoginInputType.password2:
        final error = Validator.password(val);
        _setState(password2: val, passwordError2: error);
        break;
      default:
    }

    authViewModel.resetPasswordRequest = ResetPasswordRequest(
      email: _state.email,
      password: _state.password,
      verificationCode: _state.token,
    );
  }

  /// ✅ **Handles Forgot Password API Call**
  Future<bool> forgotPassword() async {
    bool success = await authViewModel.forgotPassword();
    if (success) {
      _setState(linkSent: true);
    }
    return success;
  }

  /// ✅ **Handles Reset Password API Call**
  Future<bool> resetPassword() async {
    bool success = await authViewModel.resetPassword();
    return success;
  }

  /// ✅ **Clears all input fields and state**
  void clearFields() {
    _setState(
      email: '',
      password: '',
      password2: '',
      token: '',
      linkSent: false,
      emailError: null,
      passwordError: null,
      passwordError2: null,
    );
  }
}
