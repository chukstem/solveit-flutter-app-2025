import 'package:flutter/foundation.dart';

class MarketplaceCommentReactionResponse {
  final int status;
  final String message;
  final List<MarketCommentReaction> data;

  MarketplaceCommentReactionResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MarketplaceCommentReactionResponse.fromMap(Map<String, dynamic> json) {
    return MarketplaceCommentReactionResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List<dynamic>).map((item) => MarketCommentReaction.fromMap(item)).toList(),
    );
  }

  @override
  String toString() => 'MarketplaceCommentReactionResponse(status: $status, message: $message, data: $data)';

  @override
  bool operator ==(covariant MarketplaceCommentReactionResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message && listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;
}

class MarketCommentReaction {
  final int id;
  final int schoolId;
  final int marketProductId;
  final int marketProductCommentId;
  final int? marketProductCommentReplyId;
  final int? studentId;
  final int? staffId;
  final int? lecturerId;
  final int userId;
  final String type;
  final String code;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  MarketCommentReaction({
    required this.id,
    required this.schoolId,
    required this.marketProductId,
    required this.marketProductCommentId,
    this.marketProductCommentReplyId,
    this.studentId,
    this.staffId,
    this.lecturerId,
    required this.userId,
    required this.type,
    required this.code,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MarketCommentReaction.fromMap(Map<String, dynamic> json) {
    return MarketCommentReaction(
      id: json['id'],
      schoolId: json['school_id'],
      marketProductId: json['market_product_id'],
      marketProductCommentId: json['market_product_comment_id'],
      marketProductCommentReplyId: json['market_product_comment_reply_id'],
      studentId: json['student_id'],
      staffId: json['staff_id'],
      lecturerId: json['lecturer_id'],
      userId: json['user_id'],
      type: json['type'],
      code: json['code'],
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  @override
  String toString() {
    return 'MarketCommentReaction(id: $id, schoolId: $schoolId, marketProductId: $marketProductId, marketProductCommentId: $marketProductCommentId, marketProductCommentReplyId: $marketProductCommentReplyId, studentId: $studentId, staffId: $staffId, lecturerId: $lecturerId, userId: $userId, type: $type, code: $code, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant MarketCommentReaction other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.schoolId == schoolId &&
        other.marketProductId == marketProductId &&
        other.marketProductCommentId == marketProductCommentId &&
        other.marketProductCommentReplyId == marketProductCommentReplyId &&
        other.studentId == studentId &&
        other.staffId == staffId &&
        other.lecturerId == lecturerId &&
        other.userId == userId &&
        other.type == type &&
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
        marketProductCommentReplyId.hashCode ^
        studentId.hashCode ^
        staffId.hashCode ^
        lecturerId.hashCode ^
        userId.hashCode ^
        type.hashCode ^
        code.hashCode ^
        deletedAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
