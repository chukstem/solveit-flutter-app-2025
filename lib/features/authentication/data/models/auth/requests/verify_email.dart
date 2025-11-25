class VerifyEmailRequest {
  final String email;
  final String verificationCode;

  VerifyEmailRequest({required this.email, required this.verificationCode});

  Map<String, dynamic> toMap() => {
        "email": email.trim().toLowerCase(),
        "verification_code": verificationCode,
      };
}
