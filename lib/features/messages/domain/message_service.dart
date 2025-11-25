import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/core/network/network.dart';
import 'package:solveit/features/messages/data/api/message_api.dart';

abstract class MessageService {
  Future<Either<Failure, Map<String, dynamic>>> getConversations({Map<String, dynamic>? queryParams});
  Future<Either<Failure, Map<String, dynamic>>> findOrCreateConversation(Map<String, dynamic> data);
  Future<Either<Failure, Map<String, dynamic>>> createGroupConversation(Map<String, dynamic> data);
  Future<Either<Failure, Map<String, dynamic>>> getMessages(String conversationId, {Map<String, dynamic>? queryParams});
  Future<Either<Failure, Map<String, dynamic>>> sendMessage(FormData formData);
  Future<Either<Failure, Map<String, dynamic>>> updateMessage(String messageId, Map<String, dynamic> data);
  Future<Either<Failure, Map<String, dynamic>>> deleteMessage(String messageId);
  Future<Either<Failure, Map<String, dynamic>>> markConversationAsRead(String conversationId);
  Future<Either<Failure, Map<String, dynamic>>> markMessageAsDelivered(String messageId);
  Future<Either<Failure, Map<String, dynamic>>> markMessagesAsDelivered(List<int> messageIds);
  Future<Either<Failure, Map<String, dynamic>>> sendTypingIndicator(int conversationId, bool isTyping);
  Future<Either<Failure, Map<String, dynamic>>> addParticipants(String conversationId, List<int> userIds);
  Future<Either<Failure, Map<String, dynamic>>> removeParticipants(String conversationId, List<int> userIds);
  Future<Either<Failure, Map<String, dynamic>>> searchMessages(String query, {int? conversationId});
  Future<Either<Failure, Map<String, dynamic>>> getUnreadCount();
  Future<Either<Failure, Map<String, dynamic>>> checkContacts(List<String> phoneNumbers);
}

class MessageServiceImplementation extends MessageService {
  final MessageApi messageApi = sl<MessageApi>();

  @override
  Future<Either<Failure, Map<String, dynamic>>> getConversations({Map<String, dynamic>? queryParams}) {
    return messageApi.getConversations(queryParams: queryParams);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> findOrCreateConversation(Map<String, dynamic> data) {
    return messageApi.findOrCreateConversation(data);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createGroupConversation(Map<String, dynamic> data) {
    return messageApi.createGroupConversation(data);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMessages(String conversationId, {Map<String, dynamic>? queryParams}) {
    return messageApi.getMessages(conversationId, queryParams: queryParams);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> sendMessage(FormData formData) {
    return messageApi.sendMessage(formData);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateMessage(String messageId, Map<String, dynamic> data) {
    return messageApi.updateMessage(messageId, data);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteMessage(String messageId) {
    return messageApi.deleteMessage(messageId);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> markConversationAsRead(String conversationId) {
    return messageApi.markConversationAsRead(conversationId);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> markMessageAsDelivered(String messageId) {
    return messageApi.markMessageAsDelivered(messageId);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> markMessagesAsDelivered(List<int> messageIds) {
    return messageApi.markMessagesAsDelivered(messageIds);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> sendTypingIndicator(int conversationId, bool isTyping) {
    return messageApi.sendTypingIndicator(conversationId, isTyping);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> addParticipants(String conversationId, List<int> userIds) {
    return messageApi.addParticipants(conversationId, userIds);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> removeParticipants(String conversationId, List<int> userIds) {
    return messageApi.removeParticipants(conversationId, userIds);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> searchMessages(String query, {int? conversationId}) {
    return messageApi.searchMessages(query, conversationId: conversationId);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUnreadCount() {
    return messageApi.getUnreadCount();
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> checkContacts(List<String> phoneNumbers) {
    return messageApi.checkContacts(phoneNumbers);
  }
}


