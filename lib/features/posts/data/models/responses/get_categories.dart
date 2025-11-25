import 'dart:convert';

import 'package:flutter/foundation.dart';

class AllCategoriesResponse {
  final int status;
  final String message;
  final List<SingleCategoryResponse>? data;

  AllCategoriesResponse({
    required this.status,
    required this.message,
    this.data,
  });

  AllCategoriesResponse copyWith({
    int? status,
    String? message,
    List<SingleCategoryResponse>? data,
  }) {
    return AllCategoriesResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': data?.map((x) => x.toMap()).toList(),
    };
  }

  factory AllCategoriesResponse.fromMap(Map<String, dynamic> map) {
    return AllCategoriesResponse(
      status: map['status'] as int,
      message: map['message'] as String,
      data: map['data'] != null
          ? List<SingleCategoryResponse>.from(
              (map['data'] as List<dynamic>).map<SingleCategoryResponse>(
                (x) => SingleCategoryResponse.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AllCategoriesResponse.fromJson(String source) => AllCategoriesResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AllCategoriesResponse(status: $status, message: $message, data: $data)';

  @override
  bool operator ==(covariant AllCategoriesResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message && listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;
}

class SingleCategoryResponse {
  final int id;
  final int schoolId;
  final String name;
  final String code;
  final String? deletedAt;
  final String createdAt;
  final String? updatedAt;

  SingleCategoryResponse({
    required this.id,
    required this.schoolId,
    required this.name,
    required this.code,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
  });

  SingleCategoryResponse copyWith({
    int? id,
    int? schoolId,
    String? name,
    String? code,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return SingleCategoryResponse(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      name: name ?? this.name,
      code: code ?? this.code,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'school_id': schoolId,
      'name': name,
      'code': code,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory SingleCategoryResponse.fromMap(Map<String, dynamic> map) {
    return SingleCategoryResponse(
      id: map['id'] as int,
      schoolId: map['school_id'] as int,
      name: map['name'] as String,
      code: map['code'] as String,
      deletedAt: map['deleted_at'] as String?,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleCategoryResponse.fromJson(String source) => SingleCategoryResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SingleCategoryResponse(id: $id, schoolId: $schoolId, name: $name, code: $code, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant SingleCategoryResponse other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.schoolId == schoolId &&
        other.name == name &&
        other.code == code &&
        other.deletedAt == deletedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ schoolId.hashCode ^ name.hashCode ^ code.hashCode ^ deletedAt.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
