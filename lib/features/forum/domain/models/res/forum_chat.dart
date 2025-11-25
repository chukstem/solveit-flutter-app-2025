// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:solveit/features/messages/domain/models/responses/chat.dart';

class ForumChatModel {
  final int chatId;
  final String title;
  final String forumPicUrl;
  final List<String> avatarUrls;
  final int students;
  final int unread;
  final List<ChatModel> chats;
  ForumChatModel({
    required this.chatId,
    required this.title,
    required this.forumPicUrl,
    required this.avatarUrls,
    required this.students,
    required this.unread,
    required this.chats,
  });

  ForumChatModel copyWith({
    int? chatId,
    String? title,
    String? forumPicUrl,
    List<String>? avatarUrls,
    int? students,
    int? unread,
    List<ChatModel>? chats,
  }) {
    return ForumChatModel(
      chatId: chatId ?? this.chatId,
      title: title ?? this.title,
      forumPicUrl: forumPicUrl ?? this.forumPicUrl,
      avatarUrls: avatarUrls ?? this.avatarUrls,
      students: students ?? this.students,
      unread: unread ?? this.unread,
      chats: chats ?? this.chats,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatId': chatId,
      'title': title,
      'forumPicUrl': forumPicUrl,
      'avatarUrls': avatarUrls,
      'students': students,
      'unread': unread,
      'chats': chats.map((x) => x.toMap()).toList(),
    };
  }

  factory ForumChatModel.fromMap(Map<String, dynamic> map) {
    return ForumChatModel(
      chatId: map['chatId'] as int,
      title: map['title'] as String,
      forumPicUrl: map['forumPicUrl'] as String,
      avatarUrls: List<String>.from((map['avatarUrls'] as List<String>)),
      students: map['students'] as int,
      unread: map['unread'] as int,
      chats: List<ChatModel>.from(
        (map['chats'] as List<int>).map<ChatModel>(
          (x) => ChatModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ForumChatModel.fromJson(String source) =>
      ForumChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ForumChatModel(chatId: $chatId, title: $title, forumPicUrl: $forumPicUrl, avatarUrls: $avatarUrls, students: $students, unread: $unread, chats: $chats)';
  }

  @override
  bool operator ==(covariant ForumChatModel other) {
    if (identical(this, other)) return true;

    return other.chatId == chatId &&
        other.title == title &&
        other.forumPicUrl == forumPicUrl &&
        listEquals(other.avatarUrls, avatarUrls) &&
        other.students == students &&
        other.unread == unread &&
        listEquals(other.chats, chats);
  }

  @override
  int get hashCode {
    return chatId.hashCode ^
        title.hashCode ^
        forumPicUrl.hashCode ^
        avatarUrls.hashCode ^
        students.hashCode ^
        unread.hashCode ^
        chats.hashCode;
  }
}
