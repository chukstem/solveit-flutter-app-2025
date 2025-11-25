class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toMap() => {
        "email": email.trim().toLowerCase(),
      };
}
