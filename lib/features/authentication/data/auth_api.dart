import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:solveit/core/network/api/network_routes.dart';
import 'package:solveit/core/network/network.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/forgot_pass.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/login.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/resend_code.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/reset_pass.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/signup.dart';
import 'package:solveit/features/authentication/data/models/auth/requests/verify_email.dart';
import 'package:solveit/features/authentication/data/models/auth/responses/auth_response.dart';
import 'package:solveit/features/authentication/data/models/auth/responses/general.dart';
import 'package:solveit/features/authentication/data/models/auth/responses/get_user_response.dart';
import 'package:solveit/features/authentication/data/models/auth/responses/users_response.dart';

abstract class AuthApi {
  Future<Either<Failure, LoginResponse>> login(LoginRequest req, bool isEmail);
  Future<Either<Failure, AuthResponse>> signUpUser(SignupRequest req);
  Future<Either<Failure, AuthResponse>> signUpStudent(CreateStudentRequest req);
  Future<Either<Failure, GenericAuthResponse>> verifyEmail(VerifyEmailRequest req);
  Future<Either<Failure, GenericAuthResponse>> resendCode(ResendCodeRequest req);
  Future<Either<Failure, GenericAuthResponse>> forgotPassword(ForgotPasswordRequest req);
  Future<Either<Failure, GenericAuthResponse>> resetPassword(ResetPasswordRequest req);
  Future<Either<Failure, StudentOrUserModel>> getUser(bool isStudent, String id);
  Future<Either<Failure, AllStudentsOrUserResponse>> getAllUsers(bool isStudent);
  Future<Either<Failure, Map<String, dynamic>>> refreshProfile();
  Future<Either<Failure, Map<String, dynamic>>> updateLevel(int levelId);
  Future<Either<Failure, Map<String, dynamic>>> getUserForums();
  Future<Either<Failure, Map<String, dynamic>>> getSettings();
  Future<Either<Failure, Map<String, dynamic>>> updateSettings(Map<String, dynamic> settings);
}

class AuthApiImplementation extends AuthApi {
  final ApiClient apiClient;

  AuthApiImplementation({required this.apiClient});

  /// **Generic helper for making API POST requests**
  Future<Either<ApiFailure, T>> _postRequest<T>(String url, dynamic req, T Function(Map<String, dynamic>) fromJson, {bool? isFormData = false}) async {
    try {
      final Map<String, dynamic>? data;
      if (req is Map<String, dynamic>) {
        data = req;
      } else if (isFormData == true) {
        data = null;
      } else {
        data = req.toMap();
      }
      
      final response = await apiClient.post(
        url, 
        data: isFormData == true ? null : data,
        formData: isFormData == true ? req.toFormData() : null
      );
      return right(fromJson(response.data));
    } on ApiException catch (e, s) {
      log("API Exception in POST [$url]: ${e.message}${e.runtimeType}\n:::###🥲\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in POST [$url]: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  Future<Either<ApiFailure, T>> _getRequest<T>(String url, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final response = await apiClient.get(
        url,
      );
      return right(fromJson(response.data));
    } on ApiException catch (e, s) {
      log("API Exception in POST [$url]: ${e.message}${e.runtimeType}\n:::###🥲\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in POST [$url]: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  @override
  Future<Either<ApiFailure, GenericAuthResponse>> forgotPassword(req) async {
    return _postRequest(authEndpoints.forgotPassword, req, GenericAuthResponse.fromMap);
  }

  @override
  Future<Either<ApiFailure, LoginResponse>> login(req, bool isEmail) async {
    // Backend uses single endpoint that accepts both email and phone
    return _postRequest(authEndpoints.loginUrl, req, LoginResponse.fromMap);
  }

  @override
  Future<Either<ApiFailure, GenericAuthResponse>> resendCode(req) async {
    return _postRequest(authEndpoints.resendCode, req, GenericAuthResponse.fromMap);
  }

  @override
  Future<Either<ApiFailure, GenericAuthResponse>> resetPassword(req) async {
    return _postRequest(authEndpoints.resetPassword, req, GenericAuthResponse.fromMap);
  }

  @override
  Future<Either<ApiFailure, AuthResponse>> signUpUser(req) async {
    return _postRequest(authEndpoints.signUpUser, req, AuthResponse.fromMap);
  }

  @override
  Future<Either<ApiFailure, GenericAuthResponse>> verifyEmail(req) async {
    return _postRequest(authEndpoints.verifyEmail, req, GenericAuthResponse.fromMap);
  }

  @override
  Future<Either<Failure, AuthResponse>> signUpStudent(req) {
    return _postRequest(authEndpoints.signUpStudent, req, AuthResponse.fromMap, isFormData: true);
  }

  @override
  Future<Either<Failure, AllStudentsOrUserResponse>> getAllUsers(isStudent) {
    return _getRequest(isStudent ? authEndpoints.getStudents : authEndpoints.getUsers, AllStudentsOrUserResponse.fromMap);
  }

  @override
  Future<Either<Failure, StudentOrUserModel>> getUser(isStudent, id) {
    return _getRequest(isStudent ? authEndpoints.getStudent(id) : authEndpoints.getUser(id), StudentOrUserModel.fromMap);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> refreshProfile() {
    return _getRequest(authEndpoints.refreshProfile, (json) => json as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateLevel(int levelId) {
    return _postRequest(
      authEndpoints.updateLevel,
      {'level_id': levelId} as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUserForums() {
    return _getRequest(authEndpoints.getUserForums, (json) => json as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSettings() {
    return _getRequest(authEndpoints.getSettings, (json) => json as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateSettings(Map<String, dynamic> settings) {
    return _postRequest(
      authEndpoints.updateSettings,
      settings,
      (json) => json as Map<String, dynamic>,
    );
  }
}
