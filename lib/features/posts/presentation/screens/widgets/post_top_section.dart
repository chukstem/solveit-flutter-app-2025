import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/home/presentation/widgets/circular_icon_button.dart';
import 'package:solveit/features/posts/presentation/viewmodels/inputfield_viewmodel.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/button/back_button.dart';
import 'package:solveit/utils/utils/string_utils.dart';
import 'package:solveit/utils/utils/utils.dart';

class PostTopSection extends StatelessWidget {
  final String title;
  final String category;
  final String timeStamp;
  final String imageUrl;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final String? isLiked;
  final String? isSaved;

  const PostTopSection({
    super.key,
    required this.title,
    required this.category,
    required this.timeStamp,
    required this.imageUrl,
    required this.onLike,
    required this.onSave,
    required this.onShare,
    this.isLiked = 'liked',
    this.isSaved = 'saved',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.getSize().height * 0.25.h,
      width: context.getWidth(),
      decoration: BoxDecoration(
        image: isImage(imageUrl)
            ? DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    SolveitColors.gradientPrimary.withValues(alpha: 0),
                    SolveitColors.gradientPrimary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: horizontalPadding,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(flex: 4),
                      backButton(context, onTap: () {
                        Navigator.pop(context);
                        context.read<InputfieldViewmodel>().clearReply();
                      }),
                      const Spacer(flex: 4),
                      _buildCategoryAndTime(context),
                      const Spacer(),
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.headlineLarge?.copyWith(
                          color: context.colorScheme.onInverseSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryAndTime(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defRadius), color: context.primaryColor),
            child: Text(
              category,
              style: context.bodySmall?.copyWith(
                fontSize: 10.sp,
                color: context.colorScheme.onInverseSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Text(
          StringUtils.formatLastActive(timeStamp),
          style: context.bodySmall?.copyWith(
            color: context.colorScheme.onInverseSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 32.h),
            child: CircularIconButton(
              isSelected: isSaved!,
              onTap: onSave,
              icon: archiveIcon,
            ),
          ),
          CircularIconButton(
            isSelected: isLiked!,
            onTap: onLike,
            icon: heartIcon,
          ),
          CircularIconButton(
            isSelected: 'default',
            onTap: onShare,
            icon: shareIcon,
          ),
        ],
      ),
    );
  }
}
