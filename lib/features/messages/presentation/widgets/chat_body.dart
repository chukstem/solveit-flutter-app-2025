import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/features/messages/domain/models/responses/chat.dart';
import 'package:solveit/features/messages/presentation/pages/widgets/chat_card.dart';
import 'package:solveit/features/messages/presentation/viewmodel/chat_viewmodel.dart';
import 'package:solveit/features/posts/presentation/screens/widgets/comment.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';

class ChatBody extends StatefulWidget {
  final SingleChatViewModel viewModel;
  final String chatName;

  const ChatBody({
    super.key,
    required this.viewModel,
    required this.chatName,
  });

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollToBottom();
  }

  void _scrollToBottom({int offset = 1, bool animate = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.viewModel.scrollController.hasClients) {
        if (animate) {
          widget.viewModel.scrollController.animateTo(
            widget.viewModel.scrollController.position.maxScrollExtent / offset,
            curve: Curves.linear,
            duration: Durations.extralong1,
          );
        } else {
          widget.viewModel.scrollController.jumpTo(
            widget.viewModel.scrollController.position.maxScrollExtent - offset,
          );
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AnimatedList(
            key: widget.viewModel.listKey,
            controller: widget.viewModel.scrollController,
            padding: horizontalPadding,
            initialItemCount: widget.viewModel.currentChat!.chats.length,
            itemBuilder: (context, index, animation) => SizeTransition(
              sizeFactor: animation,
              child: ChatCard(
                chat: widget.viewModel.currentChat!.chats[index],
                name: widget.chatName,
              ),
            ),
          ),
        ),
        CommentInput(
          padding: EdgeInsets.only(bottom: 16.h),
          sendComment: (comment, isAudio, replyingTo) async => widget.viewModel.addSingleChatModel(
            comment,
            isAudio: isAudio,
            chatReply: replyingTo == null
                ? null
                : ChatReply(
                    name: replyingTo.name,
                    content: replyingTo.comment!,
                    mediaUrls: replyingTo.type.isEmpty ? [] : replyingTo.type,
                  ),
          ),
        ),
      ],
    );
  }
}
