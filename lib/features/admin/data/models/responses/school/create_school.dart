import 'dart:convert';

class GenericSchoolElementResponse {
  final int statusCode;
  final String statusMessage;
  GenericSchoolElementResponse({
    required this.statusCode,
    required this.statusMessage,
  });

  GenericSchoolElementResponse copyWith({
    int? statusCode,
    String? statusMessage,
  }) {
    return GenericSchoolElementResponse(
      statusCode: statusCode ?? this.statusCode,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'statusCode': statusCode,
      'statusMessage': statusMessage,
    };
  }

  factory GenericSchoolElementResponse.fromMap(Map<String, dynamic> map) {
    return GenericSchoolElementResponse(
      statusCode: map['statusCode'] as int,
      statusMessage: map['statusMessage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GenericSchoolElementResponse.fromJson(String source) => GenericSchoolElementResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GenericSchoolElementResponse(statusCode: $statusCode, statusMessage: $statusMessage)';

  @override
  bool operator ==(covariant GenericSchoolElementResponse other) {
    if (identical(this, other)) return true;

    return other.statusCode == statusCode && other.statusMessage == statusMessage;
  }

  @override
  int get hashCode => statusCode.hashCode ^ statusMessage.hashCode;
}
