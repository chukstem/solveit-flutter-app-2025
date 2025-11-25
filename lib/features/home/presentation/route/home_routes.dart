import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solveit/features/forum/presentation/pages/forums.dart';
import 'package:solveit/features/home/presentation/pages/home_screen.dart';
import 'package:solveit/features/home/presentation/pages/home_search.dart';
import 'package:solveit/features/home/presentation/pages/notification_screen.dart';
import 'package:solveit/features/home/presentation/pages/profile.dart';
import 'package:solveit/features/market/presentation/pages/market.dart';
import 'package:solveit/features/service/presentation/pages/service_screen.dart';
import 'package:solveit/utils/navigation/go_router.dart';
import 'package:solveit/utils/navigation/routes.dart';

final _shellNavigatorAKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _shellNavigatorBKey = GlobalKey<NavigatorState>(debugLabel: 'market');
final _shellNavigatorCKey = GlobalKey<NavigatorState>(debugLabel: 'services');
final _shellNavigatorDKey = GlobalKey<NavigatorState>(debugLabel: 'forums');

final homeShellRoutes = [
  StatefulShellBranch(
    navigatorKey: _shellNavigatorAKey,
    routes: [
      GoRoute(
        path: SolveitRoutes.homeScreen.route,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: HomeScreen()),
        routes: const [],
      ),
    ],
  ),
  StatefulShellBranch(
    navigatorKey: _shellNavigatorBKey,
    routes: [
      GoRoute(
        path: SolveitRoutes.marketPlace.route,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: MarketplaceScreen()),
        routes: const [],
      ),
    ],
  ),
  StatefulShellBranch(
    navigatorKey: _shellNavigatorCKey,
    routes: [
      GoRoute(
        path: SolveitRoutes.servicesScreen.route,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ServicesScreen()),
        routes: const [],
      ),
    ],
  ),
  StatefulShellBranch(
    navigatorKey: _shellNavigatorDKey,
    routes: [
      GoRoute(
        path: SolveitRoutes.forumsScreen.route,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ForumScreen()),
        routes: const [],
      ),
    ],
  ),
];

final homeSubRoutes = [
  GoRoute(
    path: SolveitRoutes.profileScreen.route,
    builder: (context, state) => const ProfileScreen(),
  ),
  GoRoute(
    path: SolveitRoutes.notificationScreen.route,
    builder: (context, state) => const NotificationsScreen(),
  ),
  GoRoute(
    path: SolveitRoutes.homeScreenSearch.route,
    pageBuilder: (context, state) =>
        getTransition(const HomeSearchScreen(), state),
  )
];
