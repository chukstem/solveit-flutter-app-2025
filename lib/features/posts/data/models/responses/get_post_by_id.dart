import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:solveit/features/posts/data/models/responses/get_posts.dart';

class GetAllPostsResponseById {
  final bool success;
  final SinglePostResponse? post;
  final List comments;
  GetAllPostsResponseById({
    required this.success,
    this.post,
    required this.comments,
  });

  GetAllPostsResponseById copyWith({
    bool? success,
    SinglePostResponse? post,
    List? comments,
  }) {
    return GetAllPostsResponseById(
      success: success ?? this.success,
      post: post ?? this.post,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'post': post?.toMap(),
      'comments': comments,
    };
  }

  factory GetAllPostsResponseById.fromMap(Map<String, dynamic> map) {
    return GetAllPostsResponseById(
      success: map['success'] as bool,
      post: map['data']['post'] != null ? SinglePostResponse.fromMap(map['post'] as Map<String, dynamic>) : null,
      comments: List.from(
        (map['data']['comments'] as List),
      ),
    );
  }

  factory GetAllPostsResponseById.fromLocalMap(Map<String, dynamic> map) {
    return GetAllPostsResponseById(
      success: map['success'] as bool,
      post: map['post'] != null ? SinglePostResponse.fromMap(map['post'] as Map<String, dynamic>) : null,
      comments: List.from(
        (map['comments'] as List),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetAllPostsResponseById.fromJson(String source) => GetAllPostsResponseById.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GetAllPostsResponseById(success: $success, post: $post, comments: $comments)';

  @override
  bool operator ==(covariant GetAllPostsResponseById other) {
    if (identical(this, other)) return true;

    return other.success == success && other.post == post && listEquals(other.comments, comments);
  }

  @override
  int get hashCode => success.hashCode ^ post.hashCode ^ comments.hashCode;
}
