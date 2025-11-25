import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:solveit/core/injections/posts.dart';
import 'package:solveit/features/posts/data/models/requests/add_comment.dart';
import 'package:solveit/features/posts/data/models/requests/get_posts.dart';
import 'package:solveit/features/posts/data/models/requests/get_posts_by_filter.dart';
import 'package:solveit/features/posts/data/models/requests/post_reaction.dart';
import 'package:solveit/features/posts/data/models/responses/get_categories.dart';
import 'package:solveit/features/posts/data/models/responses/get_comments.dart';
import 'package:solveit/features/posts/data/models/responses/get_posts.dart';
import 'package:solveit/features/posts/data/models/responses/get_replies.dart';
import 'package:solveit/features/posts/data/models/responses/post_reactions.dart';

class PostsState {
  final bool isLoading;
  final String errorMessage;
  final AddOrReplyComment? addCommentRequest;
  final AllCategoriesResponse? allCategoriesResponse;
  final AllPostsResponse? allPostsResponse;
  final AllCommentsResponse? allCommentsResponse;
  final AllPostReactionsResponse? postReactionsResponse;
  final AllRepliesResponse? allRepliesResponse;

  const PostsState({
    this.isLoading = false,
    this.errorMessage = '',
    this.addCommentRequest,
    this.allCategoriesResponse,
    this.allPostsResponse,
    this.allCommentsResponse,
    this.postReactionsResponse,
    this.allRepliesResponse,
  });

  PostsState copyWith({
    bool? isLoading,
    String? errorMessage,
    AddOrReplyComment? addCommentRequest,
    AllCategoriesResponse? allCategoriesResponse,
    AllPostsResponse? allPostsResponse,
    AllCommentsResponse? allCommentsResponse,
    AllPostReactionsResponse? postReactionsResponse,
    AllRepliesResponse? allRepliesResponse,
  }) {
    return PostsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      addCommentRequest: addCommentRequest ?? this.addCommentRequest,
      allCategoriesResponse: allCategoriesResponse ?? this.allCategoriesResponse,
      allPostsResponse: allPostsResponse ?? this.allPostsResponse,
      allCommentsResponse: allCommentsResponse ?? this.allCommentsResponse,
      postReactionsResponse: postReactionsResponse ?? this.postReactionsResponse,
      allRepliesResponse: allRepliesResponse ?? this.allRepliesResponse,
    );
  }

  static const empty = PostsState();
}

class PostsViewmodel extends ChangeNotifier {
  PostsState _state = PostsState.empty;
  PostsState get state => _state;

  PostsViewmodel();

  void _setState(PostsState state) {
    _state = state;
    notifyListeners();
  }

  // Delayed update for smoother UI updates
  void _setStateWithDelay(PostsState state) {
    _state = state;
    Timer(const Duration(milliseconds: 20), () {
      notifyListeners();
    });
  }

  // Getters for backward compatibility
  bool get isLoading => _state.isLoading;
  set isLoading(bool value) {
    _setStateWithDelay(_state.copyWith(isLoading: value));
  }

  String get errorMessage => _state.errorMessage;
  AddOrReplyComment? get addCommentRequest => _state.addCommentRequest;
  AllCategoriesResponse? get allCategoriesResponse => _state.allCategoriesResponse;
  AllPostsResponse? get allPostsResponse => _state.allPostsResponse;
  AllCommentsResponse? get allCommentsResponse => _state.allCommentsResponse;
  AllPostReactionsResponse? get postReactionsResponse => _state.postReactionsResponse;
  AllRepliesResponse? get allRepliesResponse => _state.allRepliesResponse;

  void getAllPostsElements() async {
    getCategory();
    getPosts();
    getComments();
    getReplies();
    getReations();
  }

