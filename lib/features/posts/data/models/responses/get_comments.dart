import 'dart:convert';

import 'package:flutter/foundation.dart';

class AllCommentsResponse {
  final int status;
  final List<Comment> comments;
  AllCommentsResponse({
    required this.status,
    required this.comments,
  });

  AllCommentsResponse copyWith({
    int? status,
    List<Comment>? comments,
  }) {
    return AllCommentsResponse(
      status: status ?? this.status,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'comments': comments.map((x) => x.toMap()).toList(),
    };
  }

  factory AllCommentsResponse.fromMap(Map<String, dynamic> map) {
    return AllCommentsResponse(
      status: map['status'] ?? false,
      comments: map['data'] != null
          ? List<Comment>.from(
              (map['data'] as List<dynamic>).map<Comment>(
                (x) => Comment.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory AllCommentsResponse.fromJson(String source) => AllCommentsResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AllCommentsResponse(success: $status, comments: $comments)';

  @override
  bool operator ==(covariant AllCommentsResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && listEquals(other.comments, comments);
  }

  @override
  int get hashCode => status.hashCode ^ comments.hashCode;
}

class User {
  final String id;
  final String name;
  User({
    required this.id,
    required this.name,
  });

  User copyWith({
    String? id,
    String? name,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'User(id: $id, name: $name)';

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

class Comment {
  final int id;
  final int? schoolId;
  final int newsId;
  final int? studentId;
  final int? staffId;
  final int? lecturerId;
  final int userId;
  final String body;
  final dynamic images;
  final String code;
  final String? deletedAt;
  final String createdAt;
  final String? updatedAt;
  Comment({
    required this.id,
    required this.schoolId,
    required this.newsId,
    this.studentId,
    this.staffId,
    this.lecturerId,
    required this.userId,
    required this.body,
    this.images,
    required this.code,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
  });

  Comment copyWith({
    int? id,
    int? schoolId,
    int? newsId,
    int? studentId,
    int? staffId,
    int? lecturerId,
    int? userId,
    String? body,
    dynamic images,
    String? code,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return Comment(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      newsId: newsId ?? this.newsId,
      studentId: studentId ?? this.studentId,
      staffId: staffId ?? this.staffId,
      lecturerId: lecturerId ?? this.lecturerId,
      userId: userId ?? this.userId,
      body: body ?? this.body,
      images: images ?? this.images,
      code: code ?? this.code,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'school_id': schoolId,
      'news_id': newsId,
      'student_id': studentId,
      'staff_id': staffId,
      'lecturer_id': lecturerId,
      'user_id': userId,
      'body': body,
      'images': images,
      'code': code,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as int,
      schoolId: map['school_id'] as int?,
      newsId: map['news_id'] as int,
      studentId: map['student_id'] as int?,
      staffId: map['staff_id'] as int?,
      lecturerId: map['lecturer_id'] as int?,
      userId: map['user_id'] ?? '',
      body: map['body'] ?? '',
      images: map['images'],
      code: map['code'] ?? '',
      deletedAt: map['deleted_at'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) => Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Comment(id: $id, schoolId: $schoolId, newsId: $newsId, studentId: $studentId, staffId: $staffId, lecturerId: $lecturerId, userId: $userId, body: $body, images: $images, code: $code, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.schoolId == schoolId &&
        other.newsId == newsId &&
        other.studentId == studentId &&
        other.staffId == staffId &&
        other.lecturerId == lecturerId &&
        other.userId == userId &&
        other.body == body &&
        other.images == images &&
        other.code == code &&
        other.deletedAt == deletedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        schoolId.hashCode ^
        newsId.hashCode ^
        studentId.hashCode ^
        staffId.hashCode ^
        lecturerId.hashCode ^
        userId.hashCode ^
        body.hashCode ^
        images.hashCode ^
        code.hashCode ^
        deletedAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
