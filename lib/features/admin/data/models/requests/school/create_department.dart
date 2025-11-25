// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CreateDepartmentRequest {
  final String name;
  final String facultyId;
  final String schoolId;
  CreateDepartmentRequest({
    required this.name,
    required this.facultyId,
    required this.schoolId,
  });

  CreateDepartmentRequest copyWith({
    String? name,
    String? facultyId,
    String? schoolId,
  }) {
    return CreateDepartmentRequest(
      name: name ?? this.name,
      facultyId: facultyId ?? this.facultyId,
      schoolId: schoolId ?? this.schoolId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'faculty_id': facultyId,
      'school_id': schoolId,
    };
  }

  factory CreateDepartmentRequest.fromMap(Map<String, dynamic> map) {
    return CreateDepartmentRequest(
      name: map['name'] as String,
      facultyId: map['faculty_id'] as String,
      schoolId: map['school_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateDepartmentRequest.fromJson(String source) => CreateDepartmentRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CreateDepartmentRequest(name: $name, facultyId: $facultyId, schoolId: $schoolId)';

  @override
  bool operator ==(covariant CreateDepartmentRequest other) {
    if (identical(this, other)) return true;

    return other.name == name && other.facultyId == facultyId && other.schoolId == schoolId;
  }

  @override
  int get hashCode => name.hashCode ^ facultyId.hashCode ^ schoolId.hashCode;
}
