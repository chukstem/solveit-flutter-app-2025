class UpdateProductCommentRequest {
  final int id;
  final String body;
  final String commentType;

  UpdateProductCommentRequest({
    required this.id,
    required this.body,
    required this.commentType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'body': body,
      'commentType': commentType,
    };
  }
}
