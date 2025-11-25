import 'dart:convert';

class CategoryRequest {
  final String name;
  final String schoolId;
  CategoryRequest({
    required this.name,
    required this.schoolId,
  });

  CategoryRequest copyWith({
    String? name,
    String? schoolId,
  }) {
    return CategoryRequest(
      name: name ?? this.name,
      schoolId: schoolId ?? this.schoolId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'school_id': schoolId,
    };
  }

  factory CategoryRequest.fromMap(Map<String, dynamic> map) {
    return CategoryRequest(
      name: map['name'] as String,
      schoolId: map['school_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryRequest.fromJson(String source) => CategoryRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CategoryRequest(name: $name, schoolId: $schoolId)';

  @override
  bool operator ==(covariant CategoryRequest other) {
    if (identical(this, other)) return true;

    return other.name == name && other.schoolId == schoolId;
  }

  @override
  int get hashCode => name.hashCode ^ schoolId.hashCode;
}
