import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/state_provider.dart';
import 'package:solveit/features/messages/domain/message_service.dart';
import 'package:solveit/features/messages/domain/models/responses/chat.dart';
import 'package:solveit/features/messages/presentation/viewmodel/chat_viewmodel.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/utils/strings.dart';

class MessagesState {
  final bool isLoading;
  final bool isSearching;
  final String searchText;
  final String? error;
  final List<SingleChatModel> messages;
  final List<SingleChatModel> searchedMessages;

  const MessagesState({
    this.isLoading = false,
    this.isSearching = false,
    this.searchText = '',
    this.error,
    this.messages = const [],
    this.searchedMessages = const [],
  });

  MessagesState copyWith({
    bool? isLoading,
    bool? isSearching,
    String? searchText,
    String? error,
    List<SingleChatModel>? messages,
    List<SingleChatModel>? searchedMessages,
  }) {
    return MessagesState(
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      searchText: searchText ?? this.searchText,
      error: error ?? this.error,
      messages: messages ?? this.messages,
      searchedMessages: searchedMessages ?? this.searchedMessages,
    );
  }

  static const empty = MessagesState();
}

class MessagesViewModel extends ChangeNotifier {
  MessagesState _state = MessagesState.empty;
  MessagesState get state => _state;
  
  final MessageService _messageService = sl<MessageService>();

  MessagesViewModel() {
    loadSingleChatModels();
  }

  void _setState(MessagesState state) {
    _state = state;
    notifyListeners();
  }

  // Getters for backward compatibility
  bool get isLoading => _state.isLoading;
  bool get isSearching => _state.isSearching;
  String get searchText => _state.searchText;
  String? get singleChatModelsError => _state.error;
  List<SingleChatModel> get singleChatModels => _state.messages;
  List<SingleChatModel> get searchedMessages => _state.searchedMessages;

  // Setter for backward compatibility
  set singleChatModels(List<SingleChatModel> value) {
    _setState(_state.copyWith(messages: value));
  }

  /// Get current user ID from auth state
  int? _getCurrentUserId() {
    try {
      final userManager = sl<UserStateManager>();
      return userManager.state.currentUser?.id;
    } catch (e) {
      log('Error getting current user ID: $e');
      return null;
    }
  }

