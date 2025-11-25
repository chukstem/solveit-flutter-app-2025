import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/general/api/general_api.dart';
import 'package:solveit/features/general/presentation/viewmodel.dart/general_viewmodel.dart';
import 'package:solveit/features/general/service/general_service.dart';

GeneralApi get generalApi => sl<GeneralApi>();
GeneralService get generalService => sl<GeneralService>();

class GeneralInjectionContainer {
  static Future<void> initialize() async {
    sl.registerLazySingleton<GeneralApi>(() => GeneralApiImplementation());
    sl.registerLazySingleton<GeneralService>(() => GeneralServiceImplementation());
    sl.registerFactory<GeneralViewmodel>(() => GeneralViewmodel());
  }
}
