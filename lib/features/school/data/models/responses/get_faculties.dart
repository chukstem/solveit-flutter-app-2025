class AllFacultiesResponse {
  final String message;
  final int status;
  final List<Faculty> data;

  AllFacultiesResponse({
    required this.message,
    required this.status,
    required this.data,
  });

  factory AllFacultiesResponse.fromMap(Map<String, dynamic> json) {
    return AllFacultiesResponse(
      message: json['message'],
      status: json['status'],
      data: List<Faculty>.from(json['data'].map((x) => Faculty.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() => {
        "message": message,
        "status": status,
        "data": data.map((x) => x.toMap()).toList(),
      };
}

class Faculty {
  final int id;
  final String name;
  final int schoolId;
  final String code;
  final String? deletedAt;
  final DateTime createdAt;
  final String? updatedAt;

  Faculty({
    required this.id,
    required this.name,
    required this.schoolId,
    required this.code,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory Faculty.fromMap(Map<String, dynamic> json) => Faculty(
        id: json['id'],
        name: json['name'],
        schoolId: json['school_id'],
        code: json['code'],
        deletedAt: json['deleted_at'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "school_id": schoolId,
        "code": code,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
      };
}
