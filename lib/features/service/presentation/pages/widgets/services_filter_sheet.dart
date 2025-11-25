import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/market/presentation/widgets/widgets.dart';
import 'package:solveit/features/service/presentation/viewmodels/filter.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';
import 'package:solveit/utils/theme/widgets/textfields/htext_fields.dart';

class ServicesFilterSheetContent extends StatelessWidget {
  const ServicesFilterSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ServiceFilterViewModel>();

    return Container(
      height: vm.selectedTab == ServiceFilterType.rating ? context.getHeight() * 0.65 : context.getHeight() * 0.8,
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
          Expanded(child: _buildTabContent(context, vm)),
          const SizedBox(height: 16),
          _buildBottomButton(vm),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ServiceFilterViewModel vm) {
    return Row(
      children: [
        Text("Filter Services",
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

  Widget _buildTabButtons(ServiceFilterViewModel vm) {
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

  Widget _buildSearchBar(ServiceFilterViewModel vm) {
    return HTextField(
      hint: 'Search for Location ${vm.selectedTab.name}',
    );
  }

  Widget _buildTabContent(BuildContext context, ServiceFilterViewModel vm) {
    switch (vm.selectedTab) {
      case ServiceFilterType.location:
        return _buildRadioList(vm);
      case ServiceFilterType.category:
        return _buildCategoryList(vm);
      case ServiceFilterType.rating:
        return _buildRatingList(vm);
    }
  }

  Widget _buildRadioList(
    ServiceFilterViewModel vm,
  ) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          final isSelected = vm.selectedLocations.contains(index);
          return ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () => vm.toggleLocation(index),
            trailing: Checkbox(
              value: isSelected,
              activeColor: SolveitColors.secondaryColor,
              checkColor: SolveitColors.cardColor,
              onChanged: (_) => vm.toggleLocation(index),
              shape: const CircleBorder(),
            ),
            title: Text('River State',
                style: context.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
            subtitle: Text("240 products", style: context.bodySmall?.copyWith()),
          );
        });
  }

  Widget _buildCategoryList(ServiceFilterViewModel vm) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: 10,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final isSelected = vm.selectedCategories.contains(index);

        return GestureDetector(
          onTap: () => vm.toggleCategory(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.orange : Colors.transparent,
                width: 1.8,
              ),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        'https://picsum.photos/seed/$index/80/80',
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Plumbering',
                      style: context.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '4342 services',
                      style: context.bodySmall?.copyWith(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                if (isSelected)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.check, color: Colors.white, size: 12),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingList(ServiceFilterViewModel vm) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        final stars = 5 - index;
        final isSelected = vm.selectedRatings.contains(stars);
        return ListTile(
          onTap: () => vm.toggleRating(stars),
          contentPadding: EdgeInsets.zero,
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10.w,
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
              Text('4342 products', style: context.bodySmall?.copyWith())
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

  Widget _buildBottomButton(ServiceFilterViewModel vm) {
    final active = vm.hasSelections;

    const text = "Show results";

    return HFilledButton(
      onPressed: active ? () {} : null,
      text: text,
    );
  }
}
