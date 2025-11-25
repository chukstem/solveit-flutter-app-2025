import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';

class ForumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onAddPressed;
  final VoidCallback? onSearchPressed;

  const ForumAppBar({
    super.key,
    this.onAddPressed,
    this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SvgPicture.asset(forumsTextSvg),
      actions: [
        IconButton(
          icon: SvgPicture.asset(addSvg),
          onPressed: onAddPressed ?? () {},
        ),
        IconButton(
          icon: SvgPicture.asset(searchCircleSvg),
          onPressed: onSearchPressed ??
              () {
                context.goToScreen(SolveitRoutes.marketSearchScreen);
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
