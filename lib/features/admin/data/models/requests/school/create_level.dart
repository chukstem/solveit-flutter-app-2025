import 'dart:convert';

class CreateLevel {
  final String name;
  final String schoolId;
  CreateLevel({
    required this.name,
    required this.schoolId,
  });

  CreateLevel copyWith({
    String? name,
    String? schoolId,
  }) {
    return CreateLevel(
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
  String toString() => 'CreateLevel(name: $name, schoolId: $schoolId)';

  @override
  bool operator ==(covariant CreateLevel other) {
    if (identical(this, other)) return true;

    return other.name == name && other.schoolId == schoolId;
  }

  @override
  int get hashCode => name.hashCode ^ schoolId.hashCode;
}
