import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/forum/data/api/forum_api.dart';
import 'package:solveit/features/forum/domain/forum_service.dart';
import 'package:solveit/features/forum/presentation/viewmodels/call.dart';
import 'package:solveit/features/forum/presentation/viewmodels/forum_chat_viewmodel.dart';
import 'package:solveit/features/forum/presentation/viewmodels/forum_message_viewmodel.dart';

class ForumInjectionContainer {
  static Future<void> initialize() async {
    sl.registerLazySingleton<ForumApi>(() => ForumApiImplementation());
    sl.registerLazySingleton<ForumService>(() => ForumServiceImplementation());
    sl.registerFactory<ForumChatViewModel>(() => ForumChatViewModel(sl()));
    sl.registerLazySingleton<ForumMessageViewmodel>(
        () => ForumMessageViewmodel());
    sl.registerFactory<GroupCallViewModel>(() => GroupCallViewModel());
  }
}
