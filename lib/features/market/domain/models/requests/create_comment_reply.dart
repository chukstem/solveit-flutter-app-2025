class CreateCommentReplyRequest {
  final int schoolId;
  final int marketProductId;
  final int marketProductCommentId;
  final String body;

  CreateCommentReplyRequest({
    required this.schoolId,
    required this.marketProductId,
    required this.marketProductCommentId,
    required this.body,
  });

  Map<String, dynamic> toMap() {
    return {
      'school_id': schoolId,
      'market_product_id': marketProductId,
      'market_product_comment_id': marketProductCommentId,
      'body': body,
    };
  }
}
