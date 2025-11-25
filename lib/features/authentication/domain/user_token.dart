import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solveit/features/authentication/data/models/auth/responses/auth_response.dart';
import 'package:solveit/features/authentication/data/models/auth/responses/token.dart';

/// Interface for managing user tokens and related data
abstract class UserTokenRepository {
  UserToken getToken();
  Future<bool> saveToken(String token, UserData user);
  Future<bool> deleteToken();
  Future<bool> updateToken(UserToken token);
  Future<void> clearUser();
}

/// Implementation of [UserTokenRepository] using SharedPreferences
class UserTokenRepositoryImpl implements UserTokenRepository {
  UserTokenRepositoryImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;
  static const String _tokenKey = 'token';

  /// Fetches the saved user token from storage
  @override
  UserToken getToken() {
    try {
      final jsonString = sharedPreferences.getString(_tokenKey);
      if (jsonString == null) return const UserToken(token: null, user: null);

      return UserToken.fromJson(jsonDecode(jsonString));
    } catch (err, stack) {
      log("Error fetching token: $err\n$stack");
      return const UserToken(token: null, user: null);
    }
  }

  /// Saves a new token along with user information
  @override
  Future<bool> saveToken(String token, UserData user) async {
    final userToken = UserToken(token: token, user: user);
    return await sharedPreferences.setString(_tokenKey, jsonEncode(userToken.toJson()));
  }

  /// Updates the saved token
  @override
  Future<bool> updateToken(UserToken token) async {
    return await sharedPreferences.setString(_tokenKey, jsonEncode(token.toJson()));
  }

  /// Deletes the stored token
  @override
  Future<bool> deleteToken() async {
    return await sharedPreferences.remove(_tokenKey);
  }

  /// Clears all user-related data
  @override
  Future<void> clearUser() async {
    await sharedPreferences.clear();
    await sharedPreferences.reload();
  }
}
