import 'dart:convert';

class PostRequest {
  final int schoolId;
  final int newsCategoryId;
  final String title;
  final String? excerpt;
  final String body;
  final String? media;
  final String? video; // Added field
  final String tags;
  final String? faculties;
  final String? departments;
  final int userId; // Added field

  PostRequest({
    required this.schoolId,
    required this.newsCategoryId,
    required this.title,
    this.excerpt,
    required this.body,
    this.media,
    this.video, // Added to constructor
    required this.tags,
    this.faculties,
    this.departments,
    required this.userId, // Added to constructor
  });

  Map<String, dynamic> toMap() {
    return {
      "school_id": schoolId,
      "news_category_id": newsCategoryId,
      "title": title,
      if (excerpt != null) "excerpt": excerpt,
      "body": body,
      if (media != null) "media": media,
      if (video != null) "video": video,
      "tags": tags,
      if (faculties != null) "faculties": faculties,
      if (departments != null) "departments": departments,
      "user_id": userId,
    };
  }

  PostRequest copyWith({
    int? schoolId,
    int? newsCategoryId,
    String? title,
    String? excerpt,
    String? body,
    String? media,
    String? video, // Added to copyWith
    String? tags,
    String? faculties,
    String? departments,
    int? userId, // Added to copyWith
  }) {
    return PostRequest(
      schoolId: schoolId ?? this.schoolId,
      newsCategoryId: newsCategoryId ?? this.newsCategoryId,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      body: body ?? this.body,
      media: media ?? this.media,
      video: video ?? this.video, // Added assignment
      tags: tags ?? this.tags,
      faculties: faculties ?? this.faculties,
      departments: departments ?? this.departments,
      userId: userId ?? this.userId, // Added assignment
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    // Updated toString
    return 'PostRequest(schoolId: $schoolId, newsCategoryId: $newsCategoryId, title: $title, excerpt: $excerpt, body: $body, media: $media, video: $video, tags: $tags, faculties: $faculties, departments: $departments, userId: $userId)';
  }

  @override
  bool operator ==(covariant PostRequest other) {
    if (identical(this, other)) return true;

    // Updated comparison
    return other.schoolId == schoolId &&
        other.newsCategoryId == newsCategoryId &&
        other.title == title &&
        other.excerpt == excerpt &&
        other.body == body &&
        other.media == media &&
        other.video == video && // Added comparison
        other.tags == tags &&
        other.faculties == faculties &&
        other.departments == departments &&
        other.userId == userId; // Added comparison
  }

  @override
  int get hashCode {
    // Updated hashCode
    return schoolId.hashCode ^
        newsCategoryId.hashCode ^
        title.hashCode ^
        excerpt.hashCode ^
        body.hashCode ^
        media.hashCode ^
        video.hashCode ^ // Added to hashCode
        tags.hashCode ^
        faculties.hashCode ^
        departments.hashCode ^
        userId.hashCode; // Added to hashCode
  }
}
