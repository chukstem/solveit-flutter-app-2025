import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/forum/presentation/pages/widgets/call.dart';
import 'package:solveit/features/forum/presentation/viewmodels/call.dart';
import 'package:solveit/features/forum/presentation/viewmodels/forum_chat_viewmodel.dart';
import 'package:solveit/features/forum/presentation/widgets/forum_chat_body.dart';
import 'package:solveit/features/forum/presentation/widgets/forum_chat_header.dart';
import 'package:solveit/features/posts/presentation/viewmodels/inputfield_viewmodel.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';

class ForumChatScreen extends StatelessWidget {
  const ForumChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ForumChatViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.currentChat == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          backgroundColor: SolveitColors.primaryColor300,
          appBar: ForumChatHeader(
            forumChat: viewModel.currentChat!,
            onBackPressed: () {
              Navigator.pop(context);
              context.read<InputfieldViewmodel>().clearReply();
            },
            onMorePressed: () => _showForumAction(context, []),
          ),
          body: ForumChatBody(
            viewModel: viewModel,
          ),
        );
      },
    );
  }
}

void _showForumAction(BuildContext context, List<CallParticipant> participants) {
  context.showBottomSheet(StatefulBuilder(builder: (context, setState) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Actions',
                style:
                    Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(closeIconSvg),
              ),
            ],
          ),
        ),
        // Forum actions list
        // Voice call option
        ListTile(
          leading: SvgPicture.asset(audioCallSvg),
          title: const Text('Voice call'),
          onTap: () {
            Navigator.pop(context);
            _showVoiceCallDialog(context, participants);
          },
        ),
        // Video call option
        ListTile(
          leading: SvgPicture.asset(videoCallSvg),
          title: const Text('Video call'),
          onTap: () {
            // Handle video call
            Navigator.pop(context);
          },
        ),
        // Mute notifications option
        ListTile(
          leading: SvgPicture.asset(
            notificationSvg,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          title: const Text('Mute notifications'),
          onTap: () {
            // Handle mute notifications
            Navigator.pop(context);
          },
        ),
        // Leave forum option
        ListTile(
          leading: SvgPicture.asset(
            cancelCallSvg,
          ),
          title: const Text('Leave forum', style: TextStyle(color: Colors.red)),
          onTap: () {
            // Handle leave forum
            Navigator.pop(context);
          },
        ),
      ],
    );
  }));
}

void _showVoiceCallDialog(BuildContext context, List<CallParticipant> participants) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (context) {
      Future.microtask(() {
        if (context.mounted) {
          context.read<GroupCallViewModel>().startCall();
        }
      });
      return const CallBottomSheet(type: CallType.audio);
    },
  ).whenComplete(() {
    if (context.mounted) {
      context.read<GroupCallViewModel>().markSheetClosed();
    }
  });
}
