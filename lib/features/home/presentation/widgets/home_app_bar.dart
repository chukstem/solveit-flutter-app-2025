import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMessageIconPressed;
  final VoidCallback onNotificationIconPressed;
  final VoidCallback onProfilePressed;
  final String avatarUrl;

  const HomeAppBar({
    super.key,
    required this.onMessageIconPressed,
    required this.onNotificationIconPressed,
    required this.onProfilePressed,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: horizontalPadding,
        child: Image.asset(solveitText),
      ),
      leadingWidth: context.getWidth() * 0.4,
      actions: [
        _buildIconButton(messageIcon, onMessageIconPressed),
        SizedBox(width: 20.w),
        _buildIconButton(notificationSvg, onNotificationIconPressed),
        SizedBox(width: 20.w),
        InkWell(
          onTap: onProfilePressed,
          child: AvatarWidget(avatarUrl: avatarUrl),
        ),
        SizedBox(width: 10.w),
      ],
    );
  }

  Widget _buildIconButton(String assetName, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: SvgPicture.asset(assetName,
          colorFilter: const ColorFilter.mode(SolveitColors.primaryColor, BlendMode.srcIn)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AvatarWidget extends StatelessWidget {
  final String avatarUrl;
  final double? size;

  const AvatarWidget({
    super.key,
    required this.avatarUrl,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final actualSize = size ?? 32.0;

    return CircleAvatar(
      radius: actualSize / 2,
      backgroundImage: NetworkImage(avatarUrl),
    );
  }
}
