import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/market/presentation/viewmodel/market_search.dart';
import 'package:solveit/features/market/presentation/widgets/market_search.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/widgets/button/back_button.dart';
import 'package:solveit/utils/theme/widgets/textfields/htext_fields.dart';

class MarketSearchScreen extends StatelessWidget {
  const MarketSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketSearchViewModel>(
      builder: (context, viewModel, _) {
        final state = viewModel.state;

        return Scaffold(
          appBar: AppBar(
            leading: backButton(
              context,
              onTap: () => context.pop(),
            ),
            centerTitle: true,
            title: HTextField(
              hint: "Search",
              controller: viewModel.searchController,
              suffixIcon: InkWell(
                onTap: () => viewModel.clearSearch(),
                child: SvgPicture.asset(
                  closeIconSvg,
                  width: 18.w,
                ),
              ),
              onChange: (query) => viewModel.updateSearch(query),
              onSubmitted: (query) => viewModel.submitSearch(query),
            ),
          ),
          body: _buildSearchContent(context, state, viewModel),
        );
      },
    );
  }

  Widget _buildSearchContent(
      BuildContext context, MarketSearchState state, MarketSearchViewModel viewModel) {
    switch (state.state) {
      case SearchState.empty:
        return const SearchEmptyState();
      case SearchState.recent:
        return SearchRecentList(
          recent: state.recentSearches,
          onTap: (query) => viewModel.submitSearch(query),
        );
      case SearchState.results:
        return SearchResultsList(
          results: state.searchResults,
          onTap: () => context.goToScreen(SolveitRoutes.marketProductDetails),
        );
    }
  }
}
