import 'package:flutter/material.dart';
import 'package:solveit/features/forum/domain/models/res/forum_chat.dart';
import 'package:solveit/features/forum/presentation/viewmodels/forum_message_viewmodel.dart';
import 'package:solveit/features/messages/domain/models/responses/chat.dart';
import 'package:solveit/features/posts/domain/models/response/message_type.dart';

class ForumChatState {
  final MessageType commentType;
  final ForumChatModel? currentChat;
  final bool isExpanded;

  const ForumChatState({
    this.commentType = MessageType.text,
    this.currentChat,
    this.isExpanded = true,
  });

  ForumChatState copyWith({
    MessageType? commentType,
    ForumChatModel? currentChat,
    bool? isExpanded,
  }) {
    return ForumChatState(
      commentType: commentType ?? this.commentType,
      currentChat: currentChat ?? this.currentChat,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  static const empty = ForumChatState();
}

class ForumChatViewModel extends ChangeNotifier {
  final ForumMessageViewmodel _forumMessageViewmodel;
  late final GlobalKey<AnimatedListState> listKey;
  final ScrollController _scrollController = ScrollController();

  ForumChatState _state = ForumChatState.empty;
  ForumChatState get state => _state;

  ForumChatViewModel(this._forumMessageViewmodel) {
    listKey = GlobalKey<AnimatedListState>();
  }

  void _setState(ForumChatState state) {
    _state = state;
    notifyListeners();
  }

  ScrollController get scrollController => _scrollController;
  List<ForumChatModel> get singleChats => _forumMessageViewmodel.forumChatModel;

  // Getters for backward compatibility
  MessageType get commentType => _state.commentType;
  ForumChatModel? get currentChat => _state.currentChat;

  void setCommentType(MessageType type) {
    _setState(_state.copyWith(commentType: type));
  }

  Future<bool> getCurrentChat(index) async {
    if (_forumMessageViewmodel.forumChatModel.isNotEmpty) {
      _setState(_state.copyWith(currentChat: _forumMessageViewmodel.forumChatModel[index]));
    } else {
      await _forumMessageViewmodel.loadForumChats();
      getCurrentChat(index);
    }

    return _forumMessageViewmodel.forumChatModel.isNotEmpty;
  }

  void addForumChatMessage(String content,
      {bool isAudio = false,
      List<String> mediaUrl = const [],
      ChatReply? chatReply,
      Product? product}) {
    if (_state.currentChat == null) return;

    final chat = ChatModel(
      isMine: false,
      mediaUrls: isAudio ? [content] : List<String>.from(mediaUrl),
      text: isAudio ? null : content,
      timeAgo: DateTime.now(),
      chatReply: chatReply,
      product: product,
    );

    // Create a new chat list with the added message
    final updatedChat = _state.currentChat!;

    // **Insert at the last position**
    final index = updatedChat.chats.length;
    updatedChat.chats.add(chat);

    // **Tell AnimatedList to insert the new item**
    listKey.currentState?.insertItem(index);

    // Update state with the modified chat
    _setState(_state.copyWith(currentChat: updatedChat));

    // **Ensure UI scrolls to the bottom**
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
