import 'package:go_router/go_router.dart';
import 'package:solveit/features/forum/presentation/pages/forum_chat.dart';
import 'package:solveit/utils/navigation/go_router.dart';
import 'package:solveit/utils/navigation/routes.dart';

final forumRoutes = [
  GoRoute(
    path: SolveitRoutes.forumChatScreen.route,
    pageBuilder: (context, state) =>
        getTransition(const ForumChatScreen(), state),
  ),
];
