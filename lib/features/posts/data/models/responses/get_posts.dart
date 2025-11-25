import 'dart:convert';

import 'package:flutter/foundation.dart';

class AllPostsResponse {
  final int status;
  final String message;
  final List<SinglePostResponse>? data;

  AllPostsResponse({
    required this.status,
    required this.message,
    this.data,
  });

  AllPostsResponse copyWith({
    int? status,
    String? message,
    List<SinglePostResponse>? data,
  }) {
    return AllPostsResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': data?.map((x) => x.toMap()).toList(),
    };
  }

  factory AllPostsResponse.fromMap(Map<String, dynamic> map) {
    return AllPostsResponse(
      status: map['status'] as int,
      message: map['message'] as String,
      data: map['data'] != null
          ? List<SinglePostResponse>.from(
              (map['data'] as List<dynamic>).map<SinglePostResponse>(
                (x) => SinglePostResponse.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AllPostsResponse.fromJson(String source) => AllPostsResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AllPostsResponse(status: $status, message: $message, data: $data)';

  @override
  bool operator ==(covariant AllPostsResponse other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message && listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;
}

class SinglePostResponse {
  final int id;
  final int schoolId;
  final int newsCategoryId;
  final String title;
  final String excerpt;
  final String body;
  final String media;
  final String? video;
  final String tags;
  final String faculties;
  final String departments;
  final dynamic levels;
  final dynamic interests;
  final int students;
  final int staffs;
  final int lecturers;
  final int users;
  final int featured;
  final int enableComments;
  final int enableReactions;
  final String code;
  final String? deletedAt;
  final String createdAt;
  final String? updatedAt;
  final int userId;

  SinglePostResponse({
    required this.id,
    required this.schoolId,
    required this.newsCategoryId,
    required this.title,
    required this.excerpt,
    required this.body,
    required this.media,
    this.video,
    required this.tags,
    required this.faculties,
    required this.departments,
    this.levels,
    this.interests,
    required this.students,
    required this.staffs,
    required this.lecturers,
    required this.users,
    required this.featured,
    required this.enableComments,
    required this.enableReactions,
    required this.code,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
    required this.userId,
  });

  SinglePostResponse copyWith({
    int? id,
    int? schoolId,
    int? newsCategoryId,
    String? title,
    String? excerpt,
    String? body,
    String? media,
    String? video,
    String? tags,
    String? faculties,
    String? departments,
    dynamic levels,
    dynamic interests,
    int? students,
    int? staffs,
    int? lecturers,
    int? users,
    int? featured,
    int? enableComments,
    int? enableReactions,
    String? code,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
    dynamic userId,
  }) {
    return SinglePostResponse(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      newsCategoryId: newsCategoryId ?? this.newsCategoryId,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      body: body ?? this.body,
      media: media ?? this.media,
      video: video ?? this.video,
      tags: tags ?? this.tags,
      faculties: faculties ?? this.faculties,
      departments: departments ?? this.departments,
      levels: levels ?? this.levels,
      interests: interests ?? this.interests,
      students: students ?? this.students,
      staffs: staffs ?? this.staffs,
      lecturers: lecturers ?? this.lecturers,
      users: users ?? this.users,
      featured: featured ?? this.featured,
      enableComments: enableComments ?? this.enableComments,
      enableReactions: enableReactions ?? this.enableReactions,
      code: code ?? this.code,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'school_id': schoolId,
      'news_category_id': newsCategoryId,
      'title': title,
      'excerpt': excerpt,
      'body': body,
      'media': media,
      'video': video,
      'tags': tags,
      'faculties': faculties,
      'departments': departments,
      'levels': levels,
      'interests': interests,
      'students': students,
      'staffs': staffs,
      'lecturers': lecturers,
      'users': users,
      'featured': featured,
      'enable_comments': enableComments,
      'enable_reactions': enableReactions,
      'code': code,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user_id': userId,
    };
  }

  factory SinglePostResponse.fromMap(Map<String, dynamic> map) {
    return SinglePostResponse(
      id: map['id'] as int,
      schoolId: map['school_id'] as int,
      newsCategoryId: map['news_category_id'] as int,
      title: map['title'] as String,
      excerpt: map['excerpt'] ?? '',
      body: map['body'] as String,
      media: map['media'] ?? '',
      video: map['video'] as String?,
      tags: map['tags'] as String,
      faculties: map['faculties'] ?? '',
      departments: map['departments'] ?? '',
      levels: map['levels'],
      interests: map['interests'],
      students: map['students'] as int,
      staffs: map['staffs'] as int,
      lecturers: map['lecturers'] as int,
      users: map['users'] as int,
      featured: map['featured'] as int,
      enableComments: map['enable_comments'] as int,
      enableReactions: map['enable_reactions'] as int,
      code: map['code'] ?? '',
      deletedAt: map['deleted_at'] as String?,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String?,
      userId: map['user_id'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SinglePostResponse.fromJson(String source) => SinglePostResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SinglePostResponse(id: $id, schoolId: $schoolId, newsCategoryId: $newsCategoryId, title: $title, excerpt: $excerpt, body: $body, media: $media, video: $video, tags: $tags, faculties: $faculties, departments: $departments, levels: $levels, interests: $interests, students: $students, staffs: $staffs, lecturers: $lecturers, users: $users, featured: $featured, enableComments: $enableComments, enableReactions: $enableReactions, code: $code, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId)';
  }

  @override
  bool operator ==(covariant SinglePostResponse other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.schoolId == schoolId &&
        other.newsCategoryId == newsCategoryId &&
        other.title == title &&
        other.excerpt == excerpt &&
        other.body == body &&
        other.media == media &&
        other.video == video &&
        other.tags == tags &&
        other.faculties == faculties &&
        other.departments == departments &&
        other.levels == levels &&
        other.interests == interests &&
        other.students == students &&
        other.staffs == staffs &&
        other.lecturers == lecturers &&
        other.users == users &&
        other.featured == featured &&
        other.enableComments == enableComments &&
        other.enableReactions == enableReactions &&
        other.code == code &&
        other.deletedAt == deletedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        schoolId.hashCode ^
        newsCategoryId.hashCode ^
        title.hashCode ^
        excerpt.hashCode ^
        body.hashCode ^
        media.hashCode ^
        video.hashCode ^
        tags.hashCode ^
        faculties.hashCode ^
        departments.hashCode ^
        levels.hashCode ^
        interests.hashCode ^
        students.hashCode ^
        staffs.hashCode ^
        lecturers.hashCode ^
        users.hashCode ^
        featured.hashCode ^
        enableComments.hashCode ^
        enableReactions.hashCode ^
        code.hashCode ^
        deletedAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        userId.hashCode;
  }
}
