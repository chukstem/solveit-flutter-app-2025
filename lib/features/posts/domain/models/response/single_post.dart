class SinglePostModel {
  final String title;
  final String content;
  final String imageUrl;
  final String category;
  final String timestamp;
  final String comments;
  final bool isLiked;
  final bool isSaved;
  final bool isLoading;
  final String? errorMessage;

  const SinglePostModel({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.category,
    required this.timestamp,
    required this.comments,
    this.isLiked = false,
    this.isSaved = false,
    this.isLoading = false,
    this.errorMessage,
  });

  SinglePostModel copyWith({
    String? title,
    String? content,
    String? imageUrl,
    String? category,
    String? timestamp,
    String? comments,
    bool? isLiked,
    bool? isSaved,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SinglePostModel(
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
