import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

final ImagePicker _picker = ImagePicker();

void copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<BitmapDescriptor> pngToBitmapDescriptor(String assetPath, {int width = 100}) async {
  return await BitmapDescriptor.asset(
    ImageConfiguration(size: Size(width.toDouble(), width.toDouble())),
    assetPath,
  );
}

Future<CroppedFile?> cropImage(String filePath) async {
  try {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      compressQuality: 80,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Crop Image",
          // toolbarColor: Colors.black,
          // toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          hideBottomControls: true,
        ),
        IOSUiSettings(title: "Crop Image"),
      ],
    );

    return croppedFile;
  } catch (e, s) {
    log("Error cropping image: $e");
    log("Stack trace: $s");
    return null;
  }
}

Future<File?> pickImage({ImageSource source = ImageSource.gallery, bool shouldCrop = true}) async {
  try {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (pickedFile == null) return null;

    if (shouldCrop) {
      final croppedFile = await cropImage(pickedFile.path);
      if (croppedFile != null) {
        String compressedPath = await _compressImage(croppedFile.path);
        return File(compressedPath);
      }
      return File(pickedFile.path);
    } else {
      String compressedPath = await _compressImage(pickedFile.path);
      return File(compressedPath);
    }
  } catch (e, s) {
    log("Error picking image: $e");
    log("Stack trace: $s");
    return null;
  }
}

Future<List<String>?> pickMultipleMedia() async {
  try {
    final List<XFile> files = await _picker.pickMultipleMedia();
    if (files.isEmpty) return [];

    List<String> processedFiles = [];

    for (XFile file in files) {
      if (_isImage(file.path)) {
        String compressedPath = await _compressImage(file.path);
        processedFiles.add(compressedPath);
      } else {
        processedFiles.add(file.path);
      }
    }
    return processedFiles;
  } catch (e) {
    debugPrint('Error picking media: $e');
    return null;
  }
}

Future<String> _compressImage(String filePath) async {
  if (filePath.isEmpty) return filePath;
  final file = File(filePath);
  final dir = await getTemporaryDirectory();
  final extension = p.extension(filePath);
  final targetPath = p.join(dir.path, '${DateTime.now().millisecondsSinceEpoch}$extension');

  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 50,
    format: CompressFormat.jpeg,
  );

  return result?.path ?? filePath;
}

/// Check if file is an image
bool _isImage(String path) {
  return ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(p.extension(path).toLowerCase());
}

Future<List<String>?> pickDocuments() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'xlsx', 'ppt', 'pptx'],
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      return result.files.map((file) => file.path!).toList();
    }
  } catch (e) {
    debugPrint('Error picking documents: $e');
  }
  return null;
}

/// Pick audio files (MP3, WAV, AAC, etc.)
Future<List<String>?> pickAudioFiles() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null && result.files.isNotEmpty) {
      return result.files.map((file) => file.path!).toList();
    }
  } catch (e) {
    debugPrint('Error picking audio files: $e');
  }
  return null;
}

String formatDuration(int seconds) {
  final duration = Duration(seconds: seconds);
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$secs';
}

bool isDocument(String file) => file.endsWith('.pdf') || file.endsWith('docs') || file.endsWith('doc') || file.endsWith('txt') || file.endsWith('rtf');

String getFileSize(String path) {
  final file = File(path);
  final bytes = file.lengthSync();
  final kb = bytes / 1024;
  final mb = kb / 1024;
  return mb >= 1 ? "${mb.toStringAsFixed(1)}MB" : "${kb.toStringAsFixed(1)}KB";
}

bool isVideo(String file) {
  final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.flv', '.wmv', '.webm', '.mpeg', '.3gp'];
  return videoExtensions.any((ext) => file.toLowerCase().endsWith(ext));
}

bool isImage(String file) {
  final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
  return imageExtensions.any((ext) => file.toLowerCase().endsWith(ext));
}

bool isAudio(String file) {
  final audioExtensions = ['.mp3', '.wav', '.aac', '.ogg', '.m4a', '.flac', '.wma', '.opus'];
  return audioExtensions.any((ext) => file.toLowerCase().endsWith(ext));
}

String getMediaTypeLabel(List<String> types) {
  final count = types.length > 1 ? 's' : ''; // Pluralization
  if (isVideo(types.first)) return 'Video$count';
  if (isAudio(types.first)) return 'Audio$count';
  if (isDocument(types.first)) return 'Document$count';
  return 'Image$count';
}
