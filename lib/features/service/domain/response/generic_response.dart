class GenericCreateOrUpdateResponse {
  final int status;
  final String message;

  GenericCreateOrUpdateResponse({
    required this.status,
    required this.message,
  });

  factory GenericCreateOrUpdateResponse.fromMap(Map<String, dynamic> map) {
    return GenericCreateOrUpdateResponse(
      status: map['status'],
      message: map['message'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
    };
  }

  GenericCreateOrUpdateResponse copyWith({
    int? status,
    String? message,
  }) {
    return GenericCreateOrUpdateResponse(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenericCreateOrUpdateResponse && runtimeType == other.runtimeType && status == other.status && message == other.message;

  @override
  int get hashCode => status.hashCode ^ message.hashCode;
}
