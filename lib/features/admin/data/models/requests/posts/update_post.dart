class UpdatePostRequest {
  final int id;
  final String title;
  final String excerpt;
  final String body;
  final String media;

  UpdatePostRequest({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.body,
    required this.media,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "excerpt": excerpt,
      "body": body,
      "media": media,
    };
  }
}
