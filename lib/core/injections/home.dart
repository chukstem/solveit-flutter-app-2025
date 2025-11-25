import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/home/presentation/viewmodel/notification.dart';

class HomeInjectionContainer {
  static Future<void> initialize() async {
    // sl.registerLazySingleton<SchoolApi>(
    //     () => SchoolApiImplementation(apiClient: sl()));
    // sl.registerLazySingleton<SchoolService>(
    //     () => SchoolServiceImplementation());

    sl.registerFactory<NotificationsViewModel>(() => NotificationsViewModel());
  }
}
