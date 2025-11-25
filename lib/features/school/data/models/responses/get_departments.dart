class AllDepartmentsResponse {
  final String message;
  final int status;
  final List<Department> data;

  AllDepartmentsResponse({
    required this.message,
    required this.status,
    required this.data,
  });

  factory AllDepartmentsResponse.fromMap(Map<String, dynamic> map) {
    return AllDepartmentsResponse(
      message: map['message'],
      status: map['status'],
      data: List<Department>.from(map['data'].map((x) => Department.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "status": status,
      "data": data.map((x) => x.toMap()).toList(),
    };
  }
}

class Department {
  final int id;
  final String name;
  final int schoolId;
  final int facultyId;
  final String code;
  final String? deletedAt;
  final DateTime createdAt;
  final String? updatedAt;

  Department({
    required this.id,
    required this.name,
    required this.schoolId,
    required this.facultyId,
    required this.code,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      id: map['id'],
      name: map['name'],
      schoolId: map['school_id'],
      facultyId: map['faculty_id'],
      code: map['code'],
      deletedAt: map['deleted_at'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "school_id": schoolId,
      "faculty_id": facultyId,
      "code": code,
      "deleted_at": deletedAt,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt,
    };
  }
}
