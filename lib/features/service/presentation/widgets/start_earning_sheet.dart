import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/hfilled_button.dart';
import 'package:solveit/utils/theme/widgets/button/houtlined_button.dart';

class StartEarningBottomSheet extends StatelessWidget {
  const StartEarningBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        spacing: 10.h,
        children: [
          SvgPicture.asset(bagButtonSvg),
          Text(
            'Start earning on Solve-IT',
            style: context.bodyLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          Text(
            'Easy way to make money as a service provider on Solve-It. Download the service provider app to start earning',
            style: context.bodySmall?.copyWith(),
            textAlign: TextAlign.center,
          ),
          Row(
            spacing: 10.w,
            children: [
              Expanded(
                child: Houtlinedbutton(
                  hasColorFilter: false,
                  text: 'App Store',
                  textColor: Colors.black,
                  borderColor: Colors.black,
                  startIcon2: appleSvg,
                ),
              ),
              Expanded(
                child: HFilledButton(
                  text: 'Playstore',
                  textColor: Colors.white,
                  startIcon2: playConsoleSvg,
                  bgColor: Colors.black,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
