import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:solveit/features/posts/presentation/viewmodels/preview.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/navigation/routes.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/thumbnail/thumbnail.dart';
import 'package:solveit/utils/utils/utils.dart';
import 'package:thumbnailer/thumbnailer.dart';

class MediaGrid extends StatelessWidget {
  final List<String> mediaFiles;
  final Function(String) onOpen;
  final Function(String) onSave;
  final void Function()? onTap;
  final bool? isChat, isMine;

  const MediaGrid({
    super.key,
    required this.mediaFiles,
    required this.onOpen,
    required this.onSave,
    this.onTap,
    this.isChat = false,
    this.isMine = false,
  });

  @override
  Widget build(BuildContext context) {
    if (mediaFiles.isEmpty) return const SizedBox.shrink();

    final displayMedia = mediaFiles.length > 2 ? mediaFiles.take(3).toList() : mediaFiles;
    final extraCount = mediaFiles.length > 2 ? mediaFiles.length - displayMedia.length : 0;

    // 🔹 Check if any file is a document
    final containsDocument = displayMedia.any((file) => isDocument(file));

    return containsDocument
        ? BuildDocumentPreview(
            docPath: displayMedia.first,
            isChat: isChat,
            isMine: isMine,
          )
        : _buildMediaGrid(context, displayMedia, extraCount);
  }

  Widget _buildMediaGrid(BuildContext context, List<String> mediaUrls, int extraCount) {
    bool isVideo(String s) => s.endsWith('.mp4') || s.endsWith('.mov');
    return SizedBox(
      height: mediaUrls.length < 2 ? 120.h : 70.h,
      width: mediaUrls.length < 2 ? 150.w : double.infinity,
      child: mediaUrls.length < 2
          ? GestureDetector(
              onTap: () {
                context.read<MediaPreviewViewModel>().selectedMediaIndex = 0;
                onTap?.call();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.sp),
                child: isVideo(mediaUrls.first)
                    ? VideoThumbnailWidget(
                        videoUrl: mediaUrls.first,
                      )
                    : Image.file(File(mediaUrls.first), fit: BoxFit.fitWidth),
              ),
            )
          : Row(
              children: List.generate(mediaUrls.length, (index) {
                final media = mediaUrls[index];
                final isLastItem = index == 2 && extraCount > 0;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index > 1 ? 0 : 6.h),
                    child: GestureDetector(
                      onTap: () {
                        context.read<MediaPreviewViewModel>().selectedMediaIndex = index;
                        onTap?.call();
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.sp),
                            child: isVideo(media)
                                ? VideoThumbnailWidget(videoUrl: media)
                                : Image.file(File(media), fit: BoxFit.cover),
                          ),
                          if (isLastItem)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(defRadius),
                                  color: Colors.black54,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "+$extraCount",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
    );
  }
}

class BuildDocumentPreview extends StatefulWidget {
  final String docPath;
  final bool? isSmall, isChat, isMine;

  const BuildDocumentPreview({
    super.key,
    required this.docPath,
    this.isSmall = false,
    this.isChat,
    this.isMine,
  });

  @override
  State<BuildDocumentPreview> createState() => _BuildDocumentPreviewState();
}

class _BuildDocumentPreviewState extends State<BuildDocumentPreview> {
  late String fileName;
  late String fileExtension;
  late String mimeType;
  late String fileSize;

  @override
  void initState() {
    super.initState();
    fileName = p.basename(widget.docPath);
    fileExtension = p.extension(widget.docPath).toLowerCase();
    fileSize = getFileSize(widget.docPath); // Implement a function to get file size

    // Determine the MIME type based on file extension
    mimeType = _getMimeType(fileExtension);
  }

  /// **Determine MIME type from file extension**
  String _getMimeType(String extension) {
    switch (extension) {
      case '.pdf':
        return 'application/pdf';
      case '.doc':
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case '.xls':
      case '.xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case '.ppt':
      case '.pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case '.txt':
        return 'text/plain';
      default:
        return 'application/octet-stream'; // Default for unknown types
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isSmall! ? _buildSmallPreview() : _buildFullPreview();
  }

  Widget _buildSmallPreview() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: SolveitColors.primaryColor300,
      ),
      child: _buildThumbnail(50),
    );
  }

  Widget _buildFullPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: SolveitColors.primaryColor300,
          ),
          child: Column(
            spacing: 5.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildThumbnail(80), // File preview
              Text(
                fileName.length > 40 ? "${fileName.substring(0, 40)}..." : fileName,
                overflow: TextOverflow.ellipsis,
                style: context.bodySmall?.copyWith(fontSize: 10),
              ),
              Text(
                "${fileExtension.replaceFirst(r'.', '').toUpperCase()} • $fileSize",
                style: context.bodySmall,
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        Row(
          spacing: 20.w,
          children: [
            TransparentButton(
              text: 'Save',
              onPressed: () {},
            ),
            TransparentButton(
              text: 'Open',
              onPressed: () {
                context
                    .read<MediaPreviewViewModel>()
                    .addMedia([widget.docPath], isFromComment: true);
                context.goToScreen(SolveitRoutes.previewSelectedMediaScreen);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThumbnail(double size) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: SolveitColors.secondaryColor400.withValues(alpha: 0.4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Thumbnail(
          dataResolver: () async {
            return File(widget.docPath).readAsBytes();
          },
          mimeType: mimeType,
          widgetSize: size,
          // decoration: WidgetDecoration(wrapperBgColor: Colors.blueAccent),
        ),
      ),
    );
  }
}

class TransparentButton extends StatelessWidget {
  const TransparentButton({
    super.key,
    this.onPressed,
    required this.text,
  });

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SizedBox(
      height: 30,
      child: TextButton(
        style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              SolveitColors.primaryColor300,
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            )),
        onPressed: onPressed,
        child: Text(
          text,
          style: context.bodySmall?.copyWith(fontSize: 10),
        ),
      ),
    ));
  }
}
