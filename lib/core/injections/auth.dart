import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/authentication/data/auth_api.dart';
import 'package:solveit/features/authentication/domain/auth_service.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/auth_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/login_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/otp_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/registeration_viewmodel.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/reset_password.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/state_provider.dart';

AuthApi authApi = sl<AuthApi>();
AuthService authService = sl<AuthService>();
AuthViewModel authViewModel = sl<AuthViewModel>();
final userStateManager = sl<UserStateManager>();

class AuthInjectionContainer {
  static Future<void> initialize() async {
    sl.registerLazySingleton<AuthApi>(() => AuthApiImplementation(
          apiClient: sl(),
        ));
    sl.registerLazySingleton<AuthService>(() => AuthServiceImplimentation());

    sl.registerLazySingleton<AuthViewModel>(() => AuthViewModel());
    sl.registerLazySingleton<UserStateManager>(() => UserStateManager(userTokenRepository: sl()));

    sl.registerFactory<LoginViewModel>(() => LoginViewModel());
    sl.registerFactory<ResetPasswordViewModel>(() => ResetPasswordViewModel());
    sl.registerFactory<RegistrationViewModel>(() => RegistrationViewModel());
    sl.registerFactory<OtpVerificationViewModel>(() => OtpVerificationViewModel());
  }
}
