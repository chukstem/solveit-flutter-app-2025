import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/admin/presentation/viewmodel/admin_viewmodel.dart';
import 'package:solveit/features/admin/presentation/viewmodel/role_permissions_viewmodel.dart';

final adminViewmodels = <SingleChildWidget>[
  ChangeNotifierProvider<AdminViewModel>(
    create: (_) => sl<AdminViewModel>(),
  ),
  ChangeNotifierProvider<RolePermissionsViewModel>(
    create: (_) => sl<RolePermissionsViewModel>(),
  ),
];
