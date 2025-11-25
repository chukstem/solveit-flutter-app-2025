import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/home/presentation/pages/home_screen.dart';
import 'package:solveit/features/market/presentation/viewmodel/report_viewmodel.dart';
import 'package:solveit/features/market/presentation/viewmodel/vendor_profile.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/back_button.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';

class VendorProfileContent extends StatelessWidget {
  const VendorProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VendorViewModel>();
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () => _showMoreOptions(context),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: HFilledButton(
          onPressed: () {},
          text: "Message vendor",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(context, vm),
            const SizedBox(height: 16),
            _buildInfoRow(context),
            const SizedBox(height: 24),
            _sectionHeader(context, "Listed products"),
            const SizedBox(
              height: 10,
            ),
            vm.hasProducts
                ? _horizontalProductList(context, vm)
                : _emptyBox(context, "This vendor has not listed product", Icons.store_mall_directory_outlined),
            const SizedBox(height: 24),
            _sectionHeader(context, "Customer reviews"),
            const SizedBox(height: 10),
            vm.hasReviews ? _horizontalReviews(context, vm) : _emptyBox(context, "No reviews", Icons.star_border),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, VendorViewModel vm) {
    final textTheme = context;
    return Column(
      children: [
        AvatarWidget(
          avatarUrl: vm.reviews.first['avatar'],
          radius: 40,
          isOnline: true,
          hasRing: true,
          hasVerified: true,
        ),
        const SizedBox(height: 8),
        Text(
          vm.name,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          vm.location,
          style: textTheme.bodySmall?.copyWith(),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final menu in {
          const Icon(
            Icons.store,
            size: 15,
          ): "17 Products",
          const Icon(
            Icons.star,
            size: 15,
            color: SolveitColors.secondaryColor,
          ): "5 Ratings",
          const Icon(
            Icons.calendar_today,
            size: 15,
          ): "Joined 28 March, 2024",
        }.entries)
          Card(
            elevation: 0.2,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                spacing: 3.w,
                children: [menu.key, Text(menu.value, style: context.bodySmall?.copyWith(fontSize: 10))],
              ),
            ),
          ),
      ],
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    final textTheme = context;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: () => context.goToScreen(SolveitRoutes.vendorReview),
          child: Text("View all", style: textTheme.bodySmall?.copyWith()),
        ),
      ],
    );
  }

  Widget _horizontalProductList(BuildContext context, VendorViewModel vm) {
    final textTheme = context;
    return SizedBox(
      height: 190.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: vm.products.length,
        itemBuilder: (_, i) {
          final p = vm.products[i];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defRadius)),
            margin: EdgeInsets.only(right: 10, bottom: 10.h),
            child: SizedBox(
              width: 150.w,
              child: Column(
                spacing: 10.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100.h,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(defRadius), topRight: Radius.circular(defRadius)),
                      child: CachedNetworkImage(imageUrl: p['image']!, fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p['price']!, style: textTheme.bodySmall?.copyWith(color: Colors.purple)),
                        Text(
                          p['title']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall,
                        ),
                        Text(p['location']!, style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _horizontalReviews(BuildContext context, VendorViewModel vm) {
    final textTheme = context;
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: vm.reviews.length,
        itemBuilder: (_, i) {
          final r = vm.reviews[i];
          return Container(
            width: context.getWidth() * 0.75,
            margin: const EdgeInsets.only(right: 12),
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
                  avatarUrl: vm.reviews.first['avatar'],
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
    );
  }

  Widget _emptyBox(BuildContext context, String label, IconData icon) {
    final textTheme = context;
    return Container(
      height: 120,
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 30, color: Colors.grey),
            const SizedBox(height: 6),
            Text(label, style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    context.showBottomSheet(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Actions',
                    style: context.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(onTap: () => context.pop(), child: SvgPicture.asset(closeIconSvg)),
                ],
              ),
            ),
            _sheetTile(context, "View personal profile", Icons.person, () {}),
            _sheetTile(context, "Share shop profile", Icons.share, () {}),
            _sheetTile(context, "Report vendor", Icons.flag, () {
              context.read<ReportViewModel>().initialize(vendor: true);
              context.pop();
              context.goToScreen(SolveitRoutes.reportProductOrVendor);
            }),
            _sheetTile(context, "Block vendor", Icons.block, () {}),
          ],
        ),
        isDismissible: false);
  }

  Widget _sheetTile(BuildContext context, String text, IconData icon, VoidCallback onTap) {
    final textTheme = context;
    return ListTile(
      leading: Icon(icon),
      title: Text(text, style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
      onTap: onTap,
    );
  }
}
