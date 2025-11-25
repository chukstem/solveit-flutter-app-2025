import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/service/data/services_api.dart';
import 'package:solveit/features/service/domain/core_service_service.dart';
import 'package:solveit/features/service/presentation/viewmodels/core_services_viewmodel.dart';
import 'package:solveit/features/service/presentation/viewmodels/details.dart';
import 'package:solveit/features/service/presentation/viewmodels/filter.dart';
import 'package:solveit/features/service/presentation/viewmodels/service_search.dart';
import 'package:solveit/features/service/presentation/viewmodels/services_viewmodel.dart';

final coreServicesApi = sl<CoreServicesApi>();
final coreServicesService = sl<CoreServicesService>();
final servicesViewModel = sl<ServicesViewModel>();
final serviceFilterViewModel = sl<ServiceFilterViewModel>();
final serviceSearchViewModel = sl<ServiceSearchViewModel>();
final servicesDetailViewModel = sl<ServicesDetailViewModel>();
final coreServicesViewModel = sl<CoreServicesViewModel>();

class ServicesInjectionContainer {
  static Future<void> initialize() async {
    sl.registerFactory<ServicesViewModel>(() => ServicesViewModel());
    sl.registerFactory<ServiceFilterViewModel>(() => ServiceFilterViewModel());
    sl.registerFactory<ServiceSearchViewModel>(() => ServiceSearchViewModel());
    sl.registerFactory<ServicesDetailViewModel>(() => ServicesDetailViewModel());

    sl.registerLazySingleton<CoreServicesApi>(() => CoreServicesApiImplementation());
    sl.registerLazySingleton<CoreServicesService>(() => CoreServicesServiceImplementation());
    sl.registerLazySingleton<CoreServicesViewModel>(() => CoreServicesViewModel());
  }
}
