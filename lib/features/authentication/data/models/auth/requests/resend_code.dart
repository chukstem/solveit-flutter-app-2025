class ResendCodeRequest {
  final String email;

  ResendCodeRequest({required this.email});

  Map<String, dynamic> toMap() => {
        "email": email.trim().toLowerCase(),
      };
}
