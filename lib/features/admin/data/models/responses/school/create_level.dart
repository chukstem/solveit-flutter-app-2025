class CreateLevelResponse {
  final int status;
  final String message;

  CreateLevelResponse({
    required this.status,
    required this.message,
  });

  factory CreateLevelResponse.fromMap(Map<String, dynamic> json) {
    return CreateLevelResponse(
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "status": status,
      "message": message,
    };
  }
}