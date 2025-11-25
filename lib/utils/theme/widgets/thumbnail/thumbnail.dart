import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_thumbnail_plus/flutter_video_thumbnail_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solveit/utils/theme/widgets/skeleton/h_skeleton.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget({super.key, required this.videoPath});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool getIsPlaying = _controller.value.isPlaying;
    return !_controller.value.isInitialized
        ? HSkeleton(isLoading: true, child: Container())
        : Stack(fit: StackFit.expand, children: [
            VideoPlayer(_controller),
            Center(
                child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    getIsPlaying ? Icons.pause : Icons.play_arrow,
                    size: 40,
                  ),
                ),
              ),
            )),
          ]);
  }
}

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;

  const VideoThumbnailWidget({super.key, required this.videoUrl});

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  String? _thumbnailPath;

  @override
  void initState() {
    super.initState();
    _getOrGenerateThumbnail(widget.videoUrl);
  }

  Future<void> _getOrGenerateThumbnail(String videoUrl) async {
    final tempDir = await getTemporaryDirectory();
    final thumbnailFileName =
        'thumbnail_${Uri.parse(videoUrl).pathSegments.last}.png';
    final thumbnailFilePath = '${tempDir.path}/$thumbnailFileName';
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        if (await File(thumbnailFilePath).exists()) {
          setState(() {
            _thumbnailPath = thumbnailFilePath;
          });
        } else {
          final newThumbnailPath =
              await FlutterVideoThumbnailPlus.thumbnailFile(
            video: videoUrl,
            thumbnailPath: thumbnailFilePath,
            imageFormat: ImageFormat.png,
            maxWidth: 128,
            quality: 75,
          );
          setState(() {
            _thumbnailPath = newThumbnailPath;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _thumbnailPath != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(_thumbnailPath!),
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          )
        : const CircularProgressIndicator();
  }
}
