import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/messages/domain/models/responses/chat.dart';
import 'package:solveit/features/posts/presentation/screens/wave.dart';
import 'package:solveit/features/posts/presentation/screens/widgets/comment.dart';
import 'package:solveit/features/posts/presentation/screens/widgets/media_preview_widgets.dart';
import 'package:solveit/features/posts/presentation/screens/widgets/swipe.dart';
import 'package:solveit/features/posts/presentation/viewmodels/inputfield_viewmodel.dart';
import 'package:solveit/features/posts/presentation/viewmodels/preview.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/thumbnail/thumbnail.dart';
import 'package:solveit/utils/utils/string_utils.dart';
import 'package:solveit/utils/utils/utils.dart';

class ChatCard extends StatelessWidget {
  final ChatModel chat;
  final String name;

  const ChatCard({super.key, required this.chat, required this.name});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: chat.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        constraints: BoxConstraints(
          maxWidth: context.getWidth() * 0.65,
        ),
        child: SwipeToReplyWidget(
          isSender: chat.isMine,
          onReply: () => _handleReply(
            context,
            chat,
            chat.product,
            name,
          ),
          child: Column(
            spacing: 5.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: chat.isMine ? SolveitColors.primaryColor : SolveitColors.cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(defRadius),
                    topRight: Radius.circular(defRadius),
                    bottomRight: Radius.circular(chat.isMine ? 0 : defRadius),
                    bottomLeft: Radius.circular(chat.isMine ? defRadius : 0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (chat.mediaUrls != null && chat.mediaUrls!.isNotEmpty)
                      isAudio(chat.mediaUrls!.first)
                          ? WaveBubble(isSender: false, width: context.getWidth() * 0.5, path: chat.mediaUrls!.first)
                          : MediaGrid(
                              mediaFiles: chat.mediaUrls!,
                              isChat: true,
                              onOpen: (o) {},
                              onSave: (s) {},
                              onTap: () {
                                context.read<MediaPreviewViewModel>().addMedia(chat.mediaUrls!, isFromComment: true);
                                context.goToScreen(SolveitRoutes.previewSelectedMediaScreen);
                              },
                            ),
                    if (chat.chatReply != null)
                      Container(
                        padding: EdgeInsets.only(left: 3.w),
                        decoration: BoxDecoration(
                            color: chat.isMine ? SolveitColors.secondaryColor : SolveitColors.primaryColor, borderRadius: BorderRadius.circular(10.sp)),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: SolveitColors.primaryColor300,
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 🔹 Chat Reply Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chat.isMine ? chat.chatReply!.name : 'You',
                                      style: context.bodySmall?.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (chat.chatReply!.content.isNotEmpty)
                                          Text(
                                            chat.chatReply!.content.length > 70 ? '${chat.chatReply!.content.substring(0, 70)}...' : chat.chatReply!.content,
                                            style: context.bodySmall?.copyWith(
                                              fontSize: 8,
                                            ),
                                          ),

                                        // 🔹 Media Type Display
                                        if (chat.chatReply!.mediaUrls.isNotEmpty)
                                          Row(
                                            spacing: 5.w,
                                            children: [
                                              SvgPicture.asset(
                                                isDocument(chat.chatReply!.mediaUrls.first) ? documentSvg : replyPhoto,
                                              ),
                                              Text(
                                                getMediaTypeLabel(chat.chatReply!.mediaUrls),
                                                style: context.bodySmall?.copyWith(
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // 🔹 Media Preview (If Available)
                              if (chat.chatReply!.mediaUrls.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.sp),
                                  child: _buildMediaPreview(chat.chatReply!.mediaUrls.first),
                                ),
                            ],
                          ),
                        ),
                      ),
                    if (chat.product != null)
                      Container(
                        padding: EdgeInsets.all(4.sp),
                        margin: EdgeInsets.only(top: 4.sp),
                        decoration: BoxDecoration(
                          color: SolveitColors.primaryColor300,
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        child: Row(
                          spacing: 5.w,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.sp),
                              child: _buildMediaPreview(chat.product!.mediaurls.first),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 2.h,
                              children: [
                                Text(
                                  chat.product!.name,
                                  style: context.bodySmall?.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'NGN ${chat.product!.price}',
                                  style: context.bodySmall?.copyWith(
                                    fontSize: 10,
                                    color: SolveitColors.primaryColor,
                                  ),
                                ),
                                Text(
                                  chat.product!.place,
                                  style: context.bodySmall?.copyWith(
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    const SizedBox(height: 4),
                    if (chat.text != null && chat.text!.isNotEmpty)
                      ReadMoreText(
                        text: chat.text!,
                        textColor: chat.isMine ? SolveitColors.cardColor : SolveitColors.textColor,
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: chat.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (chat.isMine) ...[
                    // Show delivery and read receipts only for sent messages
                    SizedBox(
                      width: 16.w,
                      child: chat.isRead
                          ? Icon(
                              Icons.done_all,
                              size: 14.sp,
                              color: context.primaryColor,
                            )
                          : chat.isDelivered
                              ? Icon(
                                  Icons.done_all,
                                  size: 14.sp,
                                  color: context.colorScheme.onSurface.withOpacity(0.5),
                                )
                              : Icon(
                                  Icons.done,
                                  size: 14.sp,
                                  color: context.colorScheme.onSurface.withOpacity(0.5),
                                ),
                    ),
                    SizedBox(width: 4.w),
                  ],
                  Text(
                    StringUtils.formatLastActive(chat.timeAgo.toIso8601String()),
                    style: context.bodySmall?.copyWith(fontSize: 8),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaPreview(String mediaUrl) {
    if (isVideo(mediaUrl)) {
      return VideoThumbnailWidget(videoUrl: mediaUrl);
    } else if (isDocument(mediaUrl)) {
      return BuildDocumentPreview(docPath: mediaUrl, isSmall: true);
    } else {
      return Image.network(mediaUrl, width: 50.h, height: 50.h, fit: BoxFit.cover);
    }
  }

  void _handleReply(BuildContext context, ChatModel? chat, Product? product, String name) {
    context.read<InputfieldViewmodel>().setReply(ReplyingTo(
        comment: product?.place != null ? '${product?.place} - NGN ${product?.price}' : chat?.text,
        name: product?.name ?? (chat!.isMine ? 'You' : name),
        type: product?.mediaurls ?? chat?.mediaUrls ?? []));
  }
}
