// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solveit/features/authentication/data/models/auth/responses/auth_response.dart';
import 'package:solveit/features/authentication/data/models/auth/responses/token.dart';
import 'package:solveit/features/authentication/domain/user_token.dart';
import 'package:solveit/utils/navigation/routes.dart';

enum AuthenticationStatus { initial, authenticated, unauthenticated }

/// **User Authentication State Model**
class UserState {
  final AuthenticationStatus status;
  final UserData? currentUser;
  final UserToken token;
  final bool firstTimeUser;
  final bool isInitialized;

  const UserState({
    this.status = AuthenticationStatus.initial,
    this.currentUser,
    this.token = UserToken.empty,
    this.firstTimeUser = true,
    this.isInitialized = false,
  });

  // Authentication status getters
  bool get authenticated => status == AuthenticationStatus.authenticated;

  UserState copyWith({
    AuthenticationStatus? status,
    UserData? currentUser,
    UserToken? token,
    bool? firstTimeUser,
    bool? isInitialized,
  }) {
    return UserState(
      status: status ?? this.status,
      currentUser: currentUser ?? this.currentUser,
      token: token ?? this.token,
      firstTimeUser: firstTimeUser ?? this.firstTimeUser,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

/// **UserStateManager for Authentication State Management**
class UserStateManager extends ChangeNotifier {
  final UserTokenRepository userTokenRepository;

  UserState _state = const UserState();
  UserState get state => _state;

  UserStateManager({required this.userTokenRepository});

  /// ✅ **Updates state and notifies listeners**
  void _setState({
    AuthenticationStatus? status,
    UserData? currentUser,
    UserToken? token,
    bool? firstTimeUser,
    bool? isInitialized,
  }) {
    _state = _state.copyWith(
      status: status,
      currentUser: currentUser,
      token: token,
      firstTimeUser: firstTimeUser,
      isInitialized: isInitialized,
    );
    notifyListeners();
  }

  /// ✅ **Initialize the user session state**
  Future<void> init() async {
    if (_state.isInitialized) return;

    try {
      final token = userTokenRepository.getToken();
      final userData = token.user;
      final isFirstTime = userData == null;
      final authStatus = (token.token != null && userData != null)
          ? AuthenticationStatus.authenticated
          : AuthenticationStatus.unauthenticated;

      _setState(
        token: token,
        currentUser: userData,
        firstTimeUser: isFirstTime,
        status: authStatus,
        isInitialized: true,
      );
    } catch (e) {
      _handleError('Init error: $e');
    }
  }

  void _updateAuthStatus(AuthenticationStatus newStatus) {
    if (_state.status != newStatus) {
      _setState(status: newStatus);
    }
  }

  void _handleError(String message) {
    if (kDebugMode) {
      log(message);
    }
    _updateAuthStatus(AuthenticationStatus.unauthenticated);
  }

  /// ✅ **Handle user login and token storage**
  Future<void> login(UserToken userToken) async {
    try {
      if (userToken.token == null || userToken.user == null) {
        throw ArgumentError('Invalid token or user data');
      }

      log('User data when saving: $userToken');

      await userTokenRepository.saveToken(userToken.token!, userToken.user!);

      _setState(
        token: userToken,
        currentUser: userToken.user,
        firstTimeUser: false,
        status: AuthenticationStatus.authenticated,
      );
    } catch (e) {
      _handleError('Login error: $e');
    }
  }

  /// ✅ **Handle user logout and token removal**
  Future<void> logout(BuildContext context) async {
    try {
      const emptyToken = UserToken(token: null, user: null);
      await userTokenRepository.updateToken(emptyToken);

      _setState(
        token: emptyToken,
        currentUser: null,
        firstTimeUser: true,
        status: AuthenticationStatus.unauthenticated,
      );

      if (context.mounted) {
        context.go(SolveitRoutes.onboardingHomeScreen.route);
      }
    } catch (e) {
      _handleError('Logout error: $e');
    }
  }

  @override
  void dispose() {
    _setState(isInitialized: false);
    super.dispose();
  }
}
