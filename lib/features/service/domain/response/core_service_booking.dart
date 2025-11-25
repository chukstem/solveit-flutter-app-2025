// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CoreServiceBookingsResponse {
  final int status;
  final String message;
  final List<CoreServiceBooking> data;
  CoreServiceBookingsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CoreServiceBookingsResponse.fromMap(Map<String, dynamic> map) {
    return CoreServiceBookingsResponse(
      status: map['status'],
      message: map['message'],
      data: List<CoreServiceBooking>.from(
        map['data'].map((x) => CoreServiceBooking.fromMap(x)),
      ),
    );
  }

  CoreServiceBookingsResponse copyWith({
    int? status,
    String? message,
    List<CoreServiceBooking>? data,
  }) {
    return CoreServiceBookingsResponse(
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

  String toJson() => json.encode(toMap());

  factory CoreServiceBookingsResponse.fromJson(String source) => CoreServiceBookingsResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CoreServiceBookingsResponse(status: $status, message: $message, data: $data)';

  @override
  bool operator ==(covariant CoreServiceBookingsResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message && listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;
}

class CoreServiceBooking {
  final int id;
  final int schoolId;
  final int providerId;
  final int coreServiceId;
  final int? studentId;
  final int? staffId;
  final int? lecturerId;
  final int userId;
  final int coreServiceEscrowId;
  final int coreServicePaymentId;
  final int completed;
  final String? completedAt;
  final int delivered;
  final String? deliveredAt;
  final int cancelled;
  final String? cancelledAt;
  final int accepted;
  final String? acceptedAt;
  final String amount;
  final String status;
  final String code;
  final String? deletedAt;
  final String createdAt;
  final String? updatedAt;
  CoreServiceBooking({
    required this.id,
    required this.schoolId,
    required this.providerId,
    required this.coreServiceId,
    this.studentId,
    this.staffId,
    this.lecturerId,
    required this.userId,
    required this.coreServiceEscrowId,
    required this.coreServicePaymentId,
    required this.completed,
    this.completedAt,
    required this.delivered,
    this.deliveredAt,
    required this.cancelled,
    this.cancelledAt,
    required this.accepted,
    this.acceptedAt,
    required this.amount,
    required this.status,
    required this.code,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory CoreServiceBooking.fromMap(Map<String, dynamic> map) {
    return CoreServiceBooking(
      id: map['id'],
      schoolId: map['school_id'],
      providerId: map['provider_id'],
      coreServiceId: map['core_service_id'],
      studentId: map['student_id'],
      staffId: map['staff_id'],
      lecturerId: map['lecturer_id'],
      userId: map['user_id'],
      coreServiceEscrowId: map['core_service_escrow_id'],
      coreServicePaymentId: map['core_service_payment_id'],
      completed: map['completed'],
      completedAt: map['completed_at'],
      delivered: map['delivered'],
      deliveredAt: map['delivered_at'],
      cancelled: map['cancelled'],
      cancelledAt: map['cancelled_at'],
      accepted: map['accepted'],
      acceptedAt: map['accepted_at'],
      amount: map['amount'],
      status: map['status'],
      code: map['code'],
      deletedAt: map['deleted_at'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  CoreServiceBooking copyWith({
    int? id,
    int? schoolId,
    int? providerId,
    int? coreServiceId,
    int? studentId,
    int? staffId,
    int? lecturerId,
    int? userId,
    int? coreServiceEscrowId,
    int? coreServicePaymentId,
    int? completed,
    String? completedAt,
    int? delivered,
    String? deliveredAt,
    int? cancelled,
    String? cancelledAt,
    int? accepted,
    String? acceptedAt,
    String? amount,
    String? status,
    String? code,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return CoreServiceBooking(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      providerId: providerId ?? this.providerId,
      coreServiceId: coreServiceId ?? this.coreServiceId,
      studentId: studentId ?? this.studentId,
      staffId: staffId ?? this.staffId,
      lecturerId: lecturerId ?? this.lecturerId,
      userId: userId ?? this.userId,
      coreServiceEscrowId: coreServiceEscrowId ?? this.coreServiceEscrowId,
      coreServicePaymentId: coreServicePaymentId ?? this.coreServicePaymentId,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      delivered: delivered ?? this.delivered,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      cancelled: cancelled ?? this.cancelled,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      accepted: accepted ?? this.accepted,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      amount: amount ?? this.amount,
      status: status ?? this.status,
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
      'provider_id': providerId,
      'core_service_id': coreServiceId,
      'student_id': studentId,
      'staff_id': staffId,
      'lecturer_id': lecturerId,
      'user_id': userId,
      'core_service_escrow_id': coreServiceEscrowId,
      'core_service_payment_id': coreServicePaymentId,
      'completed': completed,
      'completed_at': completedAt,
      'delivered': delivered,
      'delivered_at': deliveredAt,
      'cancelled': cancelled,
      'cancelled_at': cancelledAt,
      'accepted': accepted,
      'accepted_at': acceptedAt,
      'amount': amount,
      'status': status,
      'code': code,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  String toJson() => json.encode(toMap());

  factory CoreServiceBooking.fromJson(String source) => CoreServiceBooking.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CoreServiceBooking(id: $id, schoolId: $schoolId, providerId: $providerId, coreServiceId: $coreServiceId, studentId: $studentId, staffId: $staffId, lecturerId: $lecturerId, userId: $userId, coreServiceEscrowId: $coreServiceEscrowId, coreServicePaymentId: $coreServicePaymentId, completed: $completed, completedAt: $completedAt, delivered: $delivered, deliveredAt: $deliveredAt, cancelled: $cancelled, cancelledAt: $cancelledAt, accepted: $accepted, acceptedAt: $acceptedAt, amount: $amount, status: $status, code: $code, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant CoreServiceBooking other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.schoolId == schoolId &&
        other.providerId == providerId &&
        other.coreServiceId == coreServiceId &&
        other.studentId == studentId &&
        other.staffId == staffId &&
        other.lecturerId == lecturerId &&
        other.userId == userId &&
        other.coreServiceEscrowId == coreServiceEscrowId &&
        other.coreServicePaymentId == coreServicePaymentId &&
        other.completed == completed &&
        other.completedAt == completedAt &&
        other.delivered == delivered &&
        other.deliveredAt == deliveredAt &&
        other.cancelled == cancelled &&
        other.cancelledAt == cancelledAt &&
        other.accepted == accepted &&
        other.acceptedAt == acceptedAt &&
        other.amount == amount &&
        other.status == status &&
        other.code == code &&
        other.deletedAt == deletedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        schoolId.hashCode ^
        providerId.hashCode ^
        coreServiceId.hashCode ^
        studentId.hashCode ^
        staffId.hashCode ^
        lecturerId.hashCode ^
        userId.hashCode ^
        coreServiceEscrowId.hashCode ^
        coreServicePaymentId.hashCode ^
        completed.hashCode ^
        completedAt.hashCode ^
        delivered.hashCode ^
        deliveredAt.hashCode ^
        cancelled.hashCode ^
        cancelledAt.hashCode ^
        accepted.hashCode ^
        acceptedAt.hashCode ^
        amount.hashCode ^
        status.hashCode ^
        code.hashCode ^
        deletedAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
