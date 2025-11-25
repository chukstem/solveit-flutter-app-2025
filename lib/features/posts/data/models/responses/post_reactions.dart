import 'package:equatable/equatable.dart';

class AllPostReactionsResponse extends Equatable {
  final int status;
  final String message;
  final List<SinglePostReaction> data;

  const AllPostReactionsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AllPostReactionsResponse.fromMap(Map<String, dynamic> json) {
    return AllPostReactionsResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List<dynamic>).map((item) => SinglePostReaction.fromMap(item)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => item.toMap()).toList(),
    };
  }

  @override
  List<Object?> get props => [status, message, data];

  @override
  bool get stringify => true;
}

class SinglePostReaction extends Equatable {
  final int id;
  final int schoolId;
  final int newsId;
  final int? studentId;
  final int? staffId;
  final int? lecturerId;
  final int userId;
  final String type;
  final String code;
  final String? deletedAt;
  final String createdAt;
  final String? updatedAt;

  const SinglePostReaction({
    required this.id,
    required this.schoolId,
    required this.newsId,
    this.studentId,
    this.staffId,
    this.lecturerId,
    required this.userId,
    required this.type,
    required this.code,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory SinglePostReaction.fromMap(Map<String, dynamic> json) {
    return SinglePostReaction(
      id: json['id'],
      schoolId: json['school_id'],
      newsId: json['news_id'],
      studentId: json['student_id'],
      staffId: json['staff_id'],
      lecturerId: json['lecturer_id'],
      userId: json['user_id'],
      type: json['type'],
      code: json['code'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'school_id': schoolId,
      'news_id': newsId,
      'student_id': studentId,
      'staff_id': staffId,
      'lecturer_id': lecturerId,
      'user_id': userId,
      'type': type,
      'code': code,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        schoolId,
        newsId,
        studentId,
        staffId,
        lecturerId,
        userId,
        type,
        code,
        deletedAt,
        createdAt,
        updatedAt,
      ];

  @override
  bool get stringify => true;
}
