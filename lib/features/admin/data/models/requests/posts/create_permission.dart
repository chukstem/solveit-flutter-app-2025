import 'dart:convert';

class RoleRequest {
  final String name;
  RoleRequest({
    required this.name,
  });

  RoleRequest copyWith({
    String? name,
  }) {
    return RoleRequest(
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }

  factory RoleRequest.fromMap(Map<String, dynamic> map) {
    return RoleRequest(
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RoleRequest.fromJson(String source) =>
      RoleRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RoleRequest(name: $name)';

  @override
  bool operator ==(covariant RoleRequest other) {
    if (identical(this, other)) return true;

    return other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

class PermissionRequest {
  final String name;
  final String slug;
  PermissionRequest({
    required this.name,
    required this.slug,
  });

  PermissionRequest copyWith({
    String? name,
    String? slug,
  }) {
    return PermissionRequest(
      name: name ?? this.name,
      slug: slug ?? this.slug,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'slug': slug,
    };
  }

  factory PermissionRequest.fromMap(Map<String, dynamic> map) {
    return PermissionRequest(
      name: map['name'] as String,
      slug: map['slug'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PermissionRequest.fromJson(String source) =>
      PermissionRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PermissionRequest(name: $name, slug: $slug)';

  @override
  bool operator ==(covariant PermissionRequest other) {
    if (identical(this, other)) return true;

    return other.name == name && other.slug == slug;
  }

  @override
  int get hashCode => name.hashCode ^ slug.hashCode;
}
