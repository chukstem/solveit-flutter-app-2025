import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solveit/features/messages/presentation/pages/chat_screen.dart';
import 'package:solveit/features/messages/presentation/pages/message_one.dart';
import 'package:solveit/utils/navigation/routes.dart';

final messageRoutes = [
  GoRoute(
    path: SolveitRoutes.messageScreen1.route,
    builder: (BuildContext context, GoRouterState state) {
      return const MessageScreen1();
    },
  ),
  GoRoute(
    path: SolveitRoutes.messageScreen2.route,
    builder: (BuildContext context, GoRouterState state) {
      return const SingleChatScreen();
    },
  ),
];
