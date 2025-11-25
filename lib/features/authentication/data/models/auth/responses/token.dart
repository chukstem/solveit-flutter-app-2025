// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:solveit/features/authentication/data/models/auth/responses/auth_response.dart';

class UserToken {
  final String? token;
  final UserData? user;

  const UserToken({
    required this.token,
    this.user,
  });

  /// Empty token instance used for initialization
  static const empty = UserToken(token: null, user: null);

  UserToken copyWith({
    String? token,
    UserData? user,
  }) {
    return UserToken(
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'userData': user?.toMap(),
    };
  }

  factory UserToken.fromMap(Map<String, dynamic> map) {
    return UserToken(
      token: map['token'],
      user: map['userData'] != null
          ? UserData.fromMap(map['userData'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserToken.fromJson(String source) =>
      UserToken.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserToken(token: $token, user: $user)';

  @override
  bool operator ==(covariant UserToken other) {
    if (identical(this, other)) return true;

    return other.token == token && other.user == user;
  }

  @override
  int get hashCode => token.hashCode ^ user.hashCode;
}

class CurrentUser {
  final String email;
  CurrentUser({
    required this.email,
  });

  CurrentUser copyWith({
    String? email,
  }) {
    return CurrentUser(
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
    };
  }

  factory CurrentUser.fromMap(Map<String, dynamic> map) {
    return CurrentUser(
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrentUser.fromJson(String source) =>
      CurrentUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'User(email: $email)';

  @override
  bool operator ==(covariant CurrentUser other) {
    if (identical(this, other)) return true;

    return other.email == email;
  }

  @override
  int get hashCode => email.hashCode;
}
