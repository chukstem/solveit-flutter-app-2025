import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/core/network/api/network_routes.dart';
import 'package:solveit/core/network/network.dart';

abstract class ForumApi {
  // Forum CRUD
  Future<Either<Failure, Map<String, dynamic>>> getForums({Map<String, dynamic>? queryParams});
  Future<Either<Failure, Map<String, dynamic>>> searchForums(String query, {Map<String, dynamic>? queryParams});
  Future<Either<Failure, Map<String, dynamic>>> getForum(String id);
  Future<Either<Failure, Map<String, dynamic>>> createForum(FormData formData);
  Future<Either<Failure, Map<String, dynamic>>> updateForum(String id, FormData formData);
  Future<Either<Failure, Map<String, dynamic>>> deleteForum(String id);
  
  // Forum membership
  Future<Either<Failure, Map<String, dynamic>>> joinForum(String id);
  Future<Either<Failure, Map<String, dynamic>>> leaveForum(String id);
  Future<Either<Failure, Map<String, dynamic>>> toggleMute(String id);
  Future<Either<Failure, Map<String, dynamic>>> markAsRead(String id);
  
  // Forum members
  Future<Either<Failure, Map<String, dynamic>>> getMembers(String id, {Map<String, dynamic>? queryParams});
  Future<Either<Failure, Map<String, dynamic>>> removeMember(String id, int userId);
  Future<Either<Failure, Map<String, dynamic>>> makeModerator(String id, int userId);
  Future<Either<Failure, Map<String, dynamic>>> removeModerator(String id, int userId);
  Future<Either<Failure, Map<String, dynamic>>> makeAdmin(String id, int userId);
  Future<Either<Failure, Map<String, dynamic>>> removeAdmin(String id, int userId);
  
  // Forum messages
  Future<Either<Failure, Map<String, dynamic>>> getMessages(String id, {Map<String, dynamic>? queryParams});
  Future<Either<Failure, Map<String, dynamic>>> sendMessage(String id, FormData formData);
  Future<Either<Failure, Map<String, dynamic>>> updateMessage(String messageId, Map<String, dynamic> data);
  Future<Either<Failure, Map<String, dynamic>>> deleteMessage(String messageId);
  
  // Forum media
  Future<Either<Failure, Map<String, dynamic>>> getMedia(String id, {Map<String, dynamic>? queryParams});
  
  // Forum stats
  Future<Either<Failure, Map<String, dynamic>>> getUnreadCount();
}

class ForumApiImplementation extends ForumApi {
  ForumApiImplementation();

  /// Generic helper for GET requests
  Future<Either<ApiFailure, T>> _getRequest<T>(
    String url,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic>? queryParams,
  }) async {
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

  /// Generic helper for POST requests
  Future<Either<ApiFailure, T>> _postRequest<T>(
    String url,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic>? data,
    FormData? formData,
  }) async {
    try {
      final response = await apiClient.post(url, data: data, formData: formData);
      return right(fromJson(response.data));
    } on ApiException catch (e, s) {
      log("API Exception in POST [$url]: $e\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in POST [$url]: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  /// Generic helper for PUT requests
  Future<Either<ApiFailure, T>> _putRequest<T>(
    String url,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic>? data,
    FormData? formData,
  }) async {
    try {
      // PUT requests need to use formData if provided, otherwise use data
      final response = formData != null 
          ? await apiClient.post(url, formData: formData) // Backend PUT for file uploads might need POST
          : await apiClient.put(url, data: data);
      return right(fromJson(response.data));
    } on ApiException catch (e, s) {
      log("API Exception in PUT [$url]: $e\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in PUT [$url]: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  /// Generic helper for DELETE requests
  Future<Either<ApiFailure, T>> _deleteRequest<T>(
    String url,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await apiClient.delete(url);
      return right(fromJson(response.data));
    } on ApiException catch (e, s) {
      log("API Exception in DELETE [$url]: $e\n$s");
      return left(ApiFailure(message: e.message, exception: e));
    } catch (e, s) {
      log("Unexpected error in DELETE [$url]: $e\n$s");
      return left(ApiFailure(message: e.toString(), exception: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getForums({Map<String, dynamic>? queryParams}) {
    return _getRequest(forumEndpoints.getForums, (json) => json as Map<String, dynamic>, queryParams: queryParams);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> searchForums(String query, {Map<String, dynamic>? queryParams}) {
    final params = queryParams ?? {};
    params['query'] = query;
    return _getRequest(forumEndpoints.searchForums, (json) => json as Map<String, dynamic>, queryParams: params);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getForum(String id) {
    return _getRequest(forumEndpoints.getForum(id), (json) => json as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createForum(FormData formData) {
    return _postRequest(forumEndpoints.createForum, (json) => json as Map<String, dynamic>, formData: formData);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateForum(String id, FormData formData) {
    return _putRequest(forumEndpoints.updateForum(id), (json) => json as Map<String, dynamic>, formData: formData);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteForum(String id) {
    return _deleteRequest(forumEndpoints.deleteForum(id), (json) => json as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> joinForum(String id) {
    return _postRequest(forumEndpoints.joinForum(id), (json) => json as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> leaveForum(String id) {
    return _postRequest(forumEndpoints.leaveForum(id), (json) => json as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> toggleMute(String id) {
    return _postRequest(forumEndpoints.toggleMute(id), (json) => json as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> markAsRead(String id) {
    return _postRequest(forumEndpoints.markAsRead(id), (json) => json as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMembers(String id, {Map<String, dynamic>? queryParams}) {
    return _getRequest(forumEndpoints.getMembers(id), (json) => json as Map<String, dynamic>, queryParams: queryParams);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> removeMember(String id, int userId) {
    return _postRequest(forumEndpoints.removeMember(id), (json) => json as Map<String, dynamic>, data: {'user_id': userId});
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> makeModerator(String id, int userId) {
    return _postRequest(forumEndpoints.makeModerator(id), (json) => json as Map<String, dynamic>, data: {'user_id': userId});
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> removeModerator(String id, int userId) {
    return _postRequest(forumEndpoints.removeModerator(id), (json) => json as Map<String, dynamic>, data: {'user_id': userId});
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> makeAdmin(String id, int userId) {
    return _postRequest(forumEndpoints.makeAdmin(id), (json) => json as Map<String, dynamic>, data: {'user_id': userId});
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> removeAdmin(String id, int userId) {
    return _postRequest(forumEndpoints.removeAdmin(id), (json) => json as Map<String, dynamic>, data: {'user_id': userId});
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMessages(String id, {Map<String, dynamic>? queryParams}) {
    return _getRequest(forumEndpoints.getMessages(id), (json) => json as Map<String, dynamic>, queryParams: queryParams);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> sendMessage(String id, FormData formData) {
    return _postRequest(forumEndpoints.sendMessage(id), (json) => json as Map<String, dynamic>, formData: formData);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateMessage(String messageId, Map<String, dynamic> data) {
    return _putRequest(forumEndpoints.updateMessage(messageId), (json) => json as Map<String, dynamic>, data: data);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteMessage(String messageId) {
    return _deleteRequest(forumEndpoints.deleteMessage(messageId), (json) => json as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMedia(String id, {Map<String, dynamic>? queryParams}) {
    return _getRequest(forumEndpoints.getMedia(id), (json) => json as Map<String, dynamic>, queryParams: queryParams);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUnreadCount() {
    return _getRequest(forumEndpoints.getUnreadCount, (json) => json as Map<String, dynamic>);
  }
}

