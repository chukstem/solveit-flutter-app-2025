import 'dart:convert';

class PostReaction {
  final int schoolId;
  final int newsId;

  PostReaction({
    required this.schoolId,
    required this.newsId,
  });

  PostReaction copyWith({
    int? schoolId,
    int? newsId,
    String? type,
  }) {
    return PostReaction(
      schoolId: schoolId ?? this.schoolId,
      newsId: newsId ?? this.newsId,
    );
  }

  Map<String, dynamic> toLike() {
    return <String, dynamic>{
      'school_id': schoolId,
      'news_id': newsId,
      'type': 'Like',
    };
  }

  Map<String, dynamic> toUnLike() {
    return <String, dynamic>{
      'school_id': schoolId,
      'news_id': newsId,
      'type': 'Unlike',
    };
  }

  String toJsonLike() => json.encode(toLike());
  String toJsonUnlike() => json.encode(toUnLike());

  @override
  String toString() => 'PostReaction($toLike(), $toUnLike())';

  @override
  bool operator ==(covariant PostReaction other) {
    if (identical(this, other)) return true;

    return other.schoolId == schoolId && other.newsId == newsId;
  }

  @override
  int get hashCode => schoolId.hashCode ^ newsId.hashCode;
}
