import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MarketplaceCommentReplyResponse {
  final int status;
  final String message;
  final List<MarketCommentReply> data;

  MarketplaceCommentReplyResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MarketplaceCommentReplyResponse.fromMap(Map<String, dynamic> json) {
    return MarketplaceCommentReplyResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List<dynamic>).map((item) => MarketCommentReply.fromMap(item)).toList(),
    );
  }

  @override
  String toString() => 'MarketplaceCommentReplyResponse(status: $status, message: $message, data: $data)';

  @override
  bool operator ==(covariant MarketplaceCommentReplyResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message && listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;
}

class MarketCommentReply {
  final int id;
  final int schoolId;
  final int marketProductId;
  final int marketProductCommentId;
  final int? studentId;
  final int? staffId;
  final int? lecturerId;
  final int userId;
  final String body;
  final String? images;
  final String code;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MarketCommentReply({
    required this.id,
    required this.schoolId,
    required this.marketProductId,
    required this.marketProductCommentId,
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

  factory MarketCommentReply.fromMap(Map<String, dynamic> json) {
    return MarketCommentReply(
      id: json['id'],
      schoolId: json['school_id'],
      marketProductId: json['market_product_id'],
      marketProductCommentId: json['market_product_comment_id'],
      studentId: json['student_id'],
      staffId: json['staff_id'],
      lecturerId: json['lecturer_id'],
      userId: json['user_id'],
      body: json['body'],
      images: json['images'],
      code: json['code'],
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  @override
  String toString() {
    return 'MarketCommentReply(id: $id, schoolId: $schoolId, marketProductId: $marketProductId, marketProductCommentId: $marketProductCommentId, studentId: $studentId, staffId: $staffId, lecturerId: $lecturerId, userId: $userId, body: $body, images: $images, code: $code, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant MarketCommentReply other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.schoolId == schoolId &&
        other.marketProductId == marketProductId &&
        other.marketProductCommentId == marketProductCommentId &&
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
        marketProductCommentId.hashCode ^
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
