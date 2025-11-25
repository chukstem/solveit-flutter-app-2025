class UpdateProductCommentReactionRequest {
  final int id;
  final String type;

  UpdateProductCommentReactionRequest({
    required this.id,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
    };
  }
}
