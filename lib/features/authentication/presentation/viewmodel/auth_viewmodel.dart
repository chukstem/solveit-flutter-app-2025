// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:solveit/core/injections/auth.dart';
import 'package:solveit/core/network/network.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/forgot_pass.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/login.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/resend_code.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/reset_pass.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/signup.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/verify_email.dart';
import 'package:solveit/features/authentication/data/models/auth/responses/auth_response.dart';
import 'package:solveit/features/authentication/data/models/auth/responses/users_response.dart';

/// **Authentication State Model**
class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final Failure? failure;

  AuthState({this.isLoading = false, this.errorMessage, this.failure});

  @override
  String toString() => 'AuthState(isLoading: $isLoading, errorMessage: $errorMessage, failure: $failure)';

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    Failure? failure,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
    );
  }
}

/// **AuthViewModel for Authentication Logic**
class AuthViewModel extends ChangeNotifier {
  AuthState _state = AuthState();
  AuthState get state => _state;

  LoginRequest? loginRequest;
  CreateStudentRequest? createStudentRequest;
  ForgotPasswordRequest? forgotPasswordRequest;
  VerifyEmailRequest? verifyEmailRequest;
  ResendCodeRequest? resendCodeRequest;
  ResetPasswordRequest? resetPasswordRequest;

  AuthResponse? authResponse;
  AllStudentsOrUserResponse? allStudentsOrUserResponse;
  LoginResponse? loginResponse;

  /// ✅ **Handles API calls and updates state**
  Future<bool> _handleApiCall(Future<Either<Failure, dynamic>> Function() apiCall) async {
    _setState(isLoading: true);
    _clearErrors();

    try {
      final result = await apiCall();
      return result.fold(
        (failure) {
          _setError(failure);
          return false;
        },
        (success) {
          if (success is LoginResponse) {
            loginResponse = success;
          } else if (success is AllStudentsOrUserResponse) {
            allStudentsOrUserResponse = success;
          } else if (success is AuthResponse) {
            authResponse = success;
          }

          _clearRequests();
          return true;
        },
      );
    } catch (e) {
      _setError(GenericFailure(message: e.toString()));
      return false;
    } finally {
      _setState(isLoading: false);
    }
  }

  /// ✅ **Updates UI state**
  void _setState({bool? isLoading, String? errorMessage, Failure? failure}) {
    _state = _state.copyWith(
      isLoading: isLoading,
      errorMessage: errorMessage,
      failure: failure,
    );

    Timer(const Duration(milliseconds: 30), () => notifyListeners());
  }

  /// ✅ **Clears error messages and failure objects**
  void _clearErrors() {
    _setState(
      errorMessage: null,
      failure: null,
    );
  }

  /// ✅ **Stores error details for debugging**
  void _setError(Failure failure) {
    _setState(errorMessage: failure.message, failure: failure);
  }

  /// ✅ **Clears all request objects to free memory**
  void _clearRequests() {
    loginRequest = null;
    createStudentRequest = null;
    forgotPasswordRequest = null;
    verifyEmailRequest = null;
    resendCodeRequest = null;
    resetPasswordRequest = null;
  }

  /// ✅ **Authentication API Calls**
  Future<bool> login(bool isEmail) async => _handleApiCall(() => authService.login(loginRequest!, isEmail));

  Future<bool> signUp() async => _handleApiCall(
        () => authService.signUpStudent(createStudentRequest!),
      );

  Future<bool> signUpStudent() async => _handleApiCall(
        () => authService.signUpStudent(createStudentRequest!),
      );

  Future<bool> getUserOrStudent(bool isStudent, String id) async => _handleApiCall(
        () => authService.getUser(isStudent, id),
      );

  Future<bool> getUsersOrStudents(bool isStudent) async => _handleApiCall(
        () => authService.getAllUsers(isStudent),
      );

  Future<bool> forgotPassword() async => _handleApiCall(
        () => authService.forgotPassword(forgotPasswordRequest!),
      );

  Future<bool> verifyEmail() async => _handleApiCall(
        () => authService.verifyEmail(verifyEmailRequest!),
      );

  Future<bool> resetPassword() async => _handleApiCall(
        () => authService.resetPassword(resetPasswordRequest!),
      );

  Future<bool> resendCode() async => _handleApiCall(
        () => authService.resendCode(resendCodeRequest!),
      );

  /// ✅ **Clears session data (e.g., on logout)**
  void clearSession() {
    _clearRequests();
    _clearErrors();
    notifyListeners();
  }
}
