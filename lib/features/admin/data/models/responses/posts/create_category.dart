// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:solveit/features/posts/data/models/responses/get_categories.dart';

class CategoryResponse {
  final int statusCode;
  final String statusMessage;
  final SingleCategoryResponse? data;
  CategoryResponse({
    required this.statusCode,
    required this.statusMessage,
    this.data,
  });

  CategoryResponse copyWith({
    int? statusCode,
    String? statusMessage,
    SingleCategoryResponse? data,
  }) {
    return CategoryResponse(
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

  factory CategoryResponse.fromMap(Map<String, dynamic> map) {
    return CategoryResponse(
      statusCode: map['statusCode'],
      statusMessage: map['statusMessage'] as String,
      data: map['data'] != null ? SingleCategoryResponse.fromMap(map['data'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryResponse.fromJson(String source) => CategoryResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CategoryResponse(statusCode: $statusCode, statusMessage: $statusMessage, data: $data)';

  @override
  bool operator ==(covariant CategoryResponse other) {
    if (identical(this, other)) return true;

    return other.statusCode == statusCode && other.statusMessage == statusMessage && other.data == data;
  }

  @override
  int get hashCode => statusCode.hashCode ^ statusMessage.hashCode ^ data.hashCode;
}
