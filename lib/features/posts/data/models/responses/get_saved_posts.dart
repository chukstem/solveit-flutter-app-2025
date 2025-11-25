import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:solveit/features/posts/data/models/responses/get_posts.dart';

class AllSavedPostsResponse {
  final bool success;
  final List<SinglePostResponse>? data;
  AllSavedPostsResponse({
    required this.success,
    this.data,
  });

  AllSavedPostsResponse copyWith({
    bool? success,
    List<SinglePostResponse>? data,
  }) {
    return AllSavedPostsResponse(
      success: success ?? this.success,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'data': data?.map((x) => x.toMap()).toList(),
    };
  }

  factory AllSavedPostsResponse.fromMap(Map<String, dynamic> map) {
    return AllSavedPostsResponse(
      success: map['success'] as bool,
      data: map['data'] != null
          ? List<SinglePostResponse>.from(
              (map['data'] as List<dynamic>).map<SinglePostResponse?>(
                (x) => SinglePostResponse.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AllSavedPostsResponse.fromJson(String source) => AllSavedPostsResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AllSavedPostsResponse(success: $success, data: $data)';

  @override
  bool operator ==(covariant AllSavedPostsResponse other) {
    if (identical(this, other)) return true;

    return other.success == success && listEquals(other.data, data);
  }

  @override
  int get hashCode => success.hashCode ^ data.hashCode;
}
