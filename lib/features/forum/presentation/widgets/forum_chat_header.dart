import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/forum/domain/models/res/forum_chat.dart';
import 'package:solveit/features/home/presentation/pages/home_screen.dart';
import 'package:solveit/features/posts/presentation/viewmodels/inputfield_viewmodel.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/back_button.dart';

class ForumChatHeader extends StatelessWidget implements PreferredSizeWidget {
  final ForumChatModel forumChat;
  final VoidCallback? onBackPressed;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onMorePressed;
  final Function(BuildContext)? onCallPressed;

  const ForumChatHeader({
    super.key,
    required this.forumChat,
    this.onBackPressed,
    this.onSearchPressed,
    this.onMorePressed,
    this.onCallPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 300.w,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        spacing: 8.w,
        children: [
          backButton(
            context,
            onTap: onBackPressed ??
                () {
                  Navigator.pop(context);
                  context.read<InputfieldViewmodel>().clearReply();
                },
          ),
          AvatarWidget(
            avatarUrl: forumChat.forumPicUrl,
            isOnline: false,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                forumChat.title,
                style: context.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              SizedBox(
                height: 20.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 60.w,
                      child: Stack(
                        children: List.generate(
                          forumChat.avatarUrls.length < 3 ? forumChat.avatarUrls.length : 3,
                          (index) {
                            return Positioned(
                              left: (index * 18).toDouble(),
                              child: CircleAvatar(
                                radius: 8.sp,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundImage: CachedNetworkImageProvider(
                                    forumChat.avatarUrls[index],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
              InkWell(
                onTap: () => onCallPressed?.call(context),
                child: SvgPicture.asset(
                  headPhone,
                  colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
              ),
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
                        color: context.backgroundColor,
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
        GestureDetector(
          onTap: onMorePressed,
          child: SvgPicture.asset(
            moreSvg,
          ),
        ),
        SizedBox(width: 16.w),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
