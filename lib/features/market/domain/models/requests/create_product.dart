class CreateProductRequest {
  final int schoolId;
  final int marketProductTagId;
  final int studentId;
  final int userId;
  final String title;
  final String description;
  final String images;
  final String amount;
  final String cost;
  final String location;
  final String phone;
  final String whatsapp;
  final String comment;
  final bool active;

  CreateProductRequest({
    required this.schoolId,
    required this.marketProductTagId,
    required this.studentId,
    required this.userId,
    required this.title,
    required this.description,
    required this.images,
    required this.amount,
    required this.cost,
    required this.location,
    required this.phone,
    required this.whatsapp,
    required this.comment,
    required this.active,
  });

  Map<String, dynamic> toMap() {
    return {
      'school_id': schoolId,
      'market_product_tag_id': marketProductTagId,
      'student_id': studentId,
      'user_id': userId,
      'title': title,
      'description': description,
      'images': images,
      'amount': amount,
      'cost': cost,
      'location': location,
      'phone': phone,
      'whatsapp': whatsapp,
      'comment': comment,
      'active': active,
    };
  }
}
