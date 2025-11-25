class CreateProductCommentReactionsRequest {
  final int schoolId;
  final int marketProductId;
  final int marketProductCommentId;
  final int marketProductCommentReplyId;
  final int userId;
  final String type;

  CreateProductCommentReactionsRequest({
    required this.schoolId,
    required this.marketProductId,
    required this.marketProductCommentId,
    required this.marketProductCommentReplyId,
    required this.userId,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'school_id': schoolId,
      'market_product_id': marketProductId,
      'market_product_comment_id': marketProductCommentId,
      'market_product_comment_reply_id': marketProductCommentReplyId,
      'user_id': userId,
      'type': type,
    };
  }
}
