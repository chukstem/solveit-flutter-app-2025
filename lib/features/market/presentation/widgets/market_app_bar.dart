import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solveit/utils/assets/assets_manager.dart';

class MarketAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onAddPressed;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onSearchPressed;

  const MarketAppBar({
    super.key,
    this.onAddPressed,
    this.onFilterPressed,
    this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SvgPicture.asset(marketPlaceText),
      actions: [
        IconButton(
          icon: SvgPicture.asset(addSvg),
          onPressed: onAddPressed,
        ),
        IconButton(
          icon: SvgPicture.asset(filterSvg),
          onPressed: onFilterPressed,
        ),
        IconButton(
          icon: SvgPicture.asset(searchCircleSvg),
          onPressed: onSearchPressed,
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
