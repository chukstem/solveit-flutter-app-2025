import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/school/data/api/school_api.dart';
import 'package:solveit/features/school/domain/school_service.dart';
import 'package:solveit/features/school/presentation/school_viewmodel.dart';

SchoolApi schoolApi = sl<SchoolApi>();
SchoolService schoolService = sl<SchoolService>();

class SchoolInjectionContainer {
  static Future<void> initialize() async {
    sl.registerLazySingleton<SchoolApi>(
        () => SchoolApiImplementation(apiClient: sl()));
    sl.registerLazySingleton<SchoolService>(
        () => SchoolServiceImplementation());

    sl.registerFactory<SchoolViewModel>(() => SchoolViewModel());
  }
}
