import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/admin/presentation/viewmodel/admin_viewmodel.dart';
import 'package:solveit/features/admin/presentation/widgets/dashboard_overview.dart';
import 'package:solveit/features/admin/presentation/widgets/posts_management.dart';
import 'package:solveit/features/admin/presentation/widgets/roles_permissions.dart';
import 'package:solveit/features/admin/presentation/widgets/school_management.dart';

class DashboardContent extends StatelessWidget {
  final String section;

  const DashboardContent({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final adminViewModel = context.read<AdminViewModel>();

    switch (section) {
      case 'dashboard':
        return DashboardOverview(adminViewModel: adminViewModel);
      case 'school':
        return SchoolManagement(adminViewModel: adminViewModel);
      case 'posts':
        return PostsManagement(adminViewModel: adminViewModel);
      case 'roles':
        return RolesAndPermissions(adminViewModel: adminViewModel);
      default:
        return DashboardOverview(adminViewModel: adminViewModel);
    }
  }
}
