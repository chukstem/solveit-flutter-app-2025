import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class CreatePermissionResponse {
  final int status;
  final String message;
  CreatePermissionResponse({
    required this.status,
    required this.message,
  });

  CreatePermissionResponse copyWith({
    int? status,
    String? message,
  }) {
    return CreatePermissionResponse(
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

  factory CreatePermissionResponse.fromMap(Map<String, dynamic> map) {
    return CreatePermissionResponse(
      status: map['status'] as int,
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreatePermissionResponse.fromJson(String source) =>
      CreatePermissionResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CreatePermissionResponse(status: $status, message: $message)';

  @override
  bool operator ==(covariant CreatePermissionResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message;
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode;
}

class GetPermissionResponse {
  final int status;
  final String message;
  final List<Permissions> permission;
  GetPermissionResponse({
    required this.status,
    required this.message,
    required this.permission,
  });

  GetPermissionResponse copyWith({
    int? status,
    String? message,
    List<Permissions>? permission,
  }) {
    return GetPermissionResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      permission: permission ?? this.permission,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': permission.map((x) => x.toMap()).toList(),
    };
  }

  factory GetPermissionResponse.fromMap(Map<String, dynamic> map) {
    return GetPermissionResponse(
      status: map['status'] as int,
      message: map['message'] as String,
      permission: List<Permissions>.from(
        (map['data'][0] as List<int>).map<Permissions>(
          (x) => Permissions.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  factory GetPermissionResponse.fromMap2(Map<String, dynamic> map) {
    return GetPermissionResponse(
      status: map['status'] as int,
      message: map['message'] as String,
      permission: List<Permissions>.from(
        (map['data'] as List<int>).map<Permissions>(
          (x) => Permissions.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetPermissionResponse.fromJson(String source) =>
      GetPermissionResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'GetPermissionResponse(status: $status, message: $message, permission: $permission)';

  @override
  bool operator ==(covariant GetPermissionResponse other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.message == message &&
        listEquals(other.permission, permission);
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ permission.hashCode;
}

class Permissions {
  final int id;
  final String name;
  final String slug;
  final String createdAt;
  final String updatedAt;
  Permissions({
    required this.id,
    required this.name,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
  });

  Permissions copyWith({
    int? id,
    String? name,
    String? slug,
    String? createdAt,
    String? updatedAt,
  }) {
    return Permissions(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'slug': slug,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Permissions.fromMap(Map<String, dynamic> map) {
    return Permissions(
      id: map['id'] as int,
      name: map['name'] as String,
      slug: map['slug'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Permissions.fromJson(String source) =>
      Permissions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Permissions(id: $id, name: $name, slug: $slug, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Permissions other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.slug == slug &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        slug.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
