import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/core/network/network.dart';
import 'package:solveit/features/posts/data/models/requests/add_comment.dart';
import 'package:solveit/features/posts/data/models/requests/get_posts.dart';
import 'package:solveit/features/posts/data/models/requests/get_posts_by_filter.dart';
import 'package:solveit/features/posts/data/models/requests/post_reaction.dart';
import 'package:solveit/features/posts/data/models/responses/generic_post_response.dart';
import 'package:solveit/features/posts/data/models/responses/get_categories.dart';
import 'package:solveit/features/posts/data/models/responses/get_comments.dart';
import 'package:solveit/features/posts/data/models/responses/get_post_by_id.dart';
import 'package:solveit/features/posts/data/models/responses/get_posts.dart';
import 'package:solveit/features/posts/data/models/responses/get_replies.dart';
import 'package:solveit/features/posts/data/models/responses/get_saved_posts.dart';
import 'package:solveit/features/posts/data/models/responses/post_reactions.dart';

abstract class PostsApi {
  Future<Either<Failure, AllCategoriesResponse>> getCategory(GetPostsElement query);
  Future<Either<Failure, AllPostsResponse>> getPosts(GetPostsElement query);
  Future<Either<Failure, AllCommentsResponse>> getComments(GetPostsElement query);
  Future<Either<Failure, AllRepliesResponse>> getReplies(GetPostsElement query);
  Future<Either<Failure, AllPostReactionsResponse>> getReactions(GetPostsElement query);

  Future<Either<Failure, GenericPostResponse>> addComment(AddOrReplyComment req);
  Future<Either<Failure, GenericPostResponse>> replyComment(AddOrReplyComment req);
  Future<Either<Failure, GenericPostResponse>> likeCommentOrReply(PostReaction req);
  Future<Either<Failure, GenericPostResponse>> likePost(PostReaction req);
  Future<Either<Failure, GenericPostResponse>> unlikePost(PostReaction req);

  /// these are not used yet
  Future<Either<Failure, GenericPostResponse>> savePost(String id);
  Future<Either<Failure, GetAllPostsResponseById>> getPostsById(String id);
  Future<Either<Failure, AllSavedPostsResponse>> getSavePosts();
  Future<Either<Failure, AllPostsResponse>> filterPostByTime(GetFilteredPostsQuery query);
  Future<Either<Failure, AllPostsResponse>> filterPostByCategory(GetFilteredPostsQuery query);
  Future<Either<Failure, GenericPostResponse>> deleteCommentOrReply(String id);
}

class PostsApiImplementation extends PostsApi {
  PostsApiImplementation();

