import 'package:go_router/go_router.dart';
import 'package:solveit/features/authentication/presentation/pages/registration/registration_screen_two.dart';
import 'package:solveit/features/authentication/presentation/pages/registration/verify_email.dart';
import 'package:solveit/utils/navigation/go_router.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/features/authentication/presentation/pages/login/login_screen_home.dart';
import 'package:solveit/features/authentication/presentation/pages/registration/institution/institution_registration_screen.dart';
import 'package:solveit/features/authentication/presentation/pages/registration/registration_screen.dart';
import 'package:solveit/features/authentication/presentation/pages/reset/reset_password_screen.dart';
import 'package:solveit/features/authentication/presentation/pages/reset/reset_password_screen_continue.dart';
import 'package:solveit/features/posts/presentation/screens/single_post_screen.dart';
import 'package:solveit/features/onboarding/presentation/pages/onboarding_home_screen.dart';

final authenticationRoutes = [
  GoRoute(
      path: SolveitRoutes.onboardingHomeScreen.route,
      pageBuilder: (context, state) =>
          getTransition(const Onboardinghomescreen(), state)),
  GoRoute(
      path: SolveitRoutes.registrationScreen.route,
      pageBuilder: (context, state) =>
          getTransition(const RegistrationScreen(), state)),
  GoRoute(
      path: SolveitRoutes.registrationScreenHome.route,
      pageBuilder: (context, state) =>
          getTransition(const RegistrationScreenHome(), state)),
  GoRoute(
      path: SolveitRoutes.instituteRegistrationRoute.routeWithArgs ??
          SolveitRoutes.instituteRegistrationRoute.route,
      pageBuilder: (context, state) => getTransition(
          InstitutionRegistrationScreen(
              type: state.pathParameters[idParam] ?? "other"),
          state)),
  GoRoute(
      path: SolveitRoutes.loginScreen.route,
      pageBuilder: (context, state) =>
          getTransition(const LoginscreenHome(), state)),
  GoRoute(
      path: SolveitRoutes.resetpasswordContinueRoute.route,
      pageBuilder: (context, state) =>
          getTransition(const ResetpasswordscreenContinue(), state)),
  GoRoute(
      path: SolveitRoutes.resetPassword.route,
      pageBuilder: (context, state) =>
          getTransition(const Resetpasswordscreen(), state)),
  GoRoute(
      path: SolveitRoutes.verifyEmailScreen.route,
      pageBuilder: (context, state) =>
          getTransition(const OtpVerificationScreen(), state)),
  GoRoute(
      path: SolveitRoutes.singlePostScreen.route,
      pageBuilder: (context, state) =>
          getTransition(const SinglePostScreen(), state))
];
