// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CoreServiceEscrowsResponse {
  final int status;
  final String message;
  final List<CoreServiceEscrow> data;
  CoreServiceEscrowsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CoreServiceEscrowsResponse.fromMap(Map<String, dynamic> map) {
    return CoreServiceEscrowsResponse(
      status: map['status'],
      message: map['message'],
      data: List<CoreServiceEscrow>.from(
        map['data'].map((x) => CoreServiceEscrow.fromMap(x)),
      ),
    );
  }

  CoreServiceEscrowsResponse copyWith({
    int? status,
    String? message,
    List<CoreServiceEscrow>? data,
  }) {
    return CoreServiceEscrowsResponse(
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

  factory CoreServiceEscrowsResponse.fromJson(String source) => CoreServiceEscrowsResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CoreServiceEscrowsResponse(status: $status, message: $message, data: $data)';

  @override
  bool operator ==(covariant CoreServiceEscrowsResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message && listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;
}

class CoreServiceEscrow {
  final int id;
  final int schoolId;
  final int providerId;
  final int coreServiceId;
  final int coreServiceBookingId;
  final int? studentId;
  final int? staffId;
  final int? lecturerId;
  final int userId;
  final int coreServicePaymentId;
  final String amount;
  final String status;
  final int completed;
  final String? completedAt;
  final String code;
  final String? deletedAt;
  final String createdAt;
  final String? updatedAt;
  CoreServiceEscrow({
    required this.id,
    required this.schoolId,
    required this.providerId,
    required this.coreServiceId,
    required this.coreServiceBookingId,
    this.studentId,
    this.staffId,
    this.lecturerId,
    required this.userId,
    required this.coreServicePaymentId,
    required this.amount,
    required this.status,
    required this.completed,
    this.completedAt,
    required this.code,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory CoreServiceEscrow.fromMap(Map<String, dynamic> map) {
    return CoreServiceEscrow(
      id: map['id'],
      schoolId: map['school_id'],
      providerId: map['provider_id'],
      coreServiceId: map['core_service_id'],
      coreServiceBookingId: map['core_service_booking_id'],
      studentId: map['student_id'],
      staffId: map['staff_id'],
      lecturerId: map['lecturer_id'],
      userId: map['user_id'],
      coreServicePaymentId: map['core_service_payment_id'],
      amount: map['amount'],
      status: map['status'],
      completed: map['completed'],
      completedAt: map['completed_at'],
      code: map['code'],
      deletedAt: map['deleted_at'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  CoreServiceEscrow copyWith({
    int? id,
    int? schoolId,
    int? providerId,
    int? coreServiceId,
    int? coreServiceBookingId,
    int? studentId,
    int? staffId,
    int? lecturerId,
    int? userId,
    int? coreServicePaymentId,
    String? amount,
    String? status,
    int? completed,
    String? completedAt,
    String? code,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return CoreServiceEscrow(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      providerId: providerId ?? this.providerId,
      coreServiceId: coreServiceId ?? this.coreServiceId,
      coreServiceBookingId: coreServiceBookingId ?? this.coreServiceBookingId,
      studentId: studentId ?? this.studentId,
      staffId: staffId ?? this.staffId,
      lecturerId: lecturerId ?? this.lecturerId,
      userId: userId ?? this.userId,
      coreServicePaymentId: coreServicePaymentId ?? this.coreServicePaymentId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
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
      'core_service_booking_id': coreServiceBookingId,
      'student_id': studentId,
      'staff_id': staffId,
      'lecturer_id': lecturerId,
      'user_id': userId,
      'core_service_payment_id': coreServicePaymentId,
      'amount': amount,
      'status': status,
      'completed': completed,
      'completed_at': completedAt,
      'code': code,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  String toJson() => json.encode(toMap());

  factory CoreServiceEscrow.fromJson(String source) => CoreServiceEscrow.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CoreServiceEscrow(id: $id, schoolId: $schoolId, providerId: $providerId, coreServiceId: $coreServiceId, coreServiceBookingId: $coreServiceBookingId, studentId: $studentId, staffId: $staffId, lecturerId: $lecturerId, userId: $userId, coreServicePaymentId: $coreServicePaymentId, amount: $amount, status: $status, completed: $completed, completedAt: $completedAt, code: $code, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant CoreServiceEscrow other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.schoolId == schoolId &&
        other.providerId == providerId &&
        other.coreServiceId == coreServiceId &&
        other.coreServiceBookingId == coreServiceBookingId &&
        other.studentId == studentId &&
        other.staffId == staffId &&
        other.lecturerId == lecturerId &&
        other.userId == userId &&
        other.coreServicePaymentId == coreServicePaymentId &&
        other.amount == amount &&
        other.status == status &&
        other.completed == completed &&
        other.completedAt == completedAt &&
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
        coreServiceBookingId.hashCode ^
        studentId.hashCode ^
        staffId.hashCode ^
        lecturerId.hashCode ^
        userId.hashCode ^
        coreServicePaymentId.hashCode ^
        amount.hashCode ^
        status.hashCode ^
        completed.hashCode ^
        completedAt.hashCode ^
        code.hashCode ^
        deletedAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
