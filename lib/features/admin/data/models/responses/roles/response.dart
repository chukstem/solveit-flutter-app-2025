import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class CreateRolesResponse {
  final String status;
  CreateRolesResponse({
    required this.status,
  });

  CreateRolesResponse copyWith({
    String? status,
  }) {
    return CreateRolesResponse(
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
    };
  }

  factory CreateRolesResponse.fromMap(Map<String, dynamic> map) {
    return CreateRolesResponse(
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateRolesResponse.fromJson(String source) => CreateRolesResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CreateRolesResponse(status: $status)';

  @override
  bool operator ==(covariant CreateRolesResponse other) {
    if (identical(this, other)) return true;

    return other.status == status;
  }

  @override
  int get hashCode => status.hashCode;
}

class GetRolesResponse {
  final int status;
  final String message;
  final List<RoleData> data;

  GetRolesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  GetRolesResponse copyWith({
    int? status,
    String? message,
    List<RoleData>? data,
  }) {
    return GetRolesResponse(
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

  factory GetRolesResponse.fromMap(Map<String, dynamic> map) {
    return GetRolesResponse(
      status: map['status'] as int,
      message: map['message'] as String,
      data: List<RoleData>.from(
        (map['data'] as List<dynamic>).map<RoleData>(
          (x) => RoleData.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetRolesResponse.fromJson(String source) => GetRolesResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GetRolesResponse(status: $status, message: $message, data: $data)';

  @override
  bool operator ==(covariant GetRolesResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message && other.data == data;
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;
}

class RoleData {
  final int id;
  final String name;
  final String slug;
  final String createdAt;
  final String? updatedAt;

  RoleData({
    required this.id,
    required this.name,
    required this.slug,
    required this.createdAt,
    this.updatedAt,
  });

  RoleData copyWith({
    int? id,
    String? name,
    String? slug,
    String? createdAt,
    String? updatedAt,
  }) {
    return RoleData(
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

  factory RoleData.fromMap(Map<String, dynamic> map) {
    return RoleData(
      id: map['id'] as int,
      name: map['name'] as String,
      slug: map['slug'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory RoleData.fromJson(String source) => RoleData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RoleData(id: $id, name: $name, slug: $slug, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant RoleData other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.slug == slug && other.createdAt == createdAt && other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ slug.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
