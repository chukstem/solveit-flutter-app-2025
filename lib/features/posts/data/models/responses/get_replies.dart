import 'dart:convert';

import 'package:flutter/foundation.dart';

class AllRepliesResponse {
  final int status;
  final String message;
  final List<Reply> data;

  AllRepliesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  AllRepliesResponse copyWith({
    int? status,
    String? message,
    List<Reply>? data,
  }) {
    return AllRepliesResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory AllRepliesResponse.fromMap(Map<String, dynamic> map) {
    return AllRepliesResponse(
      status: map['status'] as int,
      message: map['message'] as String,
      data: List<Reply>.from(
        (map['data'] as List<dynamic>).map<Reply>(
          (x) => Reply.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory AllRepliesResponse.fromJson(String source) => AllRepliesResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AllRepliesResponse(status: $status, message: $message, data: $data)';

  @override
  bool operator ==(covariant AllRepliesResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message && listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;
}

class Reply {
  final int id;
  final int schoolId;
  final int newsId;
  final int newsCommentId;
  final int? studentId;
  final int? staffId;
  final int? lecturerId;
  final int userId;
  final String body;
  final String? images;
  final String code;
  final String? deletedAt;
  final String createdAt;
  final String? updatedAt;

  Reply({
    required this.id,
    required this.schoolId,
    required this.newsId,
    required this.newsCommentId,
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

  Reply copyWith({
    int? id,
    int? schoolId,
    int? newsId,
    int? newsCommentId,
    int? studentId,
    int? staffId,
    int? lecturerId,
    int? userId,
    String? body,
    String? images,
    String? code,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return Reply(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      newsId: newsId ?? this.newsId,
      newsCommentId: newsCommentId ?? this.newsCommentId,
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
      'news_comment_id': newsCommentId,
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

  factory Reply.fromMap(Map<String, dynamic> map) {
    return Reply(
      id: map['id'] as int,
      schoolId: map['school_id'] as int,
      newsId: map['news_id'] as int,
      newsCommentId: map['news_comment_id'] as int,
      studentId: map['student_id'] as int?,
      staffId: map['staff_id'] as int?,
      lecturerId: map['lecturer_id'] as int?,
      userId: map['user_id'] as int,
      body: map['body'] as String,
      images: map['images'] as String?,
      code: map['code'] as String,
      deletedAt: map['deleted_at'] as String?,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Reply.fromJson(String source) => Reply.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Reply(id: $id, schoolId: $schoolId, newsId: $newsId, newsCommentId: $newsCommentId, studentId: $studentId, staffId: $staffId, lecturerId: $lecturerId, userId: $userId, body: $body, images: $images, code: $code, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Reply other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.schoolId == schoolId &&
        other.newsId == newsId &&
        other.newsCommentId == newsCommentId &&
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
        newsCommentId.hashCode ^
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
