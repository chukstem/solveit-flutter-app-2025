import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/cards/gradient_card.dart';
import 'package:solveit/utils/extensions.dart';

class LocationRowWidget extends StatelessWidget {
  final String icon;
  final String location;
  final Color? color;
  final bool pickedup;

  const LocationRowWidget({super.key, required this.icon, required this.location, this.color, this.pickedup = true}) : super();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GradientCard(
          color: color,
          shape: BoxShape.circle,
          children: Padding(
            padding: EdgeInsets.all(2.w),
            child: SvgPicture.asset(
              icon,
              width: 25.w,
              height: 25.h,
              colorFilter: const ColorFilter.mode(SolveitColors.textColor, BlendMode.srcIn),
            ),
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pickedup ? context.getLocalization()!.pickup_location : context.getLocalization()!.delivery_location,
                textAlign: TextAlign.start,
                style: context.bodySmall,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                location,
                style: context.labelMedium,
              ),
            ],
          ),
        )
      ],
    );
  }
}
