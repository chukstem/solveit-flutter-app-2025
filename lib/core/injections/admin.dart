import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/admin/data/api/admin_api.dart';
import 'package:solveit/features/admin/domain/admin_service.dart';
import 'package:solveit/features/admin/presentation/viewmodel/admin_viewmodel.dart';
import 'package:solveit/features/admin/presentation/viewmodel/role_permissions_viewmodel.dart';

AdminApi adminApi = sl<AdminApi>();
AdminService adminService = sl<AdminService>();
AdminViewModel adminViewmodel = sl<AdminViewModel>();

class AdminInjectionContainer {
  static Future<void> initialize() async {
    sl.registerLazySingleton<AdminApi>(() => AdminApiImplementation(apiClient: sl()));
    sl.registerLazySingleton<AdminService>(() => AdminServiceImplementation());

    sl.registerLazySingleton<AdminViewModel>(() => AdminViewModel());
    sl.registerLazySingleton<RolePermissionsViewModel>(() => RolePermissionsViewModel());
  }
}
