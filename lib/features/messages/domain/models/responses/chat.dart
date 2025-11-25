// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class SingleChatModel {
  final int chatId;
  final String name;
  final String avatarUrl;
  final String type;
  final bool isOnline;
  final bool? isVerified;
  final List<ChatModel> chats;
  SingleChatModel({
    required this.chatId,
    required this.name,
    required this.avatarUrl,
    required this.type,
    required this.isOnline,
    this.isVerified,
    required this.chats,
  });
  SingleChatModel copyWith({
    int? chatId,
    String? name,
    String? avatarUrl,
    String? type,
    bool? isOnline,
    bool? isVerified,
    List<ChatModel>? chats,
  }) {
    return SingleChatModel(
      chatId: chatId ?? this.chatId,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      type: type ?? this.type,
      isOnline: isOnline ?? this.isOnline,
      isVerified: isVerified ?? this.isVerified,
      chats: chats ?? this.chats,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatId': chatId,
      'name': name,
      'avatarUrl': avatarUrl,
      'type': type,
      'isOnline': isOnline,
      'isVerified': isVerified,
      'chats': chats.map((x) => x.toMap()).toList(),
    };
  }

  factory SingleChatModel.fromMap(Map<String, dynamic> map) {
    return SingleChatModel(
      chatId: map['chatId'] as int,
      name: map['name'] as String,
      avatarUrl: map['avatarUrl'] as String,
      type: map['type'] as String,
      isOnline: map['isOnline'] as bool,
      isVerified: map['isVerified'] != null ? map['isVerified'] as bool : null,
      chats: List<ChatModel>.from(
        (map['chats'] as List<int>).map<ChatModel>(
          (x) => ChatModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleChatModel.fromJson(String source) =>
      SingleChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SingleChatModel(chatId: $chatId, name: $name, avatarUrl: $avatarUrl, type: $type, isOnline: $isOnline, isVerified: $isVerified, chats: $chats)';
  }

  @override
  bool operator ==(covariant SingleChatModel other) {
    if (identical(this, other)) return true;

    return other.chatId == chatId &&
        other.name == name &&
        other.avatarUrl == avatarUrl &&
        other.type == type &&
        other.isOnline == isOnline &&
        other.isVerified == isVerified &&
        listEquals(other.chats, chats);
  }

  @override
  int get hashCode {
    return chatId.hashCode ^
        name.hashCode ^
        avatarUrl.hashCode ^
        type.hashCode ^
        isOnline.hashCode ^
        isVerified.hashCode ^
        chats.hashCode;
  }
}

class ChatModel {
  final ChatReply? chatReply;
  final List<String>? mediaUrls;
  final String? text;
  final bool isMine;
  final DateTime timeAgo;
  final Product? product;
  final bool isRead; // Read receipt
  final bool isDelivered; // Delivered receipt
  ChatModel({
    this.chatReply,
    this.mediaUrls,
    this.text,
    required this.isMine,
    required this.timeAgo,
    this.product,
    this.isRead = false,
    this.isDelivered = false,
  });

  bool checkValid() {
    return text != null && mediaUrls != null;
  }

  ChatModel copyWith({
    ChatReply? chatReply,
    List<String>? mediaUrls,
    String? text,
    bool? isMine,
    DateTime? timeAgo,
    Product? product,
    bool? isRead,
    bool? isDelivered,
  }) {
    return ChatModel(
      chatReply: chatReply ?? this.chatReply,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      text: text ?? this.text,
      isMine: isMine ?? this.isMine,
      timeAgo: timeAgo ?? this.timeAgo,
      product: product ?? this.product,
      isRead: isRead ?? this.isRead,
      isDelivered: isDelivered ?? this.isDelivered,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatReply': chatReply?.toMap(),
      'mediaUrls': mediaUrls,
      'text': text,
      'isMine': isMine,
      'timeAgo': timeAgo.millisecondsSinceEpoch,
      'isRead': isRead,
      'isDelivered': isDelivered,
      'product': product?.toMap(),
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatReply: map['chatReply'] != null
          ? ChatReply.fromMap(map['chatReply'] as Map<String, dynamic>)
          : null,
      mediaUrls: map['mediaUrls'] != null
          ? List<String>.from((map['mediaUrls'] as List<String>))
          : null,
      text: map['text'] != null ? map['text'] as String : null,
      isMine: map['isMine'] as bool,
      timeAgo: DateTime.fromMillisecondsSinceEpoch(map['timeAgo'] as int),
      product: map['product'] != null
          ? Product.fromMap(map['product'] as Map<String, dynamic>)
          : null,
      isRead: map['is_read'] != null ? map['is_read'] as bool : (map['isRead'] != null ? map['isRead'] as bool : false),
      isDelivered: map['is_delivered'] != null ? map['is_delivered'] as bool : (map['isDelivered'] != null ? map['isDelivered'] as bool : false),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatModel(chatReply: $chatReply, mediaUrls: $mediaUrls, text: $text, isMine: $isMine, timeAgo: $timeAgo, product: $product, isRead: $isRead, isDelivered: $isDelivered)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.chatReply == chatReply &&
        listEquals(other.mediaUrls, mediaUrls) &&
        other.text == text &&
        other.isMine == isMine &&
        other.isRead == isRead &&
        other.isDelivered == isDelivered &&
        other.timeAgo == timeAgo &&
        other.product == product;
  }

  @override
  int get hashCode {
    return chatReply.hashCode ^
        mediaUrls.hashCode ^
        text.hashCode ^
        isMine.hashCode ^
        timeAgo.hashCode ^
        product.hashCode ^
        isRead.hashCode ^
        isDelivered.hashCode;
  }
}

class ChatReply {
  final String name;
  final String content;
  final List<String> mediaUrls;
  ChatReply({
    required this.name,
    required this.content,
    required this.mediaUrls,
  });

  ChatReply copyWith({
    String? name,
    String? content,
    List<String>? mediaUrls,
  }) {
    return ChatReply(
      name: name ?? this.name,
      content: content ?? this.content,
      mediaUrls: mediaUrls ?? this.mediaUrls,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'content': content,
      'mediaUrls': mediaUrls,
    };
  }

  factory ChatReply.fromMap(Map<String, dynamic> map) {
    return ChatReply(
      name: map['name'] as String,
      content: map['content'] as String,
      mediaUrls: List<String>.from(
        (map['mediaUrls'] as List<String>),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatReply.fromJson(String source) =>
      ChatReply.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ChatReply(name: $name, content: $content, mediaUrls: $mediaUrls)';

  @override
  bool operator ==(covariant ChatReply other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.content == content &&
        listEquals(other.mediaUrls, mediaUrls);
  }

  @override
  int get hashCode => name.hashCode ^ content.hashCode ^ mediaUrls.hashCode;
}

class Product {
  final String name;
  final List<String> mediaurls;
  final String price;
  final String place;
  Product({
    required this.name,
    required this.mediaurls,
    required this.price,
    required this.place,
  });

  Product copyWith({
    String? name,
    List<String>? mediaurls,
    String? price,
    String? place,
  }) {
    return Product(
      name: name ?? this.name,
      mediaurls: mediaurls ?? this.mediaurls,
      price: price ?? this.price,
      place: place ?? this.place,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'mediaurls': mediaurls,
      'price': price,
      'place': place,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String,
      mediaurls: List<String>.from(
        (map['mediaurls'] as List<String>),
      ),
      price: map['price'] as String,
      place: map['place'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(name: $name, mediaurls: $mediaurls, price: $price, place: $place)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        listEquals(other.mediaurls, mediaurls) &&
        other.price == price &&
        other.place == place;
  }

  @override
  int get hashCode {
    return name.hashCode ^ mediaurls.hashCode ^ price.hashCode ^ place.hashCode;
  }
}
