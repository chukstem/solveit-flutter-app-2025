// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:solveit/core/injections/auth.dart';
import 'package:solveit/core/injections/posts.dart';
import 'package:solveit/features/posts/data/models/requests/add_comment.dart';
import 'package:solveit/features/posts/data/models/responses/responses.dart';
import 'package:solveit/features/posts/domain/models/response/message_type.dart';

class CommenState {
  final bool hasError;
  CommenState({
    required this.hasError,
  });

  CommenState copyWith({
    bool? hasError,
  }) {
    return CommenState(
      hasError: hasError ?? this.hasError,
    );
  }
}

class SinglePostCommentsViewModel extends ChangeNotifier {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final ScrollController scrollController = ScrollController();

  // Add comments list to the ViewModel
  List<Comment> _comments = [];
  List<Comment> get comments => _comments;

  CommenState _commenState = CommenState(hasError: false);
  CommenState get commenState => _commenState;

  int currentPostId = 1;

  setCurrentId(int id) {
    currentPostId = id;
    notifyListeners();
  }

  void setComments(List<Comment> newComments) {
    _comments = newComments;
  }

  MessageType _commentType = MessageType.text;
  MessageType get commentType => _commentType;
  void setCommentType(MessageType type) {
    _commentType = type;
    notifyListeners();
  }

  Future<bool> addSinglePostComments(String content,
      {bool isAudio = false, List<String> mediaUrl = const []}) async {
    if (content.trim().isEmpty) return false;

    final currentPost = singlePostViewModel.currentPost;
    if (currentPost == null) return false;

    try {
      // Create comment request
      final commentRequest = AddOrReplyComment(
        body: content,
        newsId: currentPost.id,
        schoolId: currentPost.schoolId,
        userId: userStateManager.state.token.user?.id ?? 0,
      );

      // Get current list state
      final listState = listKey.currentState;
      if (listState == null) return false;

      // Create new comment
      final newComment = Comment(
        id: currentPostId + 1,
        schoolId: currentPost.schoolId,
        newsId: currentPost.id,
        body: content,
        code: 'hhkhkhh${Random().nextInt(200)}',
        userId: userStateManager.state.token.user?.id ?? 0,
        createdAt: DateTime.now().toIso8601String(),
      );

      // Add to local list
      final newIndex = _comments.length;
      _comments.add(newComment);
      notifyListeners();

      // Animate insertion
      listState.insertItem(newIndex);

      // Scroll to new comment
      if (scrollController.hasClients) {
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }

      // Make API call
      final success = await postsViewModel.addComment(commentRequest);
      if (!success) {
        // Remove comment if API call failed
        if (newIndex < _comments.length) {
          _comments.removeAt(newIndex);
          notifyListeners();

          listState.removeItem(
            newIndex,
            (context, animation) => SizeTransition(
              sizeFactor: animation,
              child: const SizedBox(),
            ),
          );
        }
        _commenState = _commenState.copyWith(hasError: true);
        notifyListeners();
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding comment: $e');
      }
      _commenState = _commenState.copyWith(hasError: true);
      notifyListeners();
      return false;
    }
    _commenState = _commenState.copyWith(hasError: false);
    notifyListeners();
    postsViewModel.getAllPostsElements();
    return true;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
