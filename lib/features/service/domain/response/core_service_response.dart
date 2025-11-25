import 'dart:convert';

import 'package:flutter/foundation.dart';

class CoreServiceCategoryResponse {
  final int status;
  final String message;
  final List<CoreServiceCategory> data;
  CoreServiceCategoryResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CoreServiceCategoryResponse.fromMap(Map<String, dynamic> map) {
    return CoreServiceCategoryResponse(
      status: map['status'],
      message: map['message'],
      data: List<CoreServiceCategory>.from(
        map['data'].map((x) => CoreServiceCategory.fromMap(x)),
      ),
    );
  }

  CoreServiceCategoryResponse copyWith({
    int? status,
    String? message,
    List<CoreServiceCategory>? data,
  }) {
    return CoreServiceCategoryResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory CoreServiceCategoryResponse.fromJson(String source) => CoreServiceCategoryResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CoreServiceCategoryResponse(status: $status, message: $message, data: $data)';

  @override
  bool operator ==(covariant CoreServiceCategoryResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message && listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;
}

class CoreServiceCategory {
  final int id;
  final String name;
  final String code;
  final String? deletedAt;
  final String createdAt;
  final String? updatedAt;
  CoreServiceCategory({
    required this.id,
    required this.name,
    required this.code,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory CoreServiceCategory.fromMap(Map<String, dynamic> map) {
    return CoreServiceCategory(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      deletedAt: map['deleted_at'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  CoreServiceCategory copyWith({
    int? id,
    String? name,
    String? code,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return CoreServiceCategory(
      id: id ?? this.id,
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
      'name': name,
      'code': code,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  String toJson() => json.encode(toMap());

  factory CoreServiceCategory.fromJson(String source) => CoreServiceCategory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CoreServiceCategory(id: $id, name: $name, code: $code, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant CoreServiceCategory other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.code == code &&
        other.deletedAt == deletedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ code.hashCode ^ deletedAt.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
