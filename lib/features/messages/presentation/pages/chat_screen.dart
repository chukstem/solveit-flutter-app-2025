import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/messages/domain/models/responses/chat.dart';
import 'package:solveit/features/messages/presentation/pages/widgets/chat_card.dart';
import 'package:solveit/features/messages/presentation/viewmodel/chat_viewmodel.dart';
import 'package:solveit/features/messages/presentation/widgets/chat_app_bar.dart';
import 'package:solveit/features/messages/presentation/widgets/chat_body.dart';
import 'package:solveit/features/posts/presentation/screens/widgets/comment.dart';
import 'package:solveit/features/posts/presentation/viewmodels/inputfield_viewmodel.dart';
import 'package:solveit/features/posts/presentation/viewmodels/preview.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';

class SingleChatScreen extends StatelessWidget {
  const SingleChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SingleChatViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.currentChat == null) {
          return const Scaffold(
            body: Center(child: Text("No chat selected")),
          );
        }

        return Scaffold(
          backgroundColor: SolveitColors.primaryColor300,
          appBar: ChatAppBar(
            chat: viewModel.currentChat!,
            onBackPressed: () {
              Navigator.pop(context);
              context.read<InputfieldViewmodel>().clearReply();
            },
            onSearchPressed: () {},
            onMorePressed: () {},
          ),
          body: ChatBody(
            viewModel: viewModel,
            chatName: viewModel.currentChat!.name,
          ),
        );
      },
    );
  }
}

class ChatWidget extends StatefulWidget {
  final SingleChatViewModel viewModel;

  const ChatWidget({
    super.key,
    required this.viewModel,
  });

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  void initState() {
    super.initState();
    context.read<MediaPreviewViewModel>().setPostType(PostType.chat);
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
    final viewModel = context.watch<SingleChatViewModel>();

    return Column(
      children: [
        Expanded(
          child: AnimatedList(
            key: viewModel.listKey, // Attach the AnimatedList key
            controller: viewModel.scrollController,
            padding: horizontalPadding, // Add padding to the list
            initialItemCount: viewModel.currentChat!.chats.length,
            itemBuilder: (context, index, animation) => SizeTransition(
              sizeFactor: animation,
              child: ChatCard(
                chat: viewModel.currentChat!.chats[index],
                name: viewModel.currentChat!.name,
              ),
            ),
          ),
        ),
        CommentInput(
          padding: EdgeInsets.only(bottom: 16.h),
          sendComment: (comment, isAdio, replyingTo) async =>
              context.read<SingleChatViewModel>().addSingleChatModel(comment,
                  isAudio: isAdio,
                  chatReply: replyingTo == null
                      ? null
                      : ChatReply(
                          name: replyingTo.name,
                          content: replyingTo.comment!,
                          mediaUrls: replyingTo.type.isEmpty ? [] : replyingTo.type,
                        )),
        ),
      ],
    );
  }
}
