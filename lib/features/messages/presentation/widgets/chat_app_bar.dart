import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solveit/features/messages/domain/models/responses/chat.dart';
import 'package:solveit/features/messages/presentation/widgets/avatar_widget.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/back_button.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SingleChatModel chat;
  final VoidCallback onBackPressed;
  final VoidCallback? onCallPressed;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onMorePressed;

  const ChatAppBar({
    super.key,
    required this.chat,
    required this.onBackPressed,
    this.onCallPressed,
    this.onSearchPressed,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 200.w,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        spacing: 8.w,
        children: [
          backButton(
            context,
            onTap: onBackPressed,
          ),
          AvatarWidget(
            avatarUrl: chat.avatarUrl,
            isOnline: chat.isOnline,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(chat.name, style: context.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
              Row(
                children: [
                  Text(chat.type, style: context.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                  if (chat.isVerified ?? false) SvgPicture.asset(verifiedSvg)
                ],
              )
            ],
          )
        ],
      ),
      actions: [
        SizedBox(
          height: 50.h,
          width: 50.w,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              SvgPicture.asset(headPhone,
                  colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn)),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: SolveitColors.errorColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "2",
                      style: context.headlineSmall!.copyWith(
                        fontSize: 10,
                        color: context.cardColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        InkWell(
          onTap: onSearchPressed,
          child: SvgPicture.asset(
            searchIcon,
          ),
        ),
        SizedBox(width: 16.w),
        InkWell(
          onTap: onMorePressed,
          child: SvgPicture.asset(
            moreSvg,
          ),
        ),
        SizedBox(width: 16.w),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
