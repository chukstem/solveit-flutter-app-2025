class CreateProductCommentRequest {
  final int schoolId;
  final int marketProductId;
  final int studentId;
  final String body;
  final String images;

  CreateProductCommentRequest({
    required this.schoolId,
    required this.marketProductId,
    required this.studentId,
    required this.body,
    required this.images,
  });

  Map<String, dynamic> toMap() {
    return {
      'school_id': schoolId,
      'market_product_id': marketProductId,
      'student_id': studentId,
      'body': body,
      'images': images,
    };
  }
}