  Future<bool> addComment(AddOrReplyComment request) async {
    _setState(_state.copyWith(isLoading: true));
    final result = await postsService.addComment(request);
    final success = result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.toString(),
        ));
        return false;
      },
      (success) {
        _setState(_state.copyWith(isLoading: false));
        return true;
      },
    );
    return success;
  }

  Future<bool> deleteCommentOrReply(String id) async {
    _setState(_state.copyWith(isLoading: true));
    final result = await postsService.deleteCommentOrReply(id);
    final success = result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.toString(),
        ));
        return false;
      },
      (success) {
        _setState(_state.copyWith(isLoading: false));
        return true;
      },
    );
    return success;
  }

  Future<bool> filterPostByCategory(GetFilteredPostsQuery query) async {
    _setState(_state.copyWith(isLoading: true));
    final result = await postsService.filterPostByCategory(query);
    final success = result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.toString(),
        ));
        return false;
      },
      (success) {
        _setState(_state.copyWith(isLoading: false));
        return true;
      },
    );
    return success;
  }

  Future<bool> filterPostByTime(GetFilteredPostsQuery query) async {
    _setState(_state.copyWith(isLoading: true));
    final result = await postsService.filterPostByTime(query);
    final success = result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.toString(),
        ));
        return false;
      },
      (success) {
        _setState(_state.copyWith(isLoading: false));
        return true;
      },
    );
    return success;
  }

  Future<bool> getCategory({GetPostsElement? query}) async {
    _setState(_state.copyWith(isLoading: true));
    final result = await postsService.getCategory(
      query ?? GetPostsElement(postElement: 'Post Categories'),
    );
    final success = result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.toString(),
        ));
        return false;
      },
      (response) {
        _setState(_state.copyWith(
          isLoading: false,
          allCategoriesResponse: response,
        ));
        return true;
      },
    );
    return success;
  }

  Future<bool> getComments({GetPostsElement? query}) async {
    _setState(_state.copyWith(isLoading: true));
    final result = await postsService.getComments(
      query ?? GetPostsElement(postElement: 'Post Comments'),
    );
    final success = result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.toString(),
        ));
        return false;
      },
      (response) {
        _setState(_state.copyWith(
          isLoading: false,
          allCommentsResponse: response,
        ));
        return true;
      },
    );
    return success;
  }

  Future<bool> getPosts({GetPostsElement? query}) async {
    _setState(_state.copyWith(isLoading: true));
    final result = await postsService.getPosts(
      query ?? GetPostsElement(postElement: 'Posts'),
    );
    final success = result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.toString(),
        ));
        return false;
      },
      (response) {
        _setState(_state.copyWith(
          isLoading: false,
          allPostsResponse: response,
        ));
        return true;
      },
    );
    return success;
  }

  Future<bool> getPostsById(String id) async {
    _setState(_state.copyWith(isLoading: true));
    final result = await postsService.getPostsById(id);
    final success = result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.toString(),
        ));
        return false;
      },
      (success) {
        _setState(_state.copyWith(isLoading: false));
        return true;
      },
    );
    return success;
  }

  Future<bool> getReplies({GetPostsElement? query}) async {
    _setState(_state.copyWith(isLoading: true));
    final result = await postsService.getReplies(
      query ?? GetPostsElement(postElement: 'Comment Replies'),
    );
    final success = result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.toString(),
        ));
        return false;
      },
      (response) {
        _setState(_state.copyWith(
          isLoading: false,
          allRepliesResponse: response,
        ));
        return true;
      },
    );
    return success;
  }

  Future<bool> getReations({GetPostsElement? query}) async {
    _setState(_state.copyWith(isLoading: true));
    final result = await postsService.getReactions(
      query ?? GetPostsElement(postElement: 'Post Reactions'),
    );
    final success = result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.toString(),
        ));
        return false;
      },
      (response) {
        _setState(_state.copyWith(
          isLoading: false,
          postReactionsResponse: response,
        ));
        return true;
      },
    );
    return success;
  }

  Future<bool> getSavePosts() async {
    _setState(_state.copyWith(isLoading: true));
    final result = await postsService.getSavePosts();
    final success = result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.toString(),
        ));
        return false;
      },
      (success) {
        _setState(_state.copyWith(isLoading: false));
        return true;
      },
    );
    return success;
  }

  Future<bool> likeCommentOrReply(PostReaction req) async {
    _setState(_state.copyWith(isLoading: true));
    final result = await postsService.likeCommentOrReply(req);
    final success = result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.toString(),
        ));
        return false;
      },
      (success) {
        _setState(_state.copyWith(isLoading: false));
        return true;
      },
    );
    return success;
  }

  Future<bool> likePost(PostReaction req) async {
    _setState(_state.copyWith(isLoading: true));
    final result = await postsService.likePost(req);
    final success = result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.toString(),
        ));
        return false;
      },
      (success) {
        _setState(_state.copyWith(isLoading: false));
        return true;
      },
    );
    return success;
  }

  Future<bool> replyComment(AddOrReplyComment req) async {
    _setState(_state.copyWith(isLoading: true));
    final result = await postsService.replyComment(req);
    final success = result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.toString(),
        ));
        return false;
      },
      (success) {
        _setState(_state.copyWith(isLoading: false));
        return true;
      },
    );
    return success;
  }

  Future<bool> savePost(String id) async {
    _setState(_state.copyWith(isLoading: true));
    final result = await postsService.savePost(id);
    final success = result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.toString(),
        ));
        return false;
      },
      (success) {
        _setState(_state.copyWith(isLoading: false));
        return true;
      },
    );
    return success;
  }

  Future<bool> unlikePost(PostReaction req) async {
    _setState(_state.copyWith(isLoading: true));
    final result = await postsService.unlikePost(req);
    final success = result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.toString(),
        ));
        return false;
      },
      (success) {
        _setState(_state.copyWith(isLoading: false));
        return true;
      },
    );
    return success;
  }
}
