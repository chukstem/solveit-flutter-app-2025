import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solveit/core/injections/market.dart';
import 'package:solveit/features/market/presentation/viewmodel/filter.dart';
import 'package:solveit/features/market/presentation/viewmodel/market_viewmodel.dart';
import 'package:solveit/features/market/presentation/widgets/widgets.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';
import 'package:solveit/utils/theme/widgets/textfields/htext_fields.dart';

class FilterSheetContent extends StatelessWidget {
  const FilterSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MarketPlaceFilterViewModel>();
    final marketVm = context.watch<MarketViewModel>();

    return Container(
      height: vm.selectedTab == FilterTab.price
          ? context.getHeight() * 0.45
          : vm.selectedTab == FilterTab.rating
              ? context.getHeight() * 0.65
              : context.getHeight() * 0.8,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context, vm),
          const SizedBox(height: 16),
          _buildTabButtons(vm),
          const SizedBox(height: 16),
          _buildSearchBar(vm),
          const SizedBox(height: 12),
          Expanded(child: _buildTabContent(context, vm, marketVm)),
          const SizedBox(height: 16),
          _buildBottomButton(context, vm),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MarketPlaceFilterViewModel vm) {
    return Row(
      children: [
        Text("Filter products",
            style: context.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            )),
        const Spacer(),
        IconButton(
            onPressed: () {
              context.pop();
              vm.clearAll();
            },
            icon: SvgPicture.asset(closeIconSvg)),
      ],
    );
  }

  Widget _buildTabButtons(MarketPlaceFilterViewModel vm) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: vm.tabs.entries
                .map(
                  (cat) => CategoryChip(
                    label: cat.value,
                    selected: vm.selectedTab == cat.key,
                    onPressed: () => vm.switchTab(cat.key),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }

  Widget _buildSearchBar(MarketPlaceFilterViewModel vm) {
    if (vm.selectedTab == FilterTab.price) return const SizedBox.shrink();
    return const HTextField(
      hint: 'Search for Location',
    );
  }

  Widget _buildTabContent(BuildContext context, MarketPlaceFilterViewModel vm, MarketViewModel marketVm) {
    switch (vm.selectedTab) {
      case FilterTab.location:
        return _buildRadioList(vm, marketVm);
      case FilterTab.category:
        return _buildCategoryList(vm, marketVm);
      case FilterTab.rating:
        return _buildRatingList(vm);
      case FilterTab.price:
        return _buildPriceRange(context, vm);
    }
  }

  Widget _buildRadioList(
    MarketPlaceFilterViewModel vm,
    MarketViewModel marketVm,
  ) {
    final locationGroups = <String, int>{};
    for (final product in vm.productsToFilter) {
      locationGroups[product.location] = (locationGroups[product.location] ?? 0) + 1;
    }

    final locations = locationGroups.entries.toList();

    return ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final location = locations[index];
          final isSelected = vm.selectedLocations.contains(location.key);
          return ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () => vm.toggleLocation(location.key),
            trailing: Checkbox(
              value: isSelected,
              activeColor: SolveitColors.secondaryColor,
              checkColor: SolveitColors.cardColor,
              onChanged: (_) => vm.toggleLocation(location.key),
              shape: const CircleBorder(),
            ),
            title: Text(location.key,
                style: context.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
            subtitle: Text("${location.value} products", style: context.bodySmall?.copyWith()),
          );
        });
  }

  Widget _buildCategoryList(MarketPlaceFilterViewModel vm, MarketViewModel marketVm) {
    final categories = marketVm.marketTags?.data ?? [];

    return ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = vm.selectedCategories.contains(category.id);
          final productCount = vm.productsToFilter.where((p) => p.marketProductTagId == category.id).length;

          return ListTile(
            onTap: () => vm.toggleCategory(category.id),
            contentPadding: EdgeInsets.zero,
            title: Text(category.name,
                style: context.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
            subtitle: Text('$productCount products', style: context.bodySmall?.copyWith()),
            trailing: Checkbox(
              value: isSelected,
              activeColor: SolveitColors.secondaryColor,
              checkColor: SolveitColors.cardColor,
              onChanged: (_) => vm.toggleCategory(category.id),
              shape: const CircleBorder(),
            ),
          );
        });
  }

  Widget _buildRatingList(MarketPlaceFilterViewModel vm) {
    final reviews = marketViewModel.marketComments?.data ?? [];
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final stars = 5 - index;
        final isSelected = vm.selectedRatings.contains(stars);
        // final review = reviews[index];
        return ListTile(
          onTap: () => vm.toggleRating(stars),
          contentPadding: EdgeInsets.zero,
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        return Icon(
                          i < stars ? Icons.star : Icons.star_border,
                          color: i < stars ? Colors.orange : Colors.grey.shade400,
                        );
                      }),
                    ],
                  ),
                  Text('$stars Stars', style: context.bodySmall?.copyWith()),
                ],
              ),
              Text('1 products', style: context.bodySmall?.copyWith())
            ],
          ),
          trailing: Checkbox(
            value: isSelected,
            activeColor: SolveitColors.secondaryColor,
            checkColor: SolveitColors.cardColor,
            onChanged: (_) => vm.toggleRating(stars),
            shape: const CircleBorder(side: BorderSide.none),
          ),
        );
      },
    );
  }

  Widget _buildPriceRange(BuildContext context, MarketPlaceFilterViewModel vm) {
    return Column(
      children: [
        RangeSlider(
          values: vm.priceRange,
          min: vm.priceRange.start,
          max: vm.priceRange.end,
          labels: RangeLabels(
            vm.priceRange.start.toStringAsFixed(2),
            vm.priceRange.end.toStringAsFixed(2),
          ),
          activeColor: SolveitColors.primaryColor,
          onChanged: vm.updatePriceRange,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _priceBox('From', vm.priceRange.start.toInt(), context),
              const SizedBox(width: 12),
              _priceBox('To', vm.priceRange.end.toInt(), context),
            ],
          ),
        )
      ],
    );
  }

  Widget _priceBox(String label, int value, BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.bodySmall?.copyWith()),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text("₦${value.toString()}", style: context.bodySmall?.copyWith()),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, MarketPlaceFilterViewModel vm) {
    final showPrice = vm.selectedTab == FilterTab.price;
    final active = showPrice || vm.hasSelections;

    final text = "Show ${vm.matchedResults} results";

    return HFilledButton(
      onPressed: active
          ? () {
              vm.applyFilters();
              context.pop();
            }
          : null,
      text: text,
    );
  }
}
