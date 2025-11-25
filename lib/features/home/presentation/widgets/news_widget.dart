import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/posts/data/models/responses/get_categories.dart';
import 'package:solveit/features/posts/data/models/responses/get_posts.dart';
import 'package:solveit/features/posts/presentation/viewmodels/single_post.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/cards/gradient_card.dart';
import 'package:solveit/utils/theme/widgets/image/hnetwork_image.dart';
import 'package:solveit/utils/utils/utils.dart';

class Newswidget extends StatelessWidget {
  final SinglePostResponse post;
  final List<SingleCategoryResponse>? postCategory;

  const Newswidget({super.key, required this.post, required this.postCategory});

  @override
  Widget build(BuildContext context) {
    String postCategoryName = (postCategory != null && postCategory!.isNotEmpty)
        ? postCategory?.firstWhere((e) => e.id == post.newsCategoryId).name ?? "Unknown Category"
        : "Unknown";
    return Padding(
      padding: horizontalPadding.copyWith(bottom: 15.h),
      child: InkWell(
        onTap: () async {
          context.read<SinglePostViewModel>().setCurrentPost(post, postCategoryName);
          context.goToScreen(
            SolveitRoutes.singlePostScreen,
          );
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.w),
              child: Hnetworkimage(
                image: isImage(post.media) ? post.media : "https://i.pravatar.cc/300",
                width: context.getWidth() * 0.25,
                fit: BoxFit.cover,
                height: context.getWidth() * 0.2,
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: GradientCard(
                      color: SolveitColors.secondaryColor300,
                      children: Text(postCategoryName, style: context.bodySmall?.copyWith(color: context.primaryColor, fontSize: 10.sp)),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    post.title.isNotEmpty ? post.title : "No title available",
                    style: context.bodySmall,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
