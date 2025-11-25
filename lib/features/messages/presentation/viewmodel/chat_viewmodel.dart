import 'package:flutter/material.dart';
import 'package:solveit/features/messages/domain/models/responses/chat.dart';
import 'package:solveit/features/messages/presentation/viewmodel/message_viewmodel.dart';
import 'package:solveit/features/posts/domain/models/response/message_type.dart';

class SingleChatState {
  final MessageType commentType;
  final SingleChatModel? currentChat;

  const SingleChatState({
    this.commentType = MessageType.text,
    this.currentChat,
  });

  SingleChatState copyWith({
    MessageType? commentType,
    SingleChatModel? currentChat,
  }) {
    return SingleChatState(
      commentType: commentType ?? this.commentType,
      currentChat: currentChat ?? this.currentChat,
    );
  }

  static const empty = SingleChatState();
}

class SingleChatViewModel extends ChangeNotifier {
  final MessagesViewModel _singleChatModelsViewmodel;
  late final GlobalKey<AnimatedListState> listKey;
  final ScrollController _scrollController = ScrollController();

  SingleChatState _state = SingleChatState.empty;
  SingleChatState get state => _state;

  SingleChatViewModel(this._singleChatModelsViewmodel) {
    listKey = GlobalKey<AnimatedListState>();
  }

  void _setState(SingleChatState state) {
    _state = state;
    notifyListeners();
  }

  // Getters for backward compatibility
  ScrollController get scrollController => _scrollController;
  List<SingleChatModel> get singleChats => _singleChatModelsViewmodel.singleChatModels;
  MessageType get commentType => _state.commentType;
  SingleChatModel? get currentChat => _state.currentChat;

  void setCommentType(MessageType type) {
    _setState(_state.copyWith(commentType: type));
  }

  void getCurrentChat(int index) {
    _setState(_state.copyWith(currentChat: _singleChatModelsViewmodel.singleChatModels[index]));
  }

  void addSingleChatModel(String content,
      {bool isAudio = false,
      List<String> mediaUrl = const [],
      ChatReply? chatReply,
      Product? product}) {
    if (_state.currentChat == null) return;

    final chat = ChatModel(
      isMine: true,
      mediaUrls: isAudio ? [content] : List<String>.from(mediaUrl),
      text: isAudio ? null : content,
      timeAgo: DateTime.now(),
      chatReply: chatReply,
      product: product,
    );

    // Create a copy of the current chat with the new message
    final updatedChat = _state.currentChat!;

    // Insert at the last position
    final index = updatedChat.chats.length;
    updatedChat.chats.add(chat);

    // Tell AnimatedList to insert the new item
    listKey.currentState?.insertItem(index);

    // Update state with modified chat
    _setState(_state.copyWith(currentChat: updatedChat));

    // Ensure UI scrolls to the bottom
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
