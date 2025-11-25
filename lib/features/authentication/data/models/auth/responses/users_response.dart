// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:solveit/features/authentication/data/models/auth/responses/get_user_response.dart';

class AllStudentsOrUserResponse {
  final int status;
  final String message;
  final List<StudentOrUserModel> data;
  AllStudentsOrUserResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AllStudentsOrUserResponse.fromMap(Map<String, dynamic> json) {
    return AllStudentsOrUserResponse(
      status: json['status'],
      message: json['message'],
      data: List<StudentOrUserModel>.from(json['data'].map((x) => StudentOrUserModel.fromMap(x))),
    );
  }

  AllStudentsOrUserResponse copyWith({
    int? status,
    String? message,
    List<StudentOrUserModel>? data,
  }) {
    return AllStudentsOrUserResponse(
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

  // factory AllStudentsOrUserResponse.fromMap(Map<String, dynamic> map) {
  //   return AllStudentsOrUserResponse(
  //     status: map['status'] as int,
  //     message: map['message'] as String,
  //     data: List<StudentOrUserModel>.from((map['data'] as List<int>).map<StudentOrUserModel>((x) => StudentOrUserModel.fromMap(x as Map<String,dynamic>),),),
  //   );
  // }

  String toJson() => json.encode(toMap());

  factory AllStudentsOrUserResponse.fromJson(String source) => AllStudentsOrUserResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AllStudentsOrUserResponse(status: $status, message: $message, data: $data)';

  @override
  bool operator ==(covariant AllStudentsOrUserResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message && listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;
}
