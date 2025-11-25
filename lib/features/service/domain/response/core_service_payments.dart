class CoreServicePaymentsResponse {
  final int status;
  final String message;
  final List<CoreServicePayment> data;

  CoreServicePaymentsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CoreServicePaymentsResponse.fromMap(Map<String, dynamic> map) {
    return CoreServicePaymentsResponse(
      status: map['status'],
      message: map['message'],
      data: List<CoreServicePayment>.from(
        map['data'].map((x) => CoreServicePayment.fromMap(x)),
      ),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
        'data': data.map((e) => e.toMap()).toList(),
      };
}

class CoreServicePayment {
  final int id;
  final int schoolId;
  final int providerId;
  final int coreServiceId;
  final int coreServiceBookingId;
  final int? studentId;
  final int? staffId;
  final int? lecturerId;
  final int userId;
  final int coreServiceEscrowId;
  final String amount;
  final String reference;
  final String code;
  final String? deletedAt;
  final String createdAt;
  final String? updatedAt;
  final String status;

  CoreServicePayment({
    required this.id,
    required this.schoolId,
    required this.providerId,
    required this.coreServiceId,
    required this.coreServiceBookingId,
    this.studentId,
    this.staffId,
    this.lecturerId,
    required this.userId,
    required this.coreServiceEscrowId,
    required this.amount,
    required this.reference,
    required this.code,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
    required this.status,
  });

  factory CoreServicePayment.fromMap(Map<String, dynamic> map) {
    return CoreServicePayment(
      id: map['id'],
      schoolId: map['school_id'],
      providerId: map['provider_id'],
      coreServiceId: map['core_service_id'],
      coreServiceBookingId: map['core_service_booking_id'],
      studentId: map['student_id'],
      staffId: map['staff_id'],
      lecturerId: map['lecturer_id'],
      userId: map['user_id'],
      coreServiceEscrowId: map['core_service_escrow_id'],
      amount: map['amount'],
      reference: map['reference'],
      code: map['code'],
      deletedAt: map['deleted_at'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'school_id': schoolId,
        'provider_id': providerId,
        'core_service_id': coreServiceId,
        'core_service_booking_id': coreServiceBookingId,
        'student_id': studentId,
        'staff_id': staffId,
        'lecturer_id': lecturerId,
        'user_id': userId,
        'core_service_escrow_id': coreServiceEscrowId,
        'amount': amount,
        'reference': reference,
        'code': code,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'status': status,
      };
}
