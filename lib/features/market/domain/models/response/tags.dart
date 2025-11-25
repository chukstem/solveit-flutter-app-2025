import 'package:flutter/foundation.dart';

class MarketplaceTagResponse {
  final int status;
  final String message;
  final List<MarketTag> data;

  MarketplaceTagResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MarketplaceTagResponse.fromMap(Map<String, dynamic> json) {
    return MarketplaceTagResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List<dynamic>).map((item) => MarketTag.fromMap(item)).toList(),
    );
  }

  @override
  String toString() => 'MarketplaceTagResponse(status: $status, message: $message, data: $data)';

  @override
  bool operator ==(covariant MarketplaceTagResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message && listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;
}

class MarketTag {
  final int id;
  final int schoolId;
  final String name;
  final String code;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  MarketTag({
    required this.id,
    required this.schoolId,
    required this.name,
    required this.code,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MarketTag.fromMap(Map<String, dynamic> json) {
    return MarketTag(
      id: json['id'],
      schoolId: json['school_id'],
      name: json['name'],
      code: json['code'],
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
