import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:solveit/core/injections/posts.dart';
import 'package:solveit/features/home/presentation/pages/home_screen.dart';
import 'package:solveit/features/posts/data/models/responses/responses.dart';
import 'package:solveit/features/posts/presentation/screens/wave.dart';
import 'package:solveit/features/posts/presentation/screens/widgets/comment.dart';
import 'package:solveit/features/posts/presentation/screens/widgets/media_preview_widgets.dart';
import 'package:solveit/features/posts/presentation/screens/widgets/swipe.dart';
import 'package:solveit/features/posts/presentation/viewmodels/comment_viewmodel.dart';
import 'package:solveit/features/posts/presentation/viewmodels/inputfield_viewmodel.dart';
import 'package:solveit/features/posts/presentation/viewmodels/preview.dart';
import 'package:solveit/features/posts/presentation/viewmodels/single_post.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/utils/string_utils.dart';
import 'package:solveit/utils/utils/utils.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;

  const CommentCard({super.key, required this.comment});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> with SingleTickerProviderStateMixin {
  bool showReplies = false;
  int displayedReplies = 3;
  @override
  void initState() {
    singlePostViewModel.getCommentReplies(widget.comment.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final singlepostModel = context.read<SinglePostViewModel>();
    final comment = widget.comment;

    return Column(
      children: [
        if (showReplies)
          GestureDetector(
            onTap: () {
              setState(() {
                showReplies = !showReplies;
              });
            },
            child: Row(
              spacing: 5.w,
              children: [
                const Icon(Icons.chevron_left),
                Text.rich(
                  TextSpan(
                    text: 'replies ',
                    style: context.bodySmall?.copyWith(fontWeight: FontWeight.w400),
                    children: [
                      TextSpan(
                        text: singlepostModel.commentReplies.length.toString(),
                        style: context.bodySmall?.copyWith(fontWeight: FontWeight.w200, fontSize: 9),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: SwipeToReplyWidget(
            onReply: () {
              context.read<SinglePostCommentsViewModel>().setCurrentId(comment.id);
              _handleReply(context, comment);
            },
            isSender: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AvatarWidget(
                    avatarUrl: '',
                    isOnline: Random().nextBool(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      spacing: 5.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: SolveitColors.primaryColor400,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(defRadius),
                              topRight: Radius.circular(defRadius),
                              bottomRight: Radius.circular(defRadius),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (comment.images is List && comment.images.isNotEmpty)
                                isAudio(comment.images.first)
                                    ? WaveBubble(isSender: false, width: context.getWidth() * 0.5, path: comment.images.first)
                                    : GestureDetector(
                                        onTap: () {
                                          context.read<MediaPreviewViewModel>().addMedia(comment.images, isFromComment: true);
                                          context.goToScreen(SolveitRoutes.previewSelectedMediaScreen);
                                        },
                                        child: MediaGrid(
                                          mediaFiles: comment.images,
                                          onOpen: (o) {},
                                          onSave: (s) {},
                                        ),
                                      ),
                              Text(
                                comment.id.toString(),
                                style: context.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              if (comment.body.isNotEmpty) ReadMoreText(text: comment.body),
                            ],
                          ),
                        ),
                        Row(
                          spacing: 20.w,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(StringUtils.formatLastActive((comment.createdAt)), style: context.bodySmall?.copyWith(fontSize: 10)),
                            Row(
                              spacing: 5.w,
                              children: [
                                InkWell(
                                  child: singlepostModel.reactions.isNotEmpty ? SvgPicture.asset(thumbsUpFilledSvg) : SvgPicture.asset(thumbsUpPlainSvg),
                                  // onTap: () => context.read<SinglePostCommentsViewModel>().toggleLike(widget.comments[widget.index]),
                                ),
                                Text(singlepostModel.reactions.isEmpty ? 'Like' : singlepostModel.reactions.length.toString(),
                                    style: context.bodySmall?.copyWith(fontSize: 10)),
                              ],
                            ),
                            Row(
                              spacing: 5.w,
                              children: [
                                InkWell(
                                    child: singlepostModel.commentReplies.isNotEmpty ? SvgPicture.asset(commentFilledSvg) : SvgPicture.asset(commentPlainSvg),
                                    onTap: () {
                                      setState(() {
                                        showReplies = !showReplies;
                                        // widget.scrollToComment!();
                                      });
                                    }),
                                Text(singlepostModel.commentReplies.isEmpty ? 'Reply' : singlepostModel.commentReplies.length.toString(),
                                    style: context.bodySmall?.copyWith(fontSize: 10)),
                              ],
                            ),
                          ],
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: showReplies
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(children: [
                                    ...List.generate(
                                      singlepostModel.commentReplies.length > displayedReplies ? displayedReplies : singlepostModel.commentReplies.length,
                                      (replyIndex) => SubCommentCard(
                                        index: replyIndex,
                                        replies: singlepostModel.commentReplies,
                                      ),
                                    ),
                                    if (singlepostModel.commentReplies.length > displayedReplies)
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            displayedReplies += 2;
                                          });
                                        },
                                        child: Text('Load more replies', style: context.bodySmall),
                                      ),
                                  ]),
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleReply(BuildContext context, Comment comment) {
    context.read<InputfieldViewmodel>().setReply(
        ReplyingTo(comment: comment.body, name: comment.id.toString(), type: comment.images is List && comment.images.isNotEmpty ? comment.images : []));
  }
}
