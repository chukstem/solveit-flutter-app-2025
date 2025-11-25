import 'dart:convert';

class UpdateOrDeletePostElementResponse {
  final int status;
  final String message;
  UpdateOrDeletePostElementResponse({
    required this.status,
    required this.message,
  });

  UpdateOrDeletePostElementResponse copyWith({
    int? status,
    String? message,
  }) {
    return UpdateOrDeletePostElementResponse(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
    };
  }

  factory UpdateOrDeletePostElementResponse.fromMap(Map<String, dynamic> map) {
    return UpdateOrDeletePostElementResponse(
      status: map['status'] as int,
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateOrDeletePostElementResponse.fromJson(String source) => UpdateOrDeletePostElementResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UpdateOrDeletePostElementResponse(status: $status, message: $message)';

  @override
  bool operator ==(covariant UpdateOrDeletePostElementResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message;
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode;
}
