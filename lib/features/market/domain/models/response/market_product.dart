import 'package:flutter/foundation.dart';

class MarketPlaceProductResponse {
  final int status;
  final String message;
  final List<MarketProduct> data;

  MarketPlaceProductResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MarketPlaceProductResponse.fromMap(Map<String, dynamic> json) {
    return MarketPlaceProductResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List<dynamic>).map((item) => MarketProduct.fromMap(item)).toList(),
    );
  }

  @override
  bool operator ==(covariant MarketPlaceProductResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message && listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;
}

class MarketProduct {
  final int id;
  final int schoolId;
  final int marketProductTagId;
  final int? studentId;
  final int? staffId;
  final int? lecturerId;
  final int userId;
  final String title;
  final String description;
  final String images;
  final String amount;
  final String cost;
  final String location;
  final String phone;
  final String whatsapp;
  final String comment;
  final int active;
  final String code;
  final String? deletedAt;
  final String createdAt;
  final String? updatedAt;

  MarketProduct({
    required this.id,
    required this.schoolId,
    required this.marketProductTagId,
    this.studentId,
    this.staffId,
    this.lecturerId,
    required this.userId,
    required this.title,
    required this.description,
    required this.images,
    required this.amount,
    required this.cost,
    required this.location,
    required this.phone,
    required this.whatsapp,
    required this.comment,
    required this.active,
    required this.code,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory MarketProduct.fromMap(Map<String, dynamic> json) {
    return MarketProduct(
      id: json['id'],
      schoolId: json['school_id'],
      marketProductTagId: json['market_product_tag_id'],
      studentId: json['student_id'],
      staffId: json['staff_id'],
      lecturerId: json['lecturer_id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      images: json['images'],
      amount: json['amount'],
      cost: json['cost'],
      location: json['location'],
      phone: json['phone'],
      whatsapp: json['whatsapp'],
      comment: json['comment'],
      active: json['active'],
      code: json['code'],
      deletedAt: json['deleted_at'] != null ? (json['deleted_at']) : null,
      createdAt: (json['created_at']),
      updatedAt: json['updated_at'] != null ? (json['updated_at']) : null,
    );
  }

  @override
  String toString() {
    return 'MarketProduct(id: $id, schoolId: $schoolId, marketProductTagId: $marketProductTagId, studentId: $studentId, staffId: $staffId, lecturerId: $lecturerId, userId: $userId, title: $title, description: $description, images: $images, amount: $amount, cost: $cost, location: $location, phone: $phone, whatsapp: $whatsapp, comment: $comment, active: $active, code: $code, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant MarketProduct other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.schoolId == schoolId &&
        other.marketProductTagId == marketProductTagId &&
        other.studentId == studentId &&
        other.staffId == staffId &&
        other.lecturerId == lecturerId &&
        other.userId == userId &&
        other.title == title &&
        other.description == description &&
        other.images == images &&
        other.amount == amount &&
        other.cost == cost &&
        other.location == location &&
        other.phone == phone &&
        other.whatsapp == whatsapp &&
        other.comment == comment &&
        other.active == active &&
        other.code == code &&
        other.deletedAt == deletedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        schoolId.hashCode ^
        marketProductTagId.hashCode ^
        studentId.hashCode ^
        staffId.hashCode ^
        lecturerId.hashCode ^
        userId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        images.hashCode ^
        amount.hashCode ^
        cost.hashCode ^
        location.hashCode ^
        phone.hashCode ^
        whatsapp.hashCode ^
        comment.hashCode ^
        active.hashCode ^
        code.hashCode ^
        deletedAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
