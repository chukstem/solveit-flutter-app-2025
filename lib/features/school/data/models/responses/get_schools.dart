class AllSchoolsResponse {
  final String message;
  final int status;
  final List<School> data;

  AllSchoolsResponse({
    required this.message,
    required this.status,
    required this.data,
  });

  factory AllSchoolsResponse.fromMap(Map<String, dynamic> map) {
    return AllSchoolsResponse(
      message: map['message'],
      status: map['status'],
      data: List<School>.from(map['data'].map((x) => School.fromMap(x))),
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

class School {
  final int id;
  final String name;
  final String logo;
  final String code;
  final String? deletedAt;
  final DateTime createdAt;
  final String? updatedAt;

  School({
    required this.id,
    required this.name,
    required this.logo,
    required this.code,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory School.fromMap(Map<String, dynamic> map) {
    return School(
      id: map['id'],
      name: map['name'],
      logo: map['logo'],
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
      "logo": logo,
      "code": code,
      "deleted_at": deletedAt,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt,
    };
  }
}
