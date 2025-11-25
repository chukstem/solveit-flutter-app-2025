class AllLevelsResponse {
  final String message;
  final int status;
  final List<Level> data;

  AllLevelsResponse({
    required this.message,
    required this.status,
    required this.data,
  });

  factory AllLevelsResponse.fromMap(Map<String, dynamic> json) {
    return AllLevelsResponse(
      message: json['message'],
      status: json['status'],
      data: List<Level>.from(json['data'].map((x) => Level.fromMap(x))),
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

class Level {
  final int id;
  final String name;
  final int schoolId;
  final String code;
  final String? deletedAt;
  final DateTime createdAt;
  final String? updatedAt;

  Level({
    required this.id,
    required this.name,
    required this.schoolId,
    required this.code,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory Level.fromMap(Map<String, dynamic> json) {
    return Level(
      id: json['id'],
      name: json['name'],
      schoolId: json['school_id'],
      code: json['code'],
      deletedAt: json['deleted_at'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "school_id": schoolId,
      "code": code,
      "deleted_at": deletedAt,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt,
    };
  }
}
