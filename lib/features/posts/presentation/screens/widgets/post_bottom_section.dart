import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/posts/presentation/screens/comment_card.dart';
import 'package:solveit/features/posts/presentation/screens/widgets/comment.dart';
import 'package:solveit/features/posts/presentation/viewmodels/comment_viewmodel.dart';
import 'package:solveit/features/posts/presentation/viewmodels/single_post.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/layouts/scollable_column.dart';

final GlobalKey _latestCommentKey = GlobalKey();

class PostBottomSection extends StatefulWidget {
  final String postDetails;
  final SinglePostViewModel viewModel;
  final int postId;

  const PostBottomSection({
    super.key,
    required this.postDetails,
    required this.viewModel,
    required this.postId,
  });

  @override
  State<PostBottomSection> createState() => _PostBottomSectionState();
}

class _PostBottomSectionState extends State<PostBottomSection> {
  @override
  void initState() {
    super.initState();
    context.read<SinglePostCommentsViewModel>().setComments(List.from(widget.viewModel.comments));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scrollToLatestComment();
  }

  void scrollToLatestComment() {
    if (_latestCommentKey.currentContext != null) {
      Scrollable.ensureVisible(
        _latestCommentKey.currentContext!,
        alignment: 1.0, // Align to bottom of viewport
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SinglePostCommentsViewModel>();
    return Expanded(
      child: Container(
        width: context.getWidth(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(defRadius),
            topRight: Radius.circular(defRadius),
          ),
          color: context.cardColor,
        ),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              _buildTabBar(context, viewModel),
              Expanded(
                child: Container(
                  color: SolveitColors.primaryColor300,
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildDetailsTab(context),
                      _buildCommentsTab(viewModel),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, SinglePostCommentsViewModel viewModel) {
    return Padding(
      padding: horizontalPadding,
      child: TabBar(
        labelPadding: const EdgeInsets.symmetric(vertical: 0),
        dividerColor: SolveitColors.primaryColor200,
        dividerHeight: 0.2,
        indicatorWeight: 0.1,
        onTap: (value) {
          scrollToLatestComment();
        },
        tabs: [
          Tab(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                context.getLocalization()!.post_details,
                style: context.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Tab(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                context.getLocalization()!.comments_count(
                      viewModel.comments.length.toString(),
                    ),
                style: context.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab(BuildContext context) {
    return Padding(
      padding: horizontalPadding.copyWith(top: 8.h),
      child: HScollableColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.postDetails, style: context.bodySmall),
        ],
      ),
    );
  }

  Widget _buildCommentsTab(SinglePostCommentsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: AnimatedList(
            key: viewModel.listKey,
            controller: viewModel.scrollController,
            padding: horizontalPadding.copyWith(
              top: 8.h,
              bottom: context.getBottomInsets(),
            ),
            initialItemCount: viewModel.comments.length,
            itemBuilder: (context, index, animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: CommentCard(
                  key: index == viewModel.comments.length - 1 ? _latestCommentKey : null,
                  comment: viewModel.comments[index],
                ),
              );
            },
          ),
        ),
        CommentInput(
          sendComment: (comment, isAudio, replyingTo) async {
            final res = await context
                .read<SinglePostCommentsViewModel>()
                .addSinglePostComments(comment, isAudio: isAudio);

            if (res) {
              scrollToLatestComment();
            } else if (mounted) {
              context.showError('Could not send comment');
            }
          },
        ),
      ],
    );
  }
}
