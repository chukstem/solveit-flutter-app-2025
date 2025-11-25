import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/forum/presentation/pages/widgets/forum_card.dart';
import 'package:solveit/features/forum/presentation/viewmodels/forum_chat_viewmodel.dart';
import 'package:solveit/features/forum/presentation/viewmodels/forum_message_viewmodel.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/widgets/skeleton/h_skeleton.dart';

class ForumList extends StatelessWidget {
  final ForumMessageViewmodel viewModel;
  final VoidCallback? onForumSelected;

  const ForumList({
    super.key,
    required this.viewModel,
    this.onForumSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: viewModel.isLoading
          ? HSkeleton(
              isLoading: true,
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (_, index) {
                  return const ForumCard(
                    title: 'Loading Forum',
                    avatarUrls: [],
                    studentCount: 1,
                    unreadMessages: 0,
                  );
                },
              ))
          : ListView.builder(
              itemCount: viewModel.forumChatModel.length,
              itemBuilder: (_, index) {
                final forum = viewModel.forumChatModel[index];
                return GestureDetector(
                  onTap: () async {
                    final r = await context.read<ForumChatViewModel>().getCurrentChat(index);
                    if (r && context.mounted) {
                      if (onForumSelected != null) {
                        onForumSelected!();
                      }
                      context.goToScreen(SolveitRoutes.forumChatScreen);
                    }
                  },
                  child: ForumCard(
                    title: forum.title,
                    avatarUrls: List<String>.from(forum.avatarUrls),
                    studentCount: forum.students,
                    unreadMessages: forum.unread,
                  ),
                );
              },
            ),
    );
  }
}
