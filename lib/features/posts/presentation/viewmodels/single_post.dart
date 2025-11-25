import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:solveit/core/injections/posts.dart';
import 'package:solveit/features/posts/data/models/responses/get_comments.dart';
import 'package:solveit/features/posts/data/models/responses/get_posts.dart';
import 'package:solveit/features/posts/data/models/responses/get_replies.dart';
import 'package:solveit/features/posts/data/models/responses/post_reactions.dart';

class PostState {
  bool isLoading;
  String? errorMessage;
  bool isLiked;
  bool isSaved;

  PostState({
    this.isLoading = true,
    this.errorMessage,
    this.isLiked = false,
    this.isSaved = false,
  });

  PostState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isLiked,
    bool? isSaved,
  }) {
    return PostState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

class SinglePostViewModel extends ChangeNotifier {
  SinglePostViewModel();

  PostState _postState = PostState();

  PostState get postState => _postState;

  SinglePostResponse? currentPost;
  String currentCategory = '';

  void setCurrentPost(SinglePostResponse post, String cat) {
    currentPost = post;
    currentCategory = cat;
    log(post.id.toString());
    notifyListeners();
  }

  List<Comment> comments = [];
  List<Reply> commentReplies = [];
  List<SinglePostReaction> reactions = [];

  List<Comment> getCommentsForPost(int postId) {
    log('Post id is $postId, comments are ${postsViewModel.allCommentsResponse?.comments.where((comment) => (comment.newsId == postId)).toList()}');
    return postsViewModel.allCommentsResponse?.comments.where((comment) => (comment.newsId == postId)).toList() ?? [];
  }

  List<Reply> getRepliesForComment(int postId, int commentId) {
    return postsViewModel.allRepliesResponse?.data.where((reply) => reply.newsId == postId && reply.newsCommentId == commentId).toList() ?? [];
  }

  List<SinglePostReaction> getReactionsForPost(int postId) {
    return postsViewModel.postReactionsResponse?.data.where((reaction) => reaction.newsId == postId).toList() ?? [];
  }

  void getCommentReplies(int commentId) {
    commentReplies = getRepliesForComment(currentPost!.id, commentId);
  }

  Future<void> loadPost() async {
    Timer(Durations.extralong1, () => notifyListeners());

    comments = getCommentsForPost(currentPost!.id);
    reactions = getReactionsForPost(currentPost!.id);

    _postState = _postState.copyWith(isLoading: false);
    Timer(const Duration(milliseconds: 1000), () => notifyListeners());
  }

  void toggleLike() {
    _postState = _postState.copyWith(isLiked: !_postState.isLiked);
    notifyListeners();
  }

  void toggleSave() {
    _postState = _postState.copyWith(isSaved: !_postState.isSaved);
    notifyListeners();
  }

  void sharePost() {
    if (currentPost == null) return;

    // Create a deep link to the post
    final deepLink = 'solveit://posts/${currentPost!.id}';

    // Create a shareable message with the deep link and post title
    final shareMessage = 'Check out this post on SolveIT: ${currentPost!.title}\n\n$deepLink';

    Share.share(shareMessage);
  }
}
