class UpdateProductDetailsRequest {
  final int id;
  final String title;
  final String description;
  final String images;
  final String amount;
  final String cost;
  final String location;
  final String phone;

  UpdateProductDetailsRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.amount,
    required this.cost,
    required this.location,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'images': images,
      'amount': amount,
      'cost': cost,
      'location': location,
      'phone': phone,
    };
  }
}
