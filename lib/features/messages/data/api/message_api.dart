import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/core/network/api/network_routes.dart';
import 'package:solveit/core/network/network.dart';

abstract class MessageApi {
  // Conversations
  Future<Either<Failure, Map<String, dynamic>>> getConversations({Map<String, dynamic>? queryParams});
  Future<Either<Failure, Map<String, dynamic>>> findOrCreateConversation(Map<String, dynamic> data);
  Future<Either<Failure, Map<String, dynamic>>> createGroupConversation(Map<String, dynamic> data);
  
  // Messages
  Future<Either<Failure, Map<String, dynamic>>> getMessages(String conversationId, {Map<String, dynamic>? queryParams});
  Future<Either<Failure, Map<String, dynamic>>> sendMessage(FormData formData);
  Future<Either<Failure, Map<String, dynamic>>> updateMessage(String messageId, Map<String, dynamic> data);
  Future<Either<Failure, Map<String, dynamic>>> deleteMessage(String messageId);
  
  // Message receipts
  Future<Either<Failure, Map<String, dynamic>>> markConversationAsRead(String conversationId);
  Future<Either<Failure, Map<String, dynamic>>> markMessageAsDelivered(String messageId);
  Future<Either<Failure, Map<String, dynamic>>> markMessagesAsDelivered(List<int> messageIds);
  
  // Typing indicator
  Future<Either<Failure, Map<String, dynamic>>> sendTypingIndicator(int conversationId, bool isTyping);
  
  // Participants
  Future<Either<Failure, Map<String, dynamic>>> addParticipants(String conversationId, List<int> userIds);
  Future<Either<Failure, Map<String, dynamic>>> removeParticipants(String conversationId, List<int> userIds);
  
  // Search and stats
  Future<Either<Failure, Map<String, dynamic>>> searchMessages(String query, {int? conversationId});
  Future<Either<Failure, Map<String, dynamic>>> getUnreadCount();
  
  // Contacts
  Future<Either<Failure, Map<String, dynamic>>> checkContacts(List<String> phoneNumbers);
}

class MessageApiImplementation extends MessageApi {
  MessageApiImplementation();

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
  }) async {
    try {
      final response = await apiClient.put(url, data: data);
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
  Future<Either<Failure, Map<String, dynamic>>> getConversations({Map<String, dynamic>? queryParams}) {
    return _getRequest(messageEndpoints.getConversations, (json) => json as Map<String, dynamic>, queryParams: queryParams);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> findOrCreateConversation(Map<String, dynamic> data) {
    return _postRequest(messageEndpoints.findOrCreateConversation, (json) => json as Map<String, dynamic>, data: data);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createGroupConversation(Map<String, dynamic> data) {
    return _postRequest(messageEndpoints.createGroupConversation, (json) => json as Map<String, dynamic>, data: data);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMessages(String conversationId, {Map<String, dynamic>? queryParams}) {
    return _getRequest(messageEndpoints.getMessages(conversationId), (json) => json as Map<String, dynamic>, queryParams: queryParams);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> sendMessage(FormData formData) {
    return _postRequest(messageEndpoints.sendMessage, (json) => json as Map<String, dynamic>, formData: formData);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateMessage(String messageId, Map<String, dynamic> data) {
    return _putRequest(messageEndpoints.updateMessage(messageId), (json) => json as Map<String, dynamic>, data: data);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteMessage(String messageId) {
    return _deleteRequest(messageEndpoints.deleteMessage(messageId), (json) => json as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> markConversationAsRead(String conversationId) {
    return _postRequest(messageEndpoints.markConversationAsRead(conversationId), (json) => json as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> markMessageAsDelivered(String messageId) {
    return _postRequest(messageEndpoints.markMessageAsDelivered(messageId), (json) => json as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> markMessagesAsDelivered(List<int> messageIds) {
    return _postRequest(messageEndpoints.markMessagesAsDelivered, (json) => json as Map<String, dynamic>, data: {'message_ids': messageIds});
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> sendTypingIndicator(int conversationId, bool isTyping) {
    return _postRequest(messageEndpoints.typingIndicator, (json) => json as Map<String, dynamic>, data: {
      'conversation_id': conversationId,
      'is_typing': isTyping,
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> addParticipants(String conversationId, List<int> userIds) {
    return _postRequest(messageEndpoints.addParticipants(conversationId), (json) => json as Map<String, dynamic>, data: {
      'participants': userIds,
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> removeParticipants(String conversationId, List<int> userIds) {
    return _deleteRequest(messageEndpoints.removeParticipants(conversationId), (json) => json as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> searchMessages(String query, {int? conversationId}) {
    final params = <String, dynamic>{'query': query};
    if (conversationId != null) {
      params['conversation_id'] = conversationId;
    }
    return _getRequest(messageEndpoints.searchMessages, (json) => json as Map<String, dynamic>, queryParams: params);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUnreadCount() {
    return _getRequest(messageEndpoints.getUnreadCount, (json) => json as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> checkContacts(List<String> phoneNumbers) {
    return _postRequest(messageEndpoints.checkContacts, (json) => json as Map<String, dynamic>, data: {
      'phone_numbers': phoneNumbers,
    });
  }
}


