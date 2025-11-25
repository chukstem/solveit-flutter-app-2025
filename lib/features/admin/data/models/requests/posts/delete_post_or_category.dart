// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

///Posts, Post Comments, Comment Replies, Post Reactions or Post Categories
class DeletePostOrCategory {
  final String postElement;
  final String elementId;
  DeletePostOrCategory({
    required this.postElement,
    required this.elementId,
  });

  DeletePostOrCategory copyWith({
    String? postElement,
    String? elementId,
  }) {
    return DeletePostOrCategory(
      postElement: postElement ?? this.postElement,
      elementId: elementId ?? this.elementId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postElement': postElement,
      'element_id': elementId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'DeletePostOrCategory(postElement: $postElement, elementId: $elementId)';

  @override
  bool operator ==(covariant DeletePostOrCategory other) {
    if (identical(this, other)) return true;

    return other.postElement == postElement && other.elementId == elementId;
  }

  @override
  int get hashCode => postElement.hashCode ^ elementId.hashCode;
}
