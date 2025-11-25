import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

class PickUpPackageChip extends StatelessWidget {
  final String? packageType;
  const PickUpPackageChip({super.key, this.packageType}) : super();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Chip(
            label: Text(
              context.getLocalization()!.pickup,
              style: context.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: context.surfaceOnBackground,
              ),
            ),
            labelPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            backgroundColor: context.colorScheme.surface,
            surfaceTintColor: context.colorScheme.surface,
            side: BorderSide.none,
            visualDensity: VisualDensity.compact.copyWith(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.w),
            ),
          ),
          if (packageType != null) ...[
            SizedBox(
              width: 20.w,
            ),
            Chip(
              label: Text(
                packageType ?? "",
                style: context.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: context.colorScheme.surfaceContainerLow,
                ),
              ),
              labelPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              backgroundColor: context.colorScheme.surface,
              surfaceTintColor: context.colorScheme.surface,
              side: BorderSide.none,
              visualDensity: VisualDensity.compact.copyWith(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.w),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
