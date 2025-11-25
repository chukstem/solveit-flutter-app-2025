// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

class MarketplaceCommentResponse {
  final int status;
  final String message;
  final List<MarketComment> data;

  MarketplaceCommentResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MarketplaceCommentResponse.fromMap(Map<String, dynamic> json) {
    return MarketplaceCommentResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List<dynamic>).map((item) => MarketComment.fromMap(item)).toList(),
    );
  }

  @override
  bool operator ==(covariant MarketplaceCommentResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message && listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;

  @override
  String toString() => 'MarketplaceCommentResponse(status: $status, message: $message, data: $data)';
}

class MarketComment {
  final int id;
  final int schoolId;
  final int marketProductId;
  final int? studentId;
  final int? staffId;
  final int? lecturerId;
  final int userId;
  final String body;
  final String images;
  final String code;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;

  MarketComment({
    required this.id,
    required this.schoolId,
    required this.marketProductId,
    this.studentId,
    this.staffId,
    this.lecturerId,
    required this.userId,
    required this.body,
    required this.images,
    required this.code,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MarketComment.fromMap(Map<String, dynamic> json) {
    return MarketComment(
      id: json['id'],
      schoolId: json['school_id'],
      marketProductId: json['market_product_id'],
      studentId: json['student_id'],
      staffId: json['staff_id'],
      lecturerId: json['lecturer_id'],
      userId: json['user_id'],
      body: json['body'],
      images: json['images'],
      code: json['code'],
      deletedAt: json['deleted_at'] != null ? (json['deleted_at']) : null,
      createdAt: (json['created_at']),
      updatedAt: (json['updated_at']),
    );
  }

  @override
  bool operator ==(covariant MarketComment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.schoolId == schoolId &&
        other.marketProductId == marketProductId &&
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
        marketProductId.hashCode ^
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

  @override
  String toString() {
    return 'MarketComment(id: $id, schoolId: $schoolId, marketProductId: $marketProductId, studentId: $studentId, staffId: $staffId, lecturerId: $lecturerId, userId: $userId, body: $body, images: $images, code: $code, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
