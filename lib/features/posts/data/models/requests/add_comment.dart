import 'dart:convert';

class AddOrReplyComment {
  final String body;
  final int schoolId;
  final int userId;
  final int newsId;
  final int? newsCommentId;
  AddOrReplyComment({
    required this.body,
    required this.schoolId,
    required this.userId,
    required this.newsId,
    this.newsCommentId,
  });

  AddOrReplyComment copyWith({
    String? body,
    int? schoolId,
    int? userId,
    int? newsId,
    int? newsCommentId,
  }) {
    return AddOrReplyComment(
      body: body ?? this.body,
      schoolId: schoolId ?? this.schoolId,
      userId: userId ?? this.userId,
      newsId: newsId ?? this.newsId,
      newsCommentId: newsCommentId ?? this.newsCommentId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'body': body,
      'school_id': schoolId,
      'user_id': userId,
      'news_id': newsId,
      if (newsCommentId != null) 'news_comment_id': newsCommentId
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'AddOrReplyComment(body: $body, schoolId: $schoolId, userId: $userId, newsId: $newsId, newsCommentId: $newsCommentId,)';
  }

  @override
  bool operator ==(covariant AddOrReplyComment other) {
    if (identical(this, other)) return true;

    return other.body == body && other.schoolId == schoolId && other.userId == userId && other.newsId == newsId;
  }

  @override
  int get hashCode {
    return body.hashCode ^ schoolId.hashCode ^ userId.hashCode ^ newsId.hashCode;
  }
}
