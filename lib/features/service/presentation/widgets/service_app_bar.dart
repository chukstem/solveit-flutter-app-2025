import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solveit/features/service/presentation/pages/widgets/services_filter_sheet.dart';
import 'package:solveit/features/service/presentation/widgets/start_earning_sheet.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';

class ServiceAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onFilterPressed;
  final VoidCallback? onAddPressed;
  final VoidCallback? onSearchPressed;

  const ServiceAppBar({
    super.key,
    this.onFilterPressed,
    this.onAddPressed,
    this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SvgPicture.asset(servicesTextSvg),
      actions: [
        IconButton(
          icon: SvgPicture.asset(addSvg),
          onPressed: onAddPressed ??
              () {
                _showStartEarningSheet(context);
              },
        ),
        IconButton(
          icon: SvgPicture.asset(filterSvg),
          onPressed: onFilterPressed ??
              () {
                context.showBottomSheet(const ServicesFilterSheetContent(), isDismissible: false);
              },
        ),
        IconButton(
          icon: SvgPicture.asset(searchCircleSvg),
          onPressed: onSearchPressed ??
              () {
                context.goToScreen(SolveitRoutes.serviceSearchScreen);
              },
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

void _showStartEarningSheet(BuildContext context) {
  context.showBottomSheet(const StartEarningBottomSheet());
}
