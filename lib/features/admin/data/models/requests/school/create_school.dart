import 'dart:convert';

// 1. Create School Request
class CreateSchoolRequest {
  final String name;
  CreateSchoolRequest({
    required this.name,
  });

  CreateSchoolRequest copyWith({
    String? name,
  }) {
    return CreateSchoolRequest(
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'CreateSchoolRequest(name: $name)';

  @override
  bool operator ==(covariant CreateSchoolRequest other) {
    if (identical(this, other)) return true;

    return other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
