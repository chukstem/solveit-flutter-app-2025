import 'package:dartz/dartz.dart';
import 'package:solveit/core/injections/auth.dart';
import 'package:solveit/core/network/utils/utils.dart';
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

abstract class AuthService {
  Future<Either<Failure, LoginResponse>> login(LoginRequest req, bool isEmail);
  Future<Either<Failure, AuthResponse>> signUpUser(SignupRequest req);
  Future<Either<Failure, AuthResponse>> signUpStudent(CreateStudentRequest req);
  Future<Either<Failure, GenericAuthResponse>> verifyEmail(VerifyEmailRequest req);
  Future<Either<Failure, GenericAuthResponse>> resendCode(ResendCodeRequest req);
  Future<Either<Failure, GenericAuthResponse>> forgotPassword(ForgotPasswordRequest req);
  Future<Either<Failure, GenericAuthResponse>> resetPassword(ResetPasswordRequest req);
  Future<Either<Failure, StudentOrUserModel>> getUser(bool isStudent, String id);
  Future<Either<Failure, AllStudentsOrUserResponse>> getAllUsers(bool isStudent);
}

class AuthServiceImplimentation extends AuthService {
  @override
  Future<Either<Failure, GenericAuthResponse>> forgotPassword(req) {
    return authApi.forgotPassword(req);
  }

  @override
  Future<Either<Failure, LoginResponse>> login(req, isEmail) {
    return authApi.login(req, isEmail);
  }

  @override
  Future<Either<Failure, GenericAuthResponse>> resendCode(req) {
    return authApi.resendCode(req);
  }

  @override
  Future<Either<Failure, GenericAuthResponse>> resetPassword(req) {
    return authApi.resetPassword(req);
  }

  @override
  Future<Either<Failure, GenericAuthResponse>> verifyEmail(req) {
    return authApi.verifyEmail(req);
  }

  @override
  Future<Either<Failure, AllStudentsOrUserResponse>> getAllUsers(isStudent) {
    return authApi.getAllUsers(isStudent);
  }

  @override
  Future<Either<Failure, StudentOrUserModel>> getUser(isStudent, id) {
    return authApi.getUser(isStudent, id);
  }

  @override
  Future<Either<Failure, AuthResponse>> signUpStudent(req) {
    return authApi.signUpStudent(req);
  }

  @override
  Future<Either<Failure, AuthResponse>> signUpUser(req) {
    return authApi.signUpUser(req);
  }
}
