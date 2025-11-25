import 'dart:convert';

class GetPostsElement {
  final String postElement;
  final String? searchCriteria;
  final String? searchValue;
  GetPostsElement({
    required this.postElement,
    this.searchCriteria,
    this.searchValue,
  });

  GetPostsElement copyWith({
    String? postElement,
    String? searchCriteria,
    String? searchValue,
  }) {
    return GetPostsElement(
      postElement: postElement ?? this.postElement,
      searchCriteria: searchCriteria ?? this.searchCriteria,
      searchValue: searchValue ?? this.searchValue,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postElement': postElement,
      if (searchCriteria != null) 'searchCriteria': searchCriteria,
      if (searchValue != null) 'searchValue': searchValue,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'GetPostsElement(postElement: $postElement, searchCriteria: $searchCriteria, searchValue: $searchValue)';

  @override
  bool operator ==(covariant GetPostsElement other) {
    if (identical(this, other)) return true;

    return other.postElement == postElement && other.searchCriteria == searchCriteria && other.searchValue == searchValue;
  }

  @override
  int get hashCode => postElement.hashCode ^ searchCriteria.hashCode ^ searchValue.hashCode;
}
