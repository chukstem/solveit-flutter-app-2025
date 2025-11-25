import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/messages/data/api/message_api.dart';
import 'package:solveit/features/messages/domain/message_service.dart';
import 'package:solveit/features/messages/presentation/viewmodel/chat_viewmodel.dart';
import 'package:solveit/features/messages/presentation/viewmodel/message_viewmodel.dart';

class MessagesInjectionContainer {
  static Future<void> initialize() async {
    sl.registerLazySingleton<MessageApi>(() => MessageApiImplementation());
    sl.registerLazySingleton<MessageService>(() => MessageServiceImplementation());
    sl.registerLazySingleton<MessagesViewModel>(() => MessagesViewModel());
    sl.registerFactory<SingleChatViewModel>(() => SingleChatViewModel(sl()));
  }
}
