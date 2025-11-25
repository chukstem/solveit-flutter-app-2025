import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:solveit/core/injections/auth.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/login.dart';
import 'package:solveit/features/authentication/data/models/auth/responses/token.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/state_provider.dart';
import 'package:solveit/utils/utils/validators.dart';

enum LoginField { email, phone, password }

/// **Login View State Model**
class LoginState {
  // Page State
  final int pageIndex;
  bool obscurePassword;

  // Form Data
  final Map<LoginField, String> formData;
  final Map<LoginField, String?> errors;

  LoginState({
    this.pageIndex = 0,
    this.obscurePassword = true,
    this.formData = const {},
    this.errors = const {},
  });

  // Getters
  String get email => formData[LoginField.email] ?? '';
  String get phoneNumber => formData[LoginField.phone] ?? '';
  String get password => formData[LoginField.password] ?? '';
  String? get emailError => errors[LoginField.email];
  String? get phoneError => errors[LoginField.phone];
  String? get passwordError => errors[LoginField.password];

  // Helper method to check if login button should be enabled
  bool isLoginButtonEnabled() {
    if (pageIndex == 0) {
      return phoneNumber.isNotEmpty &&
          password.isNotEmpty &&
          phoneError == null &&
          passwordError == null;
    }
    return email.isNotEmpty && password.isNotEmpty && emailError == null && passwordError == null;
  }

  LoginState copyWith({
    int? pageIndex,
    bool? obscurePassword,
    Map<LoginField, String>? formData,
    Map<LoginField, String?>? errors,
  }) {
    return LoginState(
      pageIndex: pageIndex ?? this.pageIndex,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      formData: formData ?? this.formData,
      errors: errors ?? this.errors,
    );
  }
}

/// **LoginViewModel for User Authentication**
class LoginViewModel extends ChangeNotifier {
  // Internal state
  LoginState _state = LoginState();
  LoginState get state => _state;

  // Controllers
  late final PageController controller;
  Timer? _debounceTimer;

  LoginViewModel() {
    controller = PageController(initialPage: _state.pageIndex);
  }

  /// ✅ **Updates state and notifies listeners**
  void _setState({
    int? pageIndex,
    bool? obscurePassword,
    Map<LoginField, String>? formData,
    Map<LoginField, String?>? errors,
  }) {
    _state = _state.copyWith(
      pageIndex: pageIndex,
      obscurePassword: obscurePassword,
      formData: formData,
      errors: errors,
    );
    notifyListeners();
  }

  /// ✅ **Toggles password visibility**
  void togglePasswordVisibility() {
    _setState(obscurePassword: !_state.obscurePassword);
  }

  /// ✅ **Updates form field and triggers validation**
  void updateField(LoginField field, String value) {
    final updatedFormData = Map<LoginField, String>.from(_state.formData);
    updatedFormData[field] = value.trim();

    _setState(formData: updatedFormData);
    _validateField(field);
    _debounceUpdateLoginRequest();
  }

  /// ✅ **Validates a specific field**
  void _validateField(LoginField field) {
    final updatedErrors = Map<LoginField, String?>.from(_state.errors);

    switch (field) {
      case LoginField.email:
        updatedErrors[field] = Validator.emailValidator(_state.formData[field] ?? '');
        break;
      case LoginField.phone:
        updatedErrors[field] = Validator.phone(_state.formData[field] ?? '');
        break;
      case LoginField.password:
        updatedErrors[field] = Validator.password(_state.formData[field] ?? '');
        break;
    }

    _setState(errors: updatedErrors);
  }

  /// ✅ **Debounces login request updates**
  void _debounceUpdateLoginRequest() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      authViewModel.loginRequest = LoginRequest(
        email: _state.email,
        password: _state.password,
        phoneNo: _state.phoneNumber,
      );

      if (kDebugMode) {
        log('Login Request: ${authViewModel.loginRequest}');
      }
    });
  }

  /// ✅ **Handles page changes**
  void onPageChanged(int index) {
    _setState(
      pageIndex: index,
      obscurePassword: true,
      formData: {},
      errors: {},
    );
    authViewModel.clearSession();
  }

  /// ✅ **Clears form errors**
  void clearErrors() {
    _setState(errors: {});
  }

  /// ✅ **Clears all form values**
  void clearValues() {
    _setState(
      formData: {},
      errors: {},
    );
  }

  /// ✅ **Resets page index with delay**
  void resetPageIndex() {
    Timer(const Duration(seconds: 1), () {
      _setState(pageIndex: 0);
      controller.jumpTo(0);
    });
  }

  /// ✅ **Handles login API call**
  Future<bool> login({bool? isEmail}) async {
    final success = await authViewModel.login(isEmail ?? _state.pageIndex == 1);

    if (success) {
      await sl<UserStateManager>().login(
        UserToken(
          token: authViewModel.loginResponse?.token,
          user: authViewModel.loginResponse?.userData,
        ),
      );
      authViewModel.clearSession();
      clearValues();
    } else {
      notifyListeners();
    }

    return success;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    controller.dispose();
    super.dispose();
  }
}
