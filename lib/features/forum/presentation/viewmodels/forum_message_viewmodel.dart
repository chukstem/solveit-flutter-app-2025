import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/forum/domain/models/res/forum_chat.dart';
import 'package:solveit/features/forum/domain/forum_service.dart';
import 'package:solveit/features/messages/domain/models/responses/chat.dart';
import 'package:solveit/utils/utils/strings.dart';

class ForumMessageState {
  final bool isLoading;
  final bool isSearching;
  final String searchText;
  final String? error;
  final List<ForumChatModel> forums;
  final List<ForumChatModel> searchedMessages;

  const ForumMessageState({
    this.isLoading = false,
    this.isSearching = false,
    this.searchText = '',
    this.error,
    this.forums = const [],
    this.searchedMessages = const [],
  });

  int get activeCount => forums.length;

  ForumMessageState copyWith({
    bool? isLoading,
    bool? isSearching,
    String? searchText,
    String? error,
    List<ForumChatModel>? forums,
    List<ForumChatModel>? searchedMessages,
  }) {
    return ForumMessageState(
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      searchText: searchText ?? this.searchText,
      error: error ?? this.error,
      forums: forums ?? this.forums,
      searchedMessages: searchedMessages ?? this.searchedMessages,
    );
  }

  static const empty = ForumMessageState();
}

class ForumMessageViewmodel extends ChangeNotifier {
  ForumMessageState _state = ForumMessageState.empty;
  ForumMessageState get state => _state;
  
  final ForumService _forumService = sl<ForumService>();

  ForumMessageViewmodel() {
    loadForumChats();
  }

  void _setState(ForumMessageState state) {
    _state = state;
    notifyListeners();
  }

  // Getters for backward compatibility
  bool get isLoading => _state.isLoading;
  bool get isSearching => _state.isSearching;
  String get searchText => _state.searchText;
  String? get forumChatModelError => _state.error;
  List<ForumChatModel> get forumChatModel => _state.forums;
  List<ForumChatModel> get searchedMessages => _state.searchedMessages;

  // Setter for backward compatibility
  set forumChatModel(List<ForumChatModel> value) {
    _setState(_state.copyWith(forums: value));
  }

  Future<void> loadForumChats() async {
    _setState(_state.copyWith(isLoading: true, error: null));

    final result = await _forumService.getForums();

    result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          error: failure.message ?? 'Failed to load forums',
        ));
      },
      (response) {
        try {
          // Backend returns: { status, message, data: { data: [...], current_page, ... } }
          final forumsData = response['data'] as Map<String, dynamic>?;
          final forumsList = forumsData?['data'] as List<dynamic>? ?? [];
          
          final forums = forumsList.map((forumJson) {
            final forum = forumJson as Map<String, dynamic>;
            
            // Get media URL for forum cover image
            final media = forum['media'] as List<dynamic>?;
            final forumPicUrl = media?.isNotEmpty == true 
                ? (media!.first['full_url'] as String? ?? '')
                : '';
            
            // Get member avatars
            final memberAvatars = forum['member_avatars'] as List<dynamic>? ?? [];
            final avatarUrls = memberAvatars
                .map((avatar) => (avatar as Map<String, dynamic>)['avatar_url'] as String? ?? '')
                .where((url) => url.isNotEmpty)
                .toList();
            
            // Get latest message for chats
            final latestMessage = forum['latest_message'] as Map<String, dynamic>?;
            final chats = latestMessage != null
                ? [
                    ChatModel(
                      isMine: false,
                      text: latestMessage['message'] as String?,
                      timeAgo: latestMessage['created_at'] != null
                          ? DateTime.parse(latestMessage['created_at'])
                          : DateTime.now(),
                      isRead: false,
                      isDelivered: true,
                    )
                  ]
                : <ChatModel>[];
            
            return ForumChatModel(
              chatId: forum['id'] as int? ?? 0,
              title: forum['name'] as String? ?? '',
              forumPicUrl: forumPicUrl,
              avatarUrls: avatarUrls.isEmpty && forumPicUrl.isNotEmpty 
                  ? [forumPicUrl] 
                  : avatarUrls,
              students: forum['member_count'] as int? ?? 0,
              unread: forum['unread_count'] as int? ?? 0,
              chats: chats,
            );
          }).toList();
          
          _setState(_state.copyWith(
            isLoading: false,
            forums: forums,
            error: null,
          ));
        } catch (e, stackTrace) {
          log('Error parsing forums: $e\n$stackTrace');
          _setState(_state.copyWith(
            isLoading: false,
            error: 'Failed to parse forum data: ${e.toString()}',
          ));
        }
      },
    );
  }

  void searchForumChatMessages(String query) async {
    if (query.isEmpty) {
      clearSearch();
      return;
    }

    _setState(_state.copyWith(isLoading: true, searchText: query));

    final result = await _forumService.searchForums(query);

    result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          error: failure.message ?? 'Failed to search forums',
        ));
      },
      (response) {
        try {
          final forumsData = response['data'] as Map<String, dynamic>?;
          final forumsList = forumsData?['data'] as List<dynamic>? ?? [];
          
          final searchResults = forumsList.map((forumJson) {
            final forum = forumJson as Map<String, dynamic>;
            final media = forum['media'] as List<dynamic>?;
            final forumPicUrl = media?.isNotEmpty == true 
                ? (media!.first['full_url'] as String? ?? '')
                : '';
            final memberAvatars = forum['member_avatars'] as List<dynamic>? ?? [];
            final avatarUrls = memberAvatars
                .map((avatar) => (avatar as Map<String, dynamic>)['avatar_url'] as String? ?? '')
                .where((url) => url.isNotEmpty)
                .toList();
            
            return ForumChatModel(
              chatId: forum['id'] as int? ?? 0,
              title: forum['name'] as String? ?? '',
              forumPicUrl: forumPicUrl,
              avatarUrls: avatarUrls.isEmpty && forumPicUrl.isNotEmpty ? [forumPicUrl] : avatarUrls,
              students: forum['member_count'] as int? ?? 0,
              unread: forum['unread_count'] as int? ?? 0,
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
          log('Error searching forums: $e\n$stackTrace');
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
}
