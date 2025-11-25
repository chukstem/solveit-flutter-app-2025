import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/market/presentation/viewmodel/market_viewmodel.dart';
import 'package:solveit/features/service/presentation/viewmodels/services_viewmodel.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

class SolveitBottomNavigation extends StatelessWidget {
  SolveitBottomNavigation({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  final items = [
    BottomNavItem(
      title: 'Home',
      route: SolveitRoutes.homeScreen,
      asset: bnHome,
    ),
    BottomNavItem(
      title: "Marketplace",
      route: SolveitRoutes.marketPlace,
      asset: bnMarketplace,
    ),
    BottomNavItem(
      title: "Services",
      route: SolveitRoutes.servicesScreen,
      asset: bnServices,
    ),
    BottomNavItem(
      title: "Forums",
      route: SolveitRoutes.forumsScreen,
      asset: bnForums,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        child: context.watch<MarketViewModel>().isScrolling ||
                context.watch<ServicesViewModel>().isScrolling
            ? const SizedBox.shrink()
            : BottomNavigationBar(
                backgroundColor: context.colorScheme.surface,
                onTap: _goBranch,
                showSelectedLabels: true,
                type: BottomNavigationBarType.fixed,
                iconSize: 30.w,
                unselectedFontSize: 12.sp,
                selectedFontSize: 12.sp,
                selectedIconTheme: IconThemeData(color: context.colorScheme.primary),
                selectedItemColor: context.colorScheme.primary,
                currentIndex: navigationShell.currentIndex,
                unselectedItemColor: context.colorScheme.onSurface,
                showUnselectedLabels: true,
                items: items
                    .map((menu) => BottomNavigationBarItem(
                          icon: Badge(
                            offset: Offset(5, -5.h),
                            label: SizedBox(
                                width: 8.w,
                                child: const Text(
                                  "",
                                )),
                            backgroundColor: Colors.red,
                            isLabelVisible: false,
                            child: SvgPicture.asset(
                              menu.asset,
                              width: 20.w,
                              height: 20.h,
                              colorFilter: ColorFilter.mode(
                                  navigationShell.currentIndex == items.indexOf(menu)
                                      ? context.primaryColor
                                      : context.colorScheme.onSurface,
                                  BlendMode.srcIn),
                            ),
                          ),
                          label: menu.title,
                          backgroundColor: context.colorScheme.surface,
                        ))
                    .toList()),
      ),
    );
  }
}

class BottomNavItem extends Equatable {
  final String title;
  final AbstractSolveitRoutes route;
  final String asset;

  const BottomNavItem({
    required this.title,
    required this.route,
    required this.asset,
  });

  @override
  List<Object> get props => [title, route, asset];
}
