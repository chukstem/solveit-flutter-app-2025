class UpdateProductTagsRequest {
  final int id;
  final String name;

  UpdateProductTagsRequest({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
