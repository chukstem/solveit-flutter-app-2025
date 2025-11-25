import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/market/presentation/viewmodel/market_search.dart';
import 'package:solveit/features/market/presentation/widgets/market_search.dart';
import 'package:solveit/features/service/presentation/viewmodels/service_search.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/widgets/button/back_button.dart';
import 'package:solveit/utils/theme/widgets/textfields/htext_fields.dart';

class ServiceSearchScreen extends StatefulWidget {
  const ServiceSearchScreen({super.key});

  @override
  State<ServiceSearchScreen> createState() => _ServiceSearchScreenState();
}

class _ServiceSearchScreenState extends State<ServiceSearchScreen> {
  @override
  Widget build(BuildContext context) {
    final searchVM = context.watch<ServiceSearchViewModel>();
    return Scaffold(
        appBar: AppBar(
          leading: backButton(
            context,
            onTap: () {
              context.pop();
            },
          ),
          centerTitle: true,
          title: HTextField(
            hint: "Search",
            controller: searchVM.searchController,
            suffixIcon: InkWell(
              onTap: () => searchVM.clearSearch(),
              child: SvgPicture.asset(
                closeIconSvg,
                width: 18.w,
              ),
            ),
            onChange: (p0) {
              searchVM.updateSearch(p0);
            },
            onSubmitted: (p0) {
              searchVM.submitSearch(p0);
            },
          ),
        ),
        body: (searchVM.state == SearchState.results)
            ? SearchResultsList(
                results: searchVM.searchResults,
                onTap: () {
                  context.goToScreen(SolveitRoutes.serviceDetailsScreen);
                },
              )
            : (searchVM.state == SearchState.recent)
                ? SearchRecentList(
                    recent: searchVM.recentSearches,
                    onTap: (p0) {
                      context.read<ServiceSearchViewModel>().submitSearch(p0);
                    },
                  )
                : const SearchEmptyState());
  }
}
