import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/admin/presentation/routes/admin_routes.dart';
import 'package:solveit/features/authentication/data/models/auth/responses/token.dart';
import 'package:solveit/features/authentication/presentation/routes/authentication_routes.dart';
import 'package:solveit/features/authentication/presentation/viewmodel/state_provider.dart';
import 'package:solveit/features/forum/presentation/routes/forum_routes.dart';
import 'package:solveit/features/home/presentation/route/home_routes.dart';
import 'package:solveit/features/market/presentation/routes/market_routes.dart';
import 'package:solveit/features/messages/presentation/routes/messages_routes.dart';
import 'package:solveit/features/posts/presentation/routes/post_routes.dart';
import 'package:solveit/features/service/presentation/routes/service_routes.dart';
import 'package:solveit/utils/navigation/hegmof_bottom_nav.dart';
import 'package:solveit/utils/navigation/routes.dart';

GlobalKey<NavigatorState> parentKey = GlobalKey<NavigatorState>();

StreamSubscription<UserToken?>? subscription;
GoRouter solveitRouter = GoRouter(
  navigatorKey: parentKey,
  routes: [
    ...adminRoutes,
    ...authenticationRoutes,
    ...postRoutes,
    ...messageRoutes,
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return SolveitBottomNavigation(navigationShell: navigationShell);
      },
      branches: [...homeShellRoutes],
    ),
    ...homeSubRoutes,
    ...marketRoutes,
    ...serviceRoutes,
    ...forumRoutes,
  ],
  initialLocation:
      kIsWeb ? SolveitRoutes.adminLoginScreen.route : SolveitRoutes.onboardingHomeScreen.route,
  redirect: (context, state) async {
    final userManager = sl<UserStateManager>();

    if (!userManager.state.isInitialized) {
      await userManager.init();
    }

    // For web admin route
    if (kIsWeb && state.fullPath == '/' && userManager.state.authenticated) {
      return SolveitRoutes.adminLoginScreen.route;
    }

    // For mobile app route
    if (state.fullPath == SolveitRoutes.onboardingHomeScreen.route &&
        userManager.state.authenticated) {
      return SolveitRoutes.homeScreen.route;
    }

    return null;
  },
  debugLogDiagnostics: true,
);

getTransition(Widget screen, GoRouterState state) {
  return CustomTransitionPage(
      key: state.pageKey,
      child: screen,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 2.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      });
}
