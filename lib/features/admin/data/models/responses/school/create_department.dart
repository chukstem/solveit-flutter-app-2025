// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DepartmentResponse {
  final int status;
  final String message;
  final SingleDepartmentResponse? data;
  DepartmentResponse({
    required this.status,
    required this.message,
    this.data,
  });

  DepartmentResponse copyWith({
    int? status,
    String? message,
    SingleDepartmentResponse? data,
  }) {
    return DepartmentResponse(
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

  factory DepartmentResponse.fromMap(Map<String, dynamic> map) {
    return DepartmentResponse(
      status: map['status'] as int,
      message: map['message'] as String,
      data: map['data'] != null ? SingleDepartmentResponse.fromMap(map['data'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DepartmentResponse.fromJson(String source) => DepartmentResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DepartmentResponse(status: $status, message: $message, data: $data)';

  @override
  bool operator ==(covariant DepartmentResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message && other.data == data;
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;
}

class SingleDepartmentResponse {
  final String departmentName;
  final String faculty;
  final String id;
  final String createdAt;
  final String updatedAt;
  SingleDepartmentResponse({
    required this.departmentName,
    required this.faculty,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  SingleDepartmentResponse copyWith({
    String? departmentName,
    String? faculty,
    String? id,
    String? createdAt,
    String? updatedAt,
  }) {
    return SingleDepartmentResponse(
      departmentName: departmentName ?? this.departmentName,
      faculty: faculty ?? this.faculty,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'departmentName': departmentName,
      'faculty': faculty,
      '_id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory SingleDepartmentResponse.fromMap(Map<String, dynamic> map) {
    return SingleDepartmentResponse(
      departmentName: map['departmentName'] as String,
      faculty: map['faculty'] as String,
      id: map['_id'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleDepartmentResponse.fromJson(String source) => SingleDepartmentResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SingleDepartmentResponse(departmentName: $departmentName, faculty: $faculty, id: $id, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant SingleDepartmentResponse other) {
    if (identical(this, other)) return true;

    return other.departmentName == departmentName && other.faculty == faculty && other.id == id && other.createdAt == createdAt && other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return departmentName.hashCode ^ faculty.hashCode ^ id.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
