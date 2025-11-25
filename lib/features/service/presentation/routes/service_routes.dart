import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solveit/features/service/presentation/pages/service_details.dart';
import 'package:solveit/features/service/presentation/pages/service_search.dart';
import 'package:solveit/utils/navigation/go_router.dart';
import 'package:solveit/utils/navigation/routes.dart';

final serviceRoutes = [
  GoRoute(
    path: SolveitRoutes.serviceDetailsScreen.route,
    pageBuilder: (context, state) =>
        getTransition(const ServiceDetailsScreen(), state),
  ),
  GoRoute(
    path: SolveitRoutes.serviceProviderProfileScreen.route,
    pageBuilder: (context, state) => getTransition(const SizedBox(), state),
  ),
  GoRoute(
    path: SolveitRoutes.serviceSearchScreen.route,
    pageBuilder: (context, state) =>
        getTransition(const ServiceSearchScreen(), state),
  ),
];
