import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/messages/presentation/viewmodel/chat_viewmodel.dart';
import 'package:solveit/features/messages/presentation/viewmodel/message_viewmodel.dart';

final messagesViewmodel = <SingleChildWidget>[
  ChangeNotifierProvider<MessagesViewModel>(
    create: (_) => sl<MessagesViewModel>(),
  ),
  ChangeNotifierProvider<SingleChatViewModel>(
    create: (_) => sl<SingleChatViewModel>(),
  ),
];
