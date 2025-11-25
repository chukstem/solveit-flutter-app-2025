import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/home/presentation/pages/home_screen.dart';
import 'package:solveit/features/market/presentation/viewmodel/details.dart';
import 'package:solveit/features/market/presentation/viewmodel/report_viewmodel.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/back_button.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';
import 'package:solveit/utils/utils/string_utils.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductDetailViewModel>();

    return Scaffold(
      bottomNavigationBar: const Padding(padding: EdgeInsets.all(16), child: HFilledButton(text: 'Message vendor')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainImageSection(vm, context),
            _buildImagePreviewRow(vm),
            _buildProductHeader(context, vm),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    dividerColor: SolveitColors.primaryColor300,
                    indicatorColor: SolveitColors.primaryColor,
                    labelPadding: EdgeInsets.zero,
                    indicatorWeight: 0.1,
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelStyle: context.bodySmall?.copyWith(),
                    labelStyle: context.bodySmall?.copyWith(color: SolveitColors.primaryColor),
                    tabs: [
                      const Tab(text: 'Product details'),
                      Tab(
                          child: Row(children: [
                        Text('Reviews(${vm.reviews.length})'),
                        const Icon(
                          Icons.star,
                          color: SolveitColors.secondaryColor,
                        ),
                        const Text('Stars'),
                      ])),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      children: [
                        _buildDetailsTab(vm),
                        _buildReviewsTab(vm),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildMainImageSection(ProductDetailViewModel vm, BuildContext context) {
    String selectedAction = '';
    final product = vm.currentProduct;
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: product!.images is List<String> ? (product.images as List<String>).length : vm.images.length,
          carouselController: vm.carouselController,
          options: CarouselOptions(
            height: 220.h,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            onPageChanged: vm.onCarouselChanged,
          ),
          itemBuilder: (_, index, __) {
            return Stack(
              children: [
                Image.network(
                  product.images is List<String> ? product.images[index] : vm.images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Center(
                  child: SizedBox(
                    height: 40,
                    child: Opacity(
                      opacity: 0.3,
                      child: Image.asset(
                        solveitText,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        Positioned(
          top: 60.h,
          left: 10.w,
          right: 16.w,
          child: Opacity(
            opacity: 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                backButton(context),
                GestureDetector(
                  onTap: () {
                    _showActionsOnProduct(context, selectedAction);
                  },
                  child: SvgPicture.asset(
                    moreSvg,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showActionsOnProduct(BuildContext context, String selectedAction) {
    context.showBottomSheet(StatefulBuilder(builder: (context, setState) {
      return Column(
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
          for (final actions in {
            const Icon(Icons.flag_circle_rounded): "Report Product",
            const Icon(Icons.flag): "Report Seller",
            const Icon(Icons.block): "Stop seeing this seller's product",
          }.entries)
            GestureDetector(
                onTap: () {
                  selectedAction = actions.value;
                  if (actions.value == "Report Product") {
                    context.read<ReportViewModel>().initialize(vendor: false);
                    context.goToScreen(SolveitRoutes.reportProductOrVendor);
                  } else if (actions.value == "Report Seller") {
                    context.read<ReportViewModel>().initialize(vendor: true);
                    context.goToScreen(SolveitRoutes.reportProductOrVendor);
                  } else {}
                  setState(() {});
                  context.pop();
                  selectedAction = '';
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                    decoration: BoxDecoration(
                        color: selectedAction == actions.value ? SolveitColors.secondaryColor300 : Colors.transparent, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 10.w,
                      children: [
                        actions.key,
                        Text(
                          actions.value,
                          style: context.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ))),
        ],
      );
    }), isDismissible: false);
  }

  Widget _buildImagePreviewRow(ProductDetailViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 60,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: vm.images.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final isSelected = index == vm.selectedImageIndex;
            return GestureDetector(
              onTap: () => vm.selectImage(index),
              child: Container(
                width: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? Colors.orange : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    vm.images[index],
                    fit: BoxFit.cover,
                    width: 80.w,
                    height: 20.h,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductHeader(BuildContext context, ProductDetailViewModel vm) => Padding(
        padding: horizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(vm.currentProduct!.title,
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: SolveitColors.secondaryColor, shape: BoxShape.circle),
                    child: SvgPicture.asset(shareIcon))
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('NGN ${vm.currentProduct!.amount}', style: context.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: SolveitColors.primaryColor)),
                Row(
                  spacing: 6,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AvatarWidget(
                      avatarUrl: vm.currentProduct!.id.toString(),
                      radius: 12,
                      isOnline: true,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.goToScreen(SolveitRoutes.vendorProfile);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text("View store", style: context.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 10)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoChip(Icons.location_on, vm.currentProduct!.location, context, isLocation: true),
                _infoChip(Icons.access_time, StringUtils.formatLastActive(vm.currentProduct!.createdAt), context),
                _infoChip(Icons.remove_red_eye_outlined, '', context),
              ],
            ),
          ],
        ),
      );

  Widget _infoChip(IconData icon, String label, BuildContext context, {bool? isLocation = false}) => Container(
        padding: EdgeInsets.only(left: 6.w, right: isLocation! ? 40.w : 20.w, top: 2.h, bottom: 2.h),
        decoration: BoxDecoration(
          color: SolveitColors.primaryColor300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 12.sp, color: Colors.grey),
            const SizedBox(width: 4),
            Text(label, style: context.bodySmall?.copyWith(fontSize: 10)),
          ],
        ),
      );

  Widget _buildDetailsTab(ProductDetailViewModel vm) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(vm.currentProduct!.description),
            const SizedBox(height: 16),
            const Text("Specifications", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 4),
          ],
        ),
      );

  Widget _buildReviewsTab(ProductDetailViewModel vm) => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        // shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemCount: vm.reviews.length,
        itemBuilder: (context, index) {
          final review = vm.reviews[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AvatarWidget(
                  avatarUrl: "https://picsum.photos/200",
                  radius: 15,
                  isOnline: true,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    spacing: 3.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(review.id.toString(), style: context.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Row(
                            children: List.generate(5, (i) => const Icon(Icons.star, size: 14, color: Colors.orange)),
                          ),
                          const SizedBox(width: 4),
                          Text("5 Stars", style: context.bodySmall?.copyWith(color: Colors.orange, fontSize: 12)),
                        ],
                      ),
                      Text(
                        review.body,
                        style: context.bodySmall,
                      ),
                      Text(review.createdAt, style: context.bodySmall?.copyWith(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
}
