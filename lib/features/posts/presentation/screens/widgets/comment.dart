import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/home/presentation/pages/home_screen.dart';
import 'package:solveit/features/posts/data/models/responses/get_replies.dart';
import 'package:solveit/features/posts/domain/models/response/message_type.dart';
import 'package:solveit/features/posts/presentation/screens/widgets/voice_message_widget.dart';
import 'package:solveit/features/posts/presentation/viewmodels/inputfield_viewmodel.dart';
import 'package:solveit/features/posts/presentation/viewmodels/preview.dart';
import 'package:solveit/features/posts/presentation/viewmodels/record.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/utils/string_utils.dart';
import 'package:solveit/utils/utils/utils.dart';

class CommentInput extends StatefulWidget {
  const CommentInput({
    super.key,
    required this.sendComment,
    this.padding,
  });
  final Future<void> Function(String, bool, ReplyingTo?) sendComment;
  final EdgeInsetsGeometry? padding;
  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final recordViewModel = context.watch<RecordingViewModel>();
    final replyToViewModel = context.watch<InputfieldViewmodel>();
    final replyTo = replyToViewModel.replyingTo;
    return Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(defRadius),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: recordViewModel.recordingState != RecordingState.finished
              ? VoiceRecorderWidget(
                  onFinish: (s) async {
                    log('This is the path: $s');
                    await widget.sendComment(
                      s.path,
                      true,
                      replyTo,
                    );
                    replyToViewModel.setReply(null);
                  },
                )
              : Padding(
                  padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 5.h, bottom: 16.h),
                  child: Column(
                    children: [
                      Consumer<InputfieldViewmodel>(builder: (context, value, child) {
                        return value.replyingTo != null
                            ? Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 6.h),
                                padding: EdgeInsets.only(left: 3.w),
                                decoration: BoxDecoration(
                                  color: SolveitColors.primaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4),
                                  decoration: BoxDecoration(color: SolveitColors.primaryColor300, borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        spacing: 5.h,
                                        children: [
                                          Text(
                                            value.replyingTo!.name,
                                            style: context.bodySmall?.copyWith(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (value.replyingTo!.comment != null && value.replyingTo!.comment!.isNotEmpty)
                                            Text(
                                              value.replyingTo!.comment!.length > 50
                                                  ? '${value.replyingTo!.comment!.substring(0, 50)}...'
                                                  : value.replyingTo!.comment!,
                                              style: context.bodySmall?.copyWith(fontSize: 8),
                                            ),
                                          if (value.replyingTo!.type.isNotEmpty)
                                            Row(
                                              spacing: 5.w,
                                              children: [
                                                SvgPicture.asset(
                                                  isDocument(value.replyingTo!.type.first) ? documentSvg : replyPhoto,
                                                ),
                                                if (value.replyingTo!.type.isNotEmpty)
                                                  Text(
                                                    _getMediaTypeLabel(value.replyingTo!.type),
                                                    style: context.bodySmall?.copyWith(fontSize: 10),
                                                  ),
                                              ],
                                            ),
                                        ],
                                      ),
                                      InkWell(
                                          onTap: () {
                                            value.setReply(null);
                                          },
                                          child: Icon(
                                            Icons.cancel_rounded,
                                            size: 12.sp,
                                            color: Colors.white,
                                          )),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 20,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: GestureDetector(
                                onTap: () {
                                  context.showBottomSheet(
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        spacing: 5.h,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 20.h, left: 14.w),
                                            child: Text(
                                              'Add Attachment',
                                              style: context.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 0.2,
                                          ),
                                          ListTile(
                                            onTap: () => handleMediaSelection(context, MessageType.camera),
                                            leading: const Icon(
                                              Icons.camera_alt,
                                              color: SolveitColors.primaryColor,
                                            ),
                                            title: Text('Camera', style: context.bodySmall),
                                          ),
                                          ListTile(
                                            onTap: () => handleMediaSelection(context, MessageType.gallery),
                                            leading: const Icon(
                                              Icons.photo_library_rounded,
                                              color: SolveitColors.primaryColor,
                                            ),
                                            title: Text('Gallery', style: context.bodySmall),
                                          ),
                                          ListTile(
                                            onTap: () => handleMediaSelection(context, MessageType.file),
                                            leading: const Icon(
                                              Icons.file_open,
                                              color: SolveitColors.primaryColor,
                                            ),
                                            title: Text('File', style: context.bodySmall),
                                          ),
                                          ListTile(
                                            onTap: () => handleMediaSelection(context, MessageType.audio),
                                            leading: const Icon(
                                              Icons.audiotrack_outlined,
                                              color: SolveitColors.primaryColor,
                                            ),
                                            title: Text('Audio', style: context.bodySmall),
                                          ),
                                        ],
                                      ),
                                      maxHeightFactor: 0.5);
                                },
                                child: SvgPicture.asset(addAttachmentSvg)),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              style: context.bodySmall,
                              onChanged: (s) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: SolveitColors.primaryColor100,
                                    ),
                                  ),
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
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: InkWell(
                              onTap: () async {
                                if (recordViewModel.recordingState == RecordingState.finished && _controller.text.isEmpty) {
                                  recordViewModel.startRecording(refresh: true);
                                } else {
                                  await widget.sendComment(
                                    _controller.text,
                                    false,
                                    replyTo,
                                  );
                                  _controller.clear();
                                  replyToViewModel.setReply(null);
                                }
                              },
                              child: _controller.text.isEmpty ? SvgPicture.asset(recordVNSvg) : SvgPicture.asset(sendMessageFilledSvg),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ));
  }

  String _getMediaTypeLabel(List<String> types) {
    final count = types.length > 1 ? 's' : ''; // Pluralization
    if (isVideo(types.first)) return 'Video$count';
    if (isAudio(types.first)) return 'Audio$count';
    if (isDocument(types.first)) return 'Document$count';
    return 'Image$count';
  }

  Future<void> handleMediaSelection(BuildContext context, MessageType type) async {
    context.pop();
    List<String>? selectedFiles;
    context.read<MediaPreviewViewModel>().clearMedia();

    switch (type) {
      case MessageType.camera:
        final file = await pickImage(source: ImageSource.camera, shouldCrop: false);
        if (file != null) selectedFiles = [file.path];
        break;

      case MessageType.gallery:
        final files = await pickMultipleMedia();
        if (files != null) selectedFiles = files;
        break;

      case MessageType.file:
        selectedFiles = await pickDocuments();
        break;

      case MessageType.audio:
        selectedFiles = await pickAudioFiles();
        break;

      default:
        return;
    }

    if (context.mounted && selectedFiles != null && selectedFiles.isNotEmpty) {
      context.read<MediaPreviewViewModel>().addMedia(selectedFiles);
      context.read<MediaPreviewViewModel>().selectedMediaIndex = 0;
      context.goToScreen(SolveitRoutes.previewSelectedMediaScreen);
    }
  }
}

