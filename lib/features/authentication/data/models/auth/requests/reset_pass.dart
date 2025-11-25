// ignore_for_file: public_member_api_docs, sort_constructors_first
class ResetPasswordRequest {
  final String email;
  final String verificationCode;
  final String password;

  ResetPasswordRequest({
    required this.email,
    required this.verificationCode,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
        "email": email.trim().toLowerCase(),
        "verification_code": verificationCode,
        "password": password,
        "password_confirmation": password, // Backend requires password confirmation
      };

  ResetPasswordRequest copyWith({
    String? email,
    String? verificationCode,
    String? password,
  }) {
    return ResetPasswordRequest(
      email: email ?? this.email,
      verificationCode: verificationCode ?? this.verificationCode,
      password: password ?? this.password,
    );
  }
}
