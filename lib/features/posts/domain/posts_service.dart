import 'package:dartz/dartz.dart';
import 'package:solveit/core/injections/posts.dart';
import 'package:solveit/core/network/network.dart';
import 'package:solveit/features/posts/data/models/requests/add_comment.dart';
import 'package:solveit/features/posts/data/models/requests/get_posts.dart';
import 'package:solveit/features/posts/data/models/requests/get_posts_by_filter.dart';
import 'package:solveit/features/posts/data/models/requests/post_reaction.dart';
import 'package:solveit/features/posts/data/models/responses/post_reactions.dart';
import 'package:solveit/features/posts/data/models/responses/responses.dart';

abstract class PostsService {
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

class PostsServiceImplementation extends PostsService {
  @override
  Future<Either<Failure, GenericPostResponse>> addComment(req) {
    return postsApi.addComment(req);
  }

  @override
  Future<Either<Failure, GenericPostResponse>> deleteCommentOrReply(id) {
    return postsApi.deleteCommentOrReply(id);
  }

  @override
  Future<Either<Failure, AllPostsResponse>> filterPostByCategory(query) {
    return postsApi.filterPostByCategory(query);
  }

  @override
  Future<Either<Failure, AllPostsResponse>> filterPostByTime(query) {
    return postsApi.filterPostByTime(query);
  }

  @override
  Future<Either<Failure, AllCategoriesResponse>> getCategory(query) {
    return postsApi.getCategory(query);
  }

  @override
  Future<Either<Failure, AllCommentsResponse>> getComments(query) {
    return postsApi.getComments(query);
  }

  @override
  Future<Either<Failure, AllPostsResponse>> getPosts(query) {
    return postsApi.getPosts(query);
  }

  @override
  Future<Either<Failure, GetAllPostsResponseById>> getPostsById(id) {
    return postsApi.getPostsById(id);
  }

  @override
  Future<Either<Failure, AllRepliesResponse>> getReplies(query) {
    return postsApi.getReplies(query);
  }

  @override
  Future<Either<Failure, AllSavedPostsResponse>> getSavePosts() {
    return postsApi.getSavePosts();
  }

  @override
  Future<Either<Failure, GenericPostResponse>> likeCommentOrReply(req) {
    return postsApi.likeCommentOrReply(req);
  }

  @override
  Future<Either<Failure, GenericPostResponse>> likePost(req) {
    return postsApi.likePost(req);
  }

  @override
  Future<Either<Failure, GenericPostResponse>> replyComment(req) {
    return postsApi.replyComment(req);
  }

  @override
  Future<Either<Failure, GenericPostResponse>> savePost(id) {
    return postsApi.savePost(id);
  }

  @override
  Future<Either<Failure, GenericPostResponse>> unlikePost(req) {
    return postsApi.unlikePost(req);
  }

  @override
  Future<Either<Failure, AllPostReactionsResponse>> getReactions(GetPostsElement query) {
    return postsApi.getReactions(query);
  }
}
