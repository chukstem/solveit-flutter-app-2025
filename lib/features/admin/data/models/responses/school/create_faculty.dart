// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FacultyResponse {
  final int status;
  final String message;
  final SingleFacultyResponse? data;
  FacultyResponse({
    required this.status,
    required this.message,
    this.data,
  });

  FacultyResponse copyWith({
    int? status,
    String? message,
    SingleFacultyResponse? data,
  }) {
    return FacultyResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': data?.toMap(),
    };
  }

  factory FacultyResponse.fromMap(Map<String, dynamic> map) {
    return FacultyResponse(
      status: map['status'] as int,
      message: map['message'] as String,
      data: map['data'] != null ? SingleFacultyResponse.fromMap(map['data'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FacultyResponse.fromJson(String source) => FacultyResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'FacultyResponse(status: $status, message: $message, data: $data)';

  @override
  bool operator ==(covariant FacultyResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message && other.data == data;
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;
}

class SingleFacultyResponse {
  final String facultyName;
  final String school;
  final String id;
  final String createdAt;
  final String updatedAt;
  SingleFacultyResponse({
    required this.facultyName,
    required this.school,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  SingleFacultyResponse copyWith({
    String? facultyName,
    String? school,
    String? id,
    String? createdAt,
    String? updatedAt,
  }) {
    return SingleFacultyResponse(
      facultyName: facultyName ?? this.facultyName,
      school: school ?? this.school,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'facultyName': facultyName,
      'school': school,
      '_id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory SingleFacultyResponse.fromMap(Map<String, dynamic> map) {
    return SingleFacultyResponse(
      facultyName: map['facultyName'] as String,
      school: map['school'] as String,
      id: map['_id'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleFacultyResponse.fromJson(String source) => SingleFacultyResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SingleFacultyResponse(facultyName: $facultyName, school: $school, id: $id, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant SingleFacultyResponse other) {
    if (identical(this, other)) return true;

    return other.facultyName == facultyName && other.school == school && other.id == id && other.createdAt == createdAt && other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return facultyName.hashCode ^ school.hashCode ^ id.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
