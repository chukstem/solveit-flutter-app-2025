import 'package:solveit/utils/utils/string_utils.dart';

class LoginRequest {
  final String? email;
  final String? phoneNo;
  final String password;

  LoginRequest({this.email, this.phoneNo, required this.password});

  Map<String, dynamic> toMap() {
    return {
      if (email != null && email!.isNotEmpty) "email": email?.trim().toLowerCase(),
      if (phoneNo != null && phoneNo!.isNotEmpty) "phone": StringUtils.formatPhoneNumberForApi(phoneNo!),
      "password": password,
    };
  }

  LoginRequest copyWith({
    String? email,
    String? phoneNo,
    String? password,
  }) {
    return LoginRequest(
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
      password: password ?? this.password,
    );
  }

  @override
  String toString() => 'LoginRequest(email: $email, phoneNo: $phoneNo, password: $password)';
}
