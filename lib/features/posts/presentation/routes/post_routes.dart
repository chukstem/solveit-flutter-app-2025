import 'package:go_router/go_router.dart';
import 'package:solveit/features/posts/presentation/screens/preview.dart';
import 'package:solveit/features/posts/presentation/screens/single_post_screen.dart';
import 'package:solveit/utils/navigation/go_router.dart';
import 'package:solveit/utils/navigation/routes.dart';

final postRoutes = [
  GoRoute(
      path: SolveitRoutes.singlePostScreen.route,
      pageBuilder: (context, state) =>
          getTransition(const SinglePostScreen(), state)),
  GoRoute(
      path: SolveitRoutes.previewSelectedMediaScreen.route,
      pageBuilder: (context, state) =>
          getTransition(const MediaPreviewScreen(), state))
];
