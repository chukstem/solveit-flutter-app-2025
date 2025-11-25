import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/home/presentation/pages/home_screen.dart';
import 'package:solveit/features/market/presentation/viewmodel/vendor_profile.dart';
import 'package:solveit/features/market/presentation/widgets/widgets.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/back_button.dart';

class ReviewsScreenContent extends StatelessWidget {
  const ReviewsScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = context.watch<VendorViewModel>().reviews;
    final filterVM = context.watch<ReviewFilterViewModel>();
    final textTheme = context;

    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: Text(
          "Reviews",
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _filterChips(context, filterVM),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: reviews.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final r = reviews[index];
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      spacing: 10.w,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AvatarWidget(
                          avatarUrl: r['avatar'],
                          radius: 12.sp,
                          isOnline: true,
                          hasRing: true,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(r['name'], style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.orange, size: 16),
                                      Text(" 5 Stars", style: textTheme.bodySmall?.copyWith(color: Colors.orange)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                r['text'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              Text(r['date'], style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _filterChips(BuildContext context, ReviewFilterViewModel vm) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: vm.filters.map((filter) {
          final selected = filter == vm.selectedFilter;
          return CategoryChip(
            label: filter,
            selected: selected,
            onPressed: () => vm.setFilter(filter),
          );
        }).toList(),
      ),
    );
  }
}
