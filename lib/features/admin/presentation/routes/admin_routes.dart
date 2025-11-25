import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solveit/features/admin/presentation/pages/admin_dashboard.dart';
import 'package:solveit/features/admin/presentation/pages/admin_login.dart';
import 'package:solveit/utils/navigation/routes.dart';

List<RouteBase> adminRoutes = [
  GoRoute(
    path: SolveitRoutes.adminLoginScreen.route,
    builder: (BuildContext context, GoRouterState state) {
      return const AdminLoginScreen();
    },
  ),
  GoRoute(
    path: SolveitRoutes.adminDashboard.route,
    builder: (BuildContext context, GoRouterState state) {
      return const AdminDashboardView();
    },
  ),
];
