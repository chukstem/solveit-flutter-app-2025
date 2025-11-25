import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/messages/domain/models/responses/chat.dart';
import 'package:solveit/features/messages/presentation/viewmodel/chat_viewmodel.dart';
import 'package:solveit/features/messages/presentation/viewmodel/message_viewmodel.dart';
import 'package:solveit/features/messages/presentation/widgets/messages_list_tile.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/widgets/skeleton/h_skeleton.dart';

class LoadingMessagesListView extends StatelessWidget {
  const LoadingMessagesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return HSkeleton(
      isLoading: true,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Message1ListTile(
            isOnline: Random.secure().nextBool(),
            title: "Tega Boi",
            subtitle: "Verified Pluto Cannabis",
            id: 3,
          );
        },
        itemCount: 10,
      ),
    );
  }
}

class LoadedMessagesListView extends StatelessWidget {
  final MessagesViewModel viewmodel;
  final List<SingleChatModel> state;
  final void Function()? onTap;
  const LoadedMessagesListView({super.key, required this.viewmodel, required this.state, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: state.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            context.read<SingleChatViewModel>().getCurrentChat(index);
            context.goToScreen(SolveitRoutes.messageScreen2);
          },
          child: Message1ListTile(
            isOnline: Random.secure().nextBool(),
            id: state[index].chatId,
            title: state[index].name,
            subtitle: state[index].chats.isNotEmpty && state[index].chats.last.text != null && state[index].chats.last.text!.isNotEmpty
                ? state[index].chats.last.text!.length > 20
                    ? "${state[index].chats.last.text!.substring(0, 20)}..."
                    : state[index].chats.last.text!
                : state[index].type,
          ),
        );
      },
    );
  }
}