  Future<void> loadSingleChatModels() async {
    _setState(_state.copyWith(isLoading: true, error: null));

    final result = await _messageService.getConversations();

    result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          error: failure.message ?? 'Failed to load conversations',
        ));
      },
      (response) {
        try {
          // Backend returns: { status, message, data: { data: [...], current_page, ... } }
          final conversationsData = response['data'] as Map<String, dynamic>?;
          final conversationsList = conversationsData?['data'] as List<dynamic>? ?? [];
          
          final conversations = conversationsList.map((convJson) {
            final conv = convJson as Map<String, dynamic>;
            
            // Get participants - find the other participant (not current user)
            final participants = conv['participants'] as List<dynamic>? ?? [];
            
            // Get current user ID from auth state
            final currentUserId = _getCurrentUserId();
            
            Map<String, dynamic>? otherParticipant;
            Map<String, dynamic>? participantUser;
            
            // Find participant that is not the current user
            for (var p in participants) {
              final participant = p as Map<String, dynamic>;
              final user = participant['user'] as Map<String, dynamic>?;
              final userId = user?['id'] as int? ?? participant['id'] as int?;
              
              if (userId != null && userId != currentUserId) {
                otherParticipant = participant;
                participantUser = user ?? participant;
                break;
              }
            }
            
            // Fallback to first participant if not found
            if (otherParticipant == null && participants.isNotEmpty) {
              otherParticipant = participants[0] as Map<String, dynamic>;
              participantUser = otherParticipant?['user'] as Map<String, dynamic>? ?? otherParticipant;
            }
            
            final name = participantUser?['name'] as String? ?? 'Unknown';
            final avatarUrl = participantUser?['avatar_url'] as String? ?? '';
            final isOnline = participantUser?['is_online'] as bool? ?? false;
            final isVerified = participantUser?['is_fully_verified'] as bool? ?? false;
            final participantUserId = participantUser?['id'] as int? ?? 0;
            
            // Get latest message
            final latestMessage = conv['latest_message'] as Map<String, dynamic>?;
            final sender = latestMessage?['sender'] as Map<String, dynamic>?;
            final senderId = sender?['id'] as int?;
            final isMyMessage = senderId == currentUserId;
            
            final chats = latestMessage != null
                ? [
                    ChatModel(
                      isMine: isMyMessage,
                      text: latestMessage['body'] as String?,
                      timeAgo: latestMessage['created_at'] != null
                          ? DateTime.parse(latestMessage['created_at'])
                          : DateTime.now(),
                      isRead: latestMessage['is_read'] as bool? ?? false,
                      isDelivered: latestMessage['is_delivered'] as bool? ?? false,
                    )
                  ]
                : <ChatModel>[];
            
            return SingleChatModel(
              chatId: conv['id'] as int? ?? 0,
              name: name,
              avatarUrl: avatarUrl,
              type: conv['type'] as String? ?? 'private',
              isOnline: isOnline,
              isVerified: isVerified,
              chats: chats,
            );
          }).toList();
          
          _setState(_state.copyWith(
            isLoading: false,
            messages: conversations,
            error: null,
          ));
        } catch (e, stackTrace) {
          log('Error parsing conversations: $e\n$stackTrace');
          _setState(_state.copyWith(
            isLoading: false,
            error: 'Failed to parse conversation data: ${e.toString()}',
          ));
        }
      },
    );
  }

  void searchSingleChatModels(String query) async {
    if (query.isEmpty) {
      clearSearch();
      return;
    }

    _setState(_state.copyWith(isLoading: true, searchText: query));

    final result = await _messageService.searchMessages(query);

    result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          error: failure.message ?? 'Failed to search messages',
        ));
      },
      (response) {
        try {
          // Process search results - messages grouped by conversation
          final messagesData = response['data'] as Map<String, dynamic>?;
          final messagesList = messagesData?['data'] as List<dynamic>? ?? [];
          
          // Group by conversation and build chat models
          final conversationMap = <int, Map<String, dynamic>>{};
          
          for (var msgJson in messagesList) {
            final msg = msgJson as Map<String, dynamic>;
            final conversationId = msg['conversation_id'] as int? ?? 0;
            final conversation = msg['conversation'] as Map<String, dynamic>?;
            
            if (!conversationMap.containsKey(conversationId) && conversation != null) {
              conversationMap[conversationId] = conversation;
              (conversationMap[conversationId]!['messages'] as List? ?? []).clear();
            }
            
            if (conversationMap.containsKey(conversationId)) {
              (conversationMap[conversationId]!['messages'] as List? ?? []).add(msg);
            }
          }
          
          // Convert to SingleChatModel list
          final searchResults = conversationMap.values.map((conv) {
            final participants = conv['participants'] as List<dynamic>? ?? [];
            final otherParticipant = participants.firstWhere(
              (p) => (p as Map<String, dynamic>)['id'] != null,
              orElse: () => participants.isNotEmpty ? participants[0] : {},
            ) as Map<String, dynamic>?;
            
            final user = otherParticipant?['user'] as Map<String, dynamic>? ?? otherParticipant;
            
            return SingleChatModel(
              chatId: conv['id'] as int? ?? 0,
              name: user?['name'] as String? ?? 'Unknown',
              avatarUrl: user?['avatar_url'] as String? ?? '',
              type: conv['type'] as String? ?? 'private',
              isOnline: user?['is_online'] as bool? ?? false,
              isVerified: user?['is_fully_verified'] as bool? ?? false,
              chats: [],
            );
          }).toList();
          
          _setState(_state.copyWith(
            isLoading: false,
            isSearching: true,
            searchedMessages: searchResults,
            error: null,
          ));
        } catch (e, stackTrace) {
          log('Error searching messages: $e\n$stackTrace');
          _setState(_state.copyWith(
            isLoading: false,
            error: 'Failed to parse search results: ${e.toString()}',
          ));
        }
      },
    );
  }

  void clearSearch() {
    _setState(_state.copyWith(
      isSearching: false,
      searchText: '',
      searchedMessages: [],
    ));
  }

  SingleChatModel createNewChat(BuildContext context) {
    // Create a new chat with a unique ID
    final newChatId = _state.messages.isEmpty
        ? 1
        : _state.messages.map((e) => e.chatId).reduce((a, b) => a > b ? a : b) + 1;

    final newChat = SingleChatModel(
      chatId: newChatId,
      name: "New Chat $newChatId",
      avatarUrl: 'https://i.pravatar.cc/150?img=$newChatId',
      type: 'Vendor $newChatId',
      isOnline: true,
      isVerified: false,
      chats: [],
    );

    final updatedMessages = [newChat, ..._state.messages];
    _setState(_state.copyWith(messages: updatedMessages));

    context.read<SingleChatViewModel>().getCurrentChat(0);
    context.goToScreen(SolveitRoutes.messageScreen2);

    return newChat;
  }
}
