class CreateProductTagsRequest {
  final int schoolId;
  final String name;

  CreateProductTagsRequest({
    required this.schoolId,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'school_id': schoolId,
      'name': name,
    };
  }
}