  /// **Generic helper for making API GET requests**
  Future<Either<ApiFailure, T>> _getRequest<T>(String url, T Function(Map<String, dynamic>) fromJson, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await apiClient.get(url, queryParameters: queryParams);
      return right(fromJson(response.data));
    } on ApiException catch (e, s) {
      log("API Exception in GET [$url]: $e\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in GET [$url]: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  /// **Generic helper for making API POST requests**
  Future<Either<ApiFailure, T>> _postRequest<T>(String url, T Function(Map<String, dynamic>) fromJson, {Map<String, dynamic>? data}) async {
    try {
      final response = await apiClient.post(url, data: data);
      return right(fromJson(response.data));
    } on ApiException catch (e, s) {
      log("API Exception in POST [$url]: $e\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in POST [$url]: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  @override
  Future<Either<ApiFailure, GenericPostResponse>> addComment(req) async {
    // Backend expects: POST /posts/createPostComment/{postId}
    final postId = req.toMap()['post_id']?.toString() ?? '';
    return _postRequest(postEndpoints.addComment(postId), GenericPostResponse.fromMap, data: req.toMap());
  }

  @override
  Future<Either<ApiFailure, GenericPostResponse>> deleteCommentOrReply(String id) async {
    // Backend expects: DELETE /posts/deleteComment/{commentId}
    try {
      final response = await apiClient.delete(postEndpoints.deleteComment(id));
      return right(GenericPostResponse.fromMap(response.data));
    } on ApiException catch (e, s) {
      log("API Exception in DELETE [$id]: $e\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in DELETE [$id]: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  @override
  Future<Either<ApiFailure, AllPostsResponse>> filterPostByCategory(query) async {
    // Use searchPosts endpoint with category filter
    final queryParams = query.toQueryParams();
    queryParams['category_id'] = queryParams['category_id'] ?? queryParams['category'];
    return _getRequest(postEndpoints.searchPosts, AllPostsResponse.fromMap, queryParams: queryParams);
  }

  @override
  Future<Either<ApiFailure, AllPostsResponse>> filterPostByTime(query) async {
    // Use searchPosts endpoint with date filter
    return _getRequest(postEndpoints.searchPosts, AllPostsResponse.fromMap, queryParams: query.toQueryParams());
  }

  @override
  Future<Either<ApiFailure, AllCategoriesResponse>> getCategory(query) async {
    // Backend expects: GET /posts/getCategories
    return _getRequest(postEndpoints.getCategories, AllCategoriesResponse.fromMap);
  }

  @override
  Future<Either<ApiFailure, AllCommentsResponse>> getComments(query) async {
    // Backend expects: GET /posts/getComments/{postId}
    final postId = query.toMap()['post_id']?.toString() ?? '';
    return _getRequest(postEndpoints.getComments(postId), AllCommentsResponse.fromMap);
  }

  @override
  Future<Either<ApiFailure, AllPostsResponse>> getPosts(query) async {
    // Backend expects: GET /posts/getPostElements with query params
    return _getRequest(postEndpoints.getPosts, AllPostsResponse.fromMap, queryParams: query.toQueryParams());
  }

  @override
  Future<Either<ApiFailure, GetAllPostsResponseById>> getPostsById(String id) async {
    // Backend expects: GET /posts/getPostElements/{id}
    return _getRequest(postEndpoints.getPost(id), GetAllPostsResponseById.fromMap);
  }

  @override
  Future<Either<ApiFailure, AllRepliesResponse>> getReplies(query) async {
    // Backend expects: GET /posts/getCommentReplies/{commentId}
    final commentId = query.toMap()['comment_id']?.toString() ?? '';
    return _getRequest(postEndpoints.getCommentReplies(commentId), AllRepliesResponse.fromMap);
  }

  @override
  Future<Either<ApiFailure, AllSavedPostsResponse>> getSavePosts() async {
    // Backend expects: GET /posts/getSavedPosts
    return _getRequest(postEndpoints.getSavedPosts, AllSavedPostsResponse.fromMap);
  }

  @override
  Future<Either<ApiFailure, GenericPostResponse>> likeCommentOrReply(req) async {
    // Backend expects: POST /posts/likeComment/{commentId}
    final commentId = req.toMap()['comment_id']?.toString() ?? '';
    if (commentId.isEmpty) {
      return left(ApiFailure(message: "Comment ID is required", exception: Exception("Missing comment_id")));
    }
    try {
      final response = await apiClient.post(postEndpoints.likeComment(commentId));
      return right(GenericPostResponse.fromMap(response.data));
    } on ApiException catch (e, s) {
      log("API Exception in POST likeComment: $e\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in POST likeComment: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  @override
  Future<Either<ApiFailure, GenericPostResponse>> likePost(req) async {
    // Backend expects: POST /posts/createPostReaction/{postId}
    final postId = req.toMap()['post_id']?.toString() ?? '';
    final reactionType = req.toMap()['type']?.toString() ?? 'like';
    try {
      final response = await apiClient.post(
        postEndpoints.createPostReaction(postId),
        data: {'type': reactionType},
      );
      return right(GenericPostResponse.fromMap(response.data));
    } on ApiException catch (e, s) {
      log("API Exception in POST likePost: $e\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in POST likePost: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  @override
  Future<Either<ApiFailure, GenericPostResponse>> replyComment(req) async {
    // Replies are comments with parent_id, use addComment endpoint
    final postId = req.toMap()['post_id']?.toString() ?? '';
    return _postRequest(postEndpoints.addComment(postId), GenericPostResponse.fromMap, data: req.toMap());
  }

  @override
  Future<Either<ApiFailure, GenericPostResponse>> savePost(String id) async {
    // Backend expects: POST /posts/savePost/{postId}
    try {
      final response = await apiClient.post(postEndpoints.savePost(id));
      return right(GenericPostResponse.fromMap(response.data));
    } on ApiException catch (e, s) {
      log("API Exception in POST savePost: $e\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in POST savePost: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  @override
  Future<Either<ApiFailure, GenericPostResponse>> unlikePost(req) async {
    // Backend expects: DELETE /posts/deletePostReaction/{postId}
    final postId = req.toMap()['post_id']?.toString() ?? '';
    try {
      final response = await apiClient.delete(postEndpoints.deletePostReaction(postId));
      return right(GenericPostResponse.fromMap(response.data));
    } on ApiException catch (e, s) {
      log("API Exception in DELETE unlikePost: $e\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in DELETE unlikePost: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  @override
  Future<Either<Failure, AllPostReactionsResponse>> getReactions(GetPostsElement query) {
    // Backend expects: GET /posts/getReactions/{postId}
    final postId = query.toMap()['post_id']?.toString() ?? '';
    return _getRequest(postEndpoints.getReactions(postId), AllPostReactionsResponse.fromMap);
  }
}
