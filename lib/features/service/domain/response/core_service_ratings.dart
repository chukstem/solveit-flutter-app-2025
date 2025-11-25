class CoreServiceRatingsResponse {
  final int status;
  final String message;
  final List<CoreServiceRating> data;

  CoreServiceRatingsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CoreServiceRatingsResponse.fromMap(Map<String, dynamic> map) {
    return CoreServiceRatingsResponse(
      status: map['status'],
      message: map['message'],
      data: List<CoreServiceRating>.from(
        map['data'].map((x) => CoreServiceRating.fromMap(x)),
      ),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
        'data': data.map((e) => e.toMap()).toList(),
      };
}

class CoreServiceRating {
  final int id;
  final int schoolId;
  final int providerId;
  final int coreServiceId;
  final int coreServiceBookingId;
  final int? studentId;
  final int? staffId;
  final int? lecturerId;
  final int userId;
  final String rating;
  final String body;
  final String code;
  final String? deletedAt;
  final String createdAt;
  final String? updatedAt;

  CoreServiceRating({
    required this.id,
    required this.schoolId,
    required this.providerId,
    required this.coreServiceId,
    required this.coreServiceBookingId,
    this.studentId,
    this.staffId,
    this.lecturerId,
    required this.userId,
    required this.rating,
    required this.body,
    required this.code,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory CoreServiceRating.fromMap(Map<String, dynamic> map) {
    return CoreServiceRating(
      id: map['id'],
      schoolId: map['school_id'],
      providerId: map['provider_id'],
      coreServiceId: map['core_service_id'],
      coreServiceBookingId: map['core_service_booking_id'],
      studentId: map['student_id'],
      staffId: map['staff_id'],
      lecturerId: map['lecturer_id'],
      userId: map['user_id'],
      rating: map['rating'],
      body: map['body'],
      code: map['code'],
      deletedAt: map['deleted_at'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
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
        'rating': rating,
        'body': body,
        'code': code,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  CoreServiceRating copyWith({
    int? id,
    int? schoolId,
    int? providerId,
    int? coreServiceId,
    int? coreServiceBookingId,
    int? studentId,
    int? staffId,
    int? lecturerId,
    int? userId,
    String? rating,
    String? body,
    String? code,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return CoreServiceRating(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      providerId: providerId ?? this.providerId,
      coreServiceId: coreServiceId ?? this.coreServiceId,
      coreServiceBookingId: coreServiceBookingId ?? this.coreServiceBookingId,
      studentId: studentId ?? this.studentId,
      staffId: staffId ?? this.staffId,
      lecturerId: lecturerId ?? this.lecturerId,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      body: body ?? this.body,
      code: code ?? this.code,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoreServiceRating &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          schoolId == other.schoolId &&
          providerId == other.providerId &&
          coreServiceId == other.coreServiceId &&
          coreServiceBookingId == other.coreServiceBookingId &&
          studentId == other.studentId &&
          staffId == other.staffId &&
          lecturerId == other.lecturerId &&
          userId == other.userId &&
          rating == other.rating &&
          body == other.body &&
          code == other.code &&
          deletedAt == other.deletedAt &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      schoolId.hashCode ^
      providerId.hashCode ^
      coreServiceId.hashCode ^
      coreServiceBookingId.hashCode ^
      studentId.hashCode ^
      staffId.hashCode ^
      lecturerId.hashCode ^
      userId.hashCode ^
      rating.hashCode ^
      body.hashCode ^
      code.hashCode ^
      deletedAt.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
