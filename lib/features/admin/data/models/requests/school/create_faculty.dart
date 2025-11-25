import 'dart:convert';

class CreateFacultyRequest {
  final String name;
  final String schoolId;
  CreateFacultyRequest({
    required this.name,
    required this.schoolId,
  });

  CreateFacultyRequest copyWith({
    String? name,
    String? schoolId,
  }) {
    return CreateFacultyRequest(
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

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'CreateFacultyRequest(name: $name, schoolId: $schoolId)';

  @override
  bool operator ==(covariant CreateFacultyRequest other) {
    if (identical(this, other)) return true;

    return other.name == name && other.schoolId == schoolId;
  }

  @override
  int get hashCode => name.hashCode ^ schoolId.hashCode;
}
