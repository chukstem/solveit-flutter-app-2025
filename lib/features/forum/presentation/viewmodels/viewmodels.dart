import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/forum/presentation/viewmodels/call.dart';
import 'package:solveit/features/forum/presentation/viewmodels/forum_chat_viewmodel.dart';
import 'package:solveit/features/forum/presentation/viewmodels/forum_message_viewmodel.dart';

final forumViewModel = <SingleChildWidget>[
  ChangeNotifierProvider<ForumChatViewModel>(
      create: (_) => sl<ForumChatViewModel>()),
  ChangeNotifierProvider<ForumMessageViewmodel>(
      create: (_) => sl<ForumMessageViewmodel>()),
  ChangeNotifierProvider<GroupCallViewModel>(
      create: (_) => sl<GroupCallViewModel>()),
];
