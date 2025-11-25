import 'package:dartz/dartz.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/core/network/network.dart';
import 'package:solveit/features/forum/data/api/forum_api.dart';

abstract class ForumService {
  Future<Either<Failure, Map<String, dynamic>>> getForums({Map<String, dynamic>? queryParams});
  Future<Either<Failure, Map<String, dynamic>>> searchForums(String query, {Map<String, dynamic>? queryParams});
  Future<Either<Failure, Map<String, dynamic>>> getForum(String id);
  Future<Either<Failure, Map<String, dynamic>>> createForum(FormData formData);
  Future<Either<Failure, Map<String, dynamic>>> updateForum(String id, FormData formData);
  Future<Either<Failure, Map<String, dynamic>>> deleteForum(String id);
  Future<Either<Failure, Map<String, dynamic>>> joinForum(String id);
  Future<Either<Failure, Map<String, dynamic>>> leaveForum(String id);
  Future<Either<Failure, Map<String, dynamic>>> toggleMute(String id);
  Future<Either<Failure, Map<String, dynamic>>> markAsRead(String id);
  Future<Either<Failure, Map<String, dynamic>>> getMembers(String id, {Map<String, dynamic>? queryParams});
  Future<Either<Failure, Map<String, dynamic>>> removeMember(String id, int userId);
  Future<Either<Failure, Map<String, dynamic>>> makeModerator(String id, int userId);
  Future<Either<Failure, Map<String, dynamic>>> removeModerator(String id, int userId);
  Future<Either<Failure, Map<String, dynamic>>> makeAdmin(String id, int userId);
  Future<Either<Failure, Map<String, dynamic>>> removeAdmin(String id, int userId);
  Future<Either<Failure, Map<String, dynamic>>> getMessages(String id, {Map<String, dynamic>? queryParams});
  Future<Either<Failure, Map<String, dynamic>>> sendMessage(String id, FormData formData);
  Future<Either<Failure, Map<String, dynamic>>> updateMessage(String messageId, Map<String, dynamic> data);
  Future<Either<Failure, Map<String, dynamic>>> deleteMessage(String messageId);
  Future<Either<Failure, Map<String, dynamic>>> getMedia(String id, {Map<String, dynamic>? queryParams});
  Future<Either<Failure, Map<String, dynamic>>> getUnreadCount();
}

class ForumServiceImplementation extends ForumService {
  final ForumApi forumApi = sl<ForumApi>();

  @override
  Future<Either<Failure, Map<String, dynamic>>> getForums({Map<String, dynamic>? queryParams}) {
    return forumApi.getForums(queryParams: queryParams);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> searchForums(String query, {Map<String, dynamic>? queryParams}) {
    return forumApi.searchForums(query, queryParams: queryParams);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getForum(String id) {
    return forumApi.getForum(id);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createForum(FormData formData) {
    return forumApi.createForum(formData);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateForum(String id, FormData formData) {
    return forumApi.updateForum(id, formData);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteForum(String id) {
    return forumApi.deleteForum(id);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> joinForum(String id) {
    return forumApi.joinForum(id);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> leaveForum(String id) {
    return forumApi.leaveForum(id);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> toggleMute(String id) {
    return forumApi.toggleMute(id);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> markAsRead(String id) {
    return forumApi.markAsRead(id);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMembers(String id, {Map<String, dynamic>? queryParams}) {
    return forumApi.getMembers(id, queryParams: queryParams);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMessages(String id, {Map<String, dynamic>? queryParams}) {
    return forumApi.getMessages(id, queryParams: queryParams);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> sendMessage(String id, FormData formData) {
    return forumApi.sendMessage(id, formData);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUnreadCount() {
    return forumApi.getUnreadCount();
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> removeMember(String id, int userId) {
    return forumApi.removeMember(id, userId);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> makeModerator(String id, int userId) {
    return forumApi.makeModerator(id, userId);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> removeModerator(String id, int userId) {
    return forumApi.removeModerator(id, userId);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> makeAdmin(String id, int userId) {
    return forumApi.makeAdmin(id, userId);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> removeAdmin(String id, int userId) {
    return forumApi.removeAdmin(id, userId);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateMessage(String messageId, Map<String, dynamic> data) {
    return forumApi.updateMessage(messageId, data);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteMessage(String messageId) {
    return forumApi.deleteMessage(messageId);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMedia(String id, {Map<String, dynamic>? queryParams}) {
    return forumApi.getMedia(id, queryParams: queryParams);
  }
}

