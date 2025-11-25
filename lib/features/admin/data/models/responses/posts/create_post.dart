import 'dart:convert';

import 'package:solveit/features/posts/data/models/responses/get_posts.dart';

class PostResponse {
  final int statusCode;
  final String statusMessage;
  final SinglePostResponse? data;
  PostResponse({
    required this.statusCode,
    required this.statusMessage,
    this.data,
  });

  PostResponse copyWith({
    int? statusCode,
    String? statusMessage,
    SinglePostResponse? data,
  }) {
    return PostResponse(
      statusCode: statusCode ?? this.statusCode,
      statusMessage: statusMessage ?? this.statusMessage,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'data': data?.toMap(),
    };
  }

  factory PostResponse.fromMap(Map<String, dynamic> map) {
    return PostResponse(
      statusCode: map['statusCode'] ?? 0,
      statusMessage: map['statusMessage'] as String,
      data: map['data'] != null ? SinglePostResponse.fromMap(map['data'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostResponse.fromJson(String source) => PostResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PostResponse(statusCode: $statusCode, statusMessage: $statusMessage, data: $data)';

  @override
  bool operator ==(covariant PostResponse other) {
    if (identical(this, other)) return true;

    return other.statusCode == statusCode && other.statusMessage == statusMessage && other.data == data;
  }

  @override
  int get hashCode => statusCode.hashCode ^ statusMessage.hashCode ^ data.hashCode;
}
