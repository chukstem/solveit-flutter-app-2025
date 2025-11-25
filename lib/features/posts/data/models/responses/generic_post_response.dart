import 'dart:convert';

class GenericPostResponse {
  final int? success;
  final String message;
  GenericPostResponse({
    required this.success,
    required this.message,
  });

  factory GenericPostResponse.fromMap(Map<String, dynamic> map) {
    return GenericPostResponse(
      success: map['success'] ?? 0,
      message: map['message'] as String,
    );
  }

  factory GenericPostResponse.fromJson(String source) => GenericPostResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GenericPostResponse(success: $success, message: $message)';

  @override
  bool operator ==(covariant GenericPostResponse other) {
    if (identical(this, other)) return true;

    return other.success == success && other.message == message;
  }

  @override
  int get hashCode => success.hashCode ^ message.hashCode;
}