class ReadMoreText extends StatefulWidget {
  final String text;
  final int maxLength;
  final Color? textColor;

  const ReadMoreText({
    super.key,
    required this.text,
    this.maxLength = 50,
    this.textColor,
  });

  @override
  State<ReadMoreText> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    bool shouldTruncate = widget.text.length > widget.maxLength;
    return Text.rich(
      TextSpan(
        text: isExpanded || !shouldTruncate ? widget.text : "${widget.text.substring(0, widget.maxLength)}...",
        style: context.bodySmall?.copyWith(fontSize: 10, color: widget.textColor),
        children: [
          if (shouldTruncate)
            TextSpan(
              text: isExpanded ? " Read Less" : " Read More",
              style: context.bodySmall?.copyWith(fontSize: 10, color: widget.textColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
            ),
        ],
      ),
    );
  }
}

class SubCommentCard extends StatefulWidget {
  final int index;
  final List<Reply> replies;

  const SubCommentCard({super.key, required this.index, required this.replies});

  @override
  State<SubCommentCard> createState() => _SubCommentCardState();
}

class _SubCommentCardState extends State<SubCommentCard> {
  @override
  Widget build(BuildContext context) {
    final comment = widget.replies[widget.index];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarWidget(
            avatarUrl: '',
            radius: 15.sp,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
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
                      Text(
                        comment.id.toString(),
                        style: context.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 10),
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
                    // Row(
                    //   spacing: 5.w,
                    //   children: [
                    //     InkWell(
                    //       child: comment. ? SvgPicture.asset(thumbsUpFilledSvg) : SvgPicture.asset(thumbsUpPlainSvg),
                    //       onTap: () => context.read<SinglePostCommentsViewModel>().toggleSubCommentLike(widget.index),
                    //     ),
                    //     Text(comment.likes == 0 ? 'Like' : comment.likes.toString(), style: context.bodySmall?.copyWith(fontSize: 10)),
                    //   ],
                    // ),
                    // Row(
                    //   spacing: 5.w,
                    //   children: [
                    //     InkWell(
                    //         child: comment.hasReplied ? SvgPicture.asset(commentFilledSvg) : SvgPicture.asset(commentPlainSvg),
                    //         onTap: () {
                    //           setState(() {});
                    //         }),
                    //     Text(comment.replies == 0 ? 'Reply' : comment.replies.toString(), style: context.bodySmall?.copyWith(fontSize: 10)),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
