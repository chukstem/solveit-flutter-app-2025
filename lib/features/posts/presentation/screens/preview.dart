import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:solveit/features/forum/presentation/viewmodels/forum_chat_viewmodel.dart';
import 'package:solveit/features/messages/presentation/viewmodel/chat_viewmodel.dart';
import 'package:solveit/features/messages/presentation/widgets/messages_back_button.dart';
import 'package:solveit/features/posts/presentation/viewmodels/comment_viewmodel.dart';
import 'package:solveit/features/posts/presentation/viewmodels/preview.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/solveit_theme.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/thumbnail/thumbnail.dart';
import 'package:solveit/utils/utils/utils.dart';
import 'package:universal_file_viewer/universal_file_viewer.dart' hide VideoPlayerWidget;

class MediaPreviewScreen extends StatelessWidget {
  const MediaPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaViewModel = context.watch<MediaPreviewViewModel>();
    final TextEditingController controller = TextEditingController();
    final pageController = PageController(initialPage: mediaViewModel.selectedMediaIndex);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.primary,
        leading: messagesBackButton(context, onTap: () => context.pop()),
        title: Text(
          "Media Preview",
          style: context.titleMedium!.copyWith(
            color: context.cardColor,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            itemCount: mediaViewModel.selectedMedia.length,
            controller: pageController,
            padEnds: true,
            itemBuilder: (context, index) {
              final file = mediaViewModel.selectedMedia[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  MediaPreviewItem(
                    file: file,
                    isDocument: isDocument(file),
                    isVideo: isVideo(file),
                    onRemove: () => mediaViewModel.removeMedia(index),
                  ),
                  if (!isVideo(file) && !isDocument(file))
                    if (!mediaViewModel.isFromMessagePreview)
                      Positioned(
                        left: 16.w,
                        top: 10.h,
                        child: Container(
                            padding: EdgeInsets.all(8.sp),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.7),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                                onPressed: () async {
                                  final s = await cropImage(file);
                                  if (s != null) {
                                    mediaViewModel.selectedMedia[index] = File(s.path).path;
                                  }
                                },
                                icon: Icon(
                                  Icons.crop,
                                  size: 30.sp,
                                ))),
                      )
                ],
              );
            },
          ),
          Positioned(
            bottom: 50,
            right: 0,
            left: 0,
            child: Column(
              spacing: 20.h,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...mediaViewModel.selectedMedia.map(
                        (e) => GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            pageController.animateToPage(mediaViewModel.selectedMedia.indexOf(e),
                                duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          },
                          child: SizedBox(
                            height: 80.h,
                            width: 80.h,
                            child: Padding(
                              padding: EdgeInsets.only(left: 4.w),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: isVideo(e)
                                        ? VideoThumbnailWidget(
                                            videoUrl: e,
                                          )
                                        : isDocument(e)
                                            ? const SizedBox.shrink()
                                            : Image.file(File(e), fit: BoxFit.cover),
                                  ),
                                  if (!mediaViewModel.isFromMessagePreview && !isDocument(e))
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(4.sp),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          color: Colors.black54.withValues(alpha: 0.2),
                                        ),
                                        child: InkWell(
                                            child: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.white,
                                            ),
                                            onTap: () {
                                              mediaViewModel.removeMedia(mediaViewModel.selectedMedia.indexOf(e));
                                            }),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (!mediaViewModel.isFromMessagePreview)
                  Container(
                    padding: horizontalPadding,
                    decoration: BoxDecoration(color: SolveitColors.secondaryColor400.withValues(alpha: 0.05)),
                    child: Row(
                      spacing: 20.w,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            style: context.bodySmall,
                            decoration: InputDecoration(
                                hintText: "Write a comment...",
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(defRadius),
                                    borderSide: const BorderSide(
                                      color: SolveitColors.primaryColor400,
                                      width: 0.2,
                                    )),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(defRadius),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                      width: 0.2,
                                    ))),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            switch (mediaViewModel.getPostType) {
                              case PostType.forum:
                                context.read<ForumChatViewModel>().addForumChatMessage(controller.text.trim(), mediaUrl: mediaViewModel.selectedMedia);
                                break;
                              case PostType.chat:
                                context.read<SingleChatViewModel>().addSingleChatModel(controller.text.trim(), mediaUrl: mediaViewModel.selectedMedia);

                                break;
                              case PostType.posts:
                                context
                                    .read<SinglePostCommentsViewModel>()
                                    .addSinglePostComments(controller.text.trim(), mediaUrl: mediaViewModel.selectedMedia);
                                break;
                            }
                            controller.clear();
                            context.pop();
                          },
                          child: SvgPicture.asset(sendMessageFilledSvg),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MediaPreviewItem extends StatelessWidget {
  final String file;
  final VoidCallback onRemove;
  final bool isVideo, isDocument;

  const MediaPreviewItem({super.key, required this.file, required this.onRemove, required this.isVideo, required this.isDocument});

  @override
  Widget build(BuildContext context) {
    final fileName = p.basename(file);
    final fileSize = getFileSize(file);
    return isVideo
        ? VideoPlayerWidget(videoPath: file)
        : isDocument
            ? DocumentPreview(
                fileName: fileName,
                fileSize: fileSize,
                file: file,
              )
            : Image.file(File(file), fit: BoxFit.cover);
  }
}

class DocumentPreview extends StatelessWidget {
  const DocumentPreview({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.file,
  });

  final String fileName, fileSize, file;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: UniversalFileViewer(
            filePath: file,
          ),
        ),
      ],
    );
  }
}
