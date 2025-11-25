import 'dart:convert';

class GenericAuthResponse {
  final bool status;
  final String message;
  GenericAuthResponse({
    required this.status,
    required this.message,
  });

  factory GenericAuthResponse.fromMap(Map<String, dynamic> map) {
    return GenericAuthResponse(
      status: map['status'] as bool,
      message: map['message'] as String,
    );
  }

  factory GenericAuthResponse.fromJson(String source) =>
      GenericAuthResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'GenericAuthResponse(status: $status, message: $message)';

  @override
  bool operator ==(covariant GenericAuthResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message;
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode;
}
