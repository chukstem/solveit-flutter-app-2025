import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/home/presentation/pages/home_screen.dart';
import 'package:solveit/features/market/presentation/viewmodel/report_viewmodel.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReportViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            spacing: 10.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(onTap: () => Navigator.pop(context), child: SvgPicture.asset(closeIconSvg)),
              Text(
                vm.isVendor ? "Report vendor" : "Report product",
                style: context.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 4),
              Text(
                  vm.isVendor
                      ? "Have you noticed any uncultured activities about this seller? Give us a detailed report"
                      : "We'll take immediate action in investigating this product based on the product details.",
                  style: context.bodySmall?.copyWith()),
              const SizedBox(height: 16),
              vm.isVendor ? _vendorInfo(context) : _productCard(context),
              const SizedBox(height: 16),
              _inputField(context, "Report subject", vm.subjectController, vm.onChanged),
              const SizedBox(height: 12),
              _inputField(context, "Message", vm.messageController, vm.onChanged, maxLines: 5),
              Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Make sure you give accurate information",
                      style: context.bodySmall?.copyWith(color: SolveitColors.secondaryColor),
                    ),
                  )
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: HFilledButton(
                  onPressed: vm.canSubmit ? () {} : null,
                  enabled: vm.canSubmit,
                  text: "Submit report",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(BuildContext context, String hint, TextEditingController controller, VoidCallback onChanged, {int maxLines = 1}) {
    return SizedBox(
      height: maxLines == 1 ? 40.h : null,
      child: TextField(
        controller: controller,
        onChanged: (_) => onChanged(),
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: context.bodySmall?.copyWith(),
          filled: true,
          fillColor: SolveitColors.primaryColor400,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _productCard(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            child: Image.network('https://picsum.photos/200/300', width: 80.w, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("₦1,200", style: context.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: SolveitColors.primaryColor)),
                  Text("Title of the product...",
                      overflow: TextOverflow.ellipsis,
                      style: context.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
                  Text("Enugu", style: context.bodySmall?.copyWith()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vendorInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 10,
            children: [
              const AvatarWidget(avatarUrl: 'https://picsum.photos/200/300', isOnline: false),
              Text("Arlene McCoy", style: context.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              Row(
                children: List.generate(5, (i) => const Icon(Icons.star, size: 14, color: Colors.orange)),
              ),
              Text(" 5 Stars", style: context.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
