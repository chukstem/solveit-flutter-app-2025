import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/forum/presentation/viewmodels/forum_chat_viewmodel.dart';
import 'package:solveit/features/messages/domain/models/responses/chat.dart';
import 'package:solveit/features/messages/presentation/pages/widgets/chat_card.dart';
import 'package:solveit/features/posts/presentation/screens/widgets/comment.dart';
import 'package:solveit/features/posts/presentation/viewmodels/preview.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';

class ForumChatBody extends StatefulWidget {
  final ForumChatViewModel viewModel;

  const ForumChatBody({
    super.key,
    required this.viewModel,
  });

  @override
  State<ForumChatBody> createState() => _ForumChatBodyState();
}

class _ForumChatBodyState extends State<ForumChatBody> {
  @override
  void initState() {
    super.initState();
    context.read<MediaPreviewViewModel>().setPostType(PostType.forum);
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
            curve: Curves.linear,
            duration: Durations.extralong1,
            widget.viewModel.scrollController.position.maxScrollExtent / offset,
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
    final viewModel = context.watch<ForumChatViewModel>();

    return Column(
      children: [
        Expanded(
          child: AnimatedList(
            key: viewModel.listKey,
            controller: viewModel.scrollController,
            padding: horizontalPadding,
            initialItemCount: viewModel.currentChat!.chats.length,
            itemBuilder: (context, index, animation) => SizeTransition(
              sizeFactor: animation,
              child: ChatCard(
                chat: viewModel.currentChat!.chats[index],
                name: viewModel.currentChat!.title,
              ),
            ),
          ),
        ),
        CommentInput(
          padding: EdgeInsets.only(bottom: 16.h),
          sendComment: (comment, isAudio, replyingTo) async =>
              context.read<ForumChatViewModel>().addForumChatMessage(
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
