import 'package:flutter/material.dart';

/// Manages media files preview across the application.
///
/// This ViewModel handles the selection, preview, and management of media files
/// (images, videos, documents, audio) that can be attached to posts,
/// chat messages, or forum messages.
class MediaPreviewViewModel extends ChangeNotifier {
  /// List of paths to selected media files
  List<String> _selectedMedia = [];

  /// Gets the list of selected media files
  List<String> get selectedMedia => _selectedMedia;

  /// Text caption associated with the media
  String _caption = "";

  /// Gets the current caption
  String get caption => _caption;

  /// Index of the currently selected media in the preview carousel
  int _selectedMediaIndex = 0;

  /// Gets the current media index
  int get selectedMediaIndex => _selectedMediaIndex;

  /// Sets the current media index
  set selectedMediaIndex(int value) {
    if (value >= 0 && value < _selectedMedia.length) {
      _selectedMediaIndex = value;
      notifyListeners();
    }
  }

  /// The type of content this media will be attached to
  PostType _postType = PostType.posts;

  /// Gets the current post type
  PostType get getPostType => _postType;

  /// Sets the post type context
  ///
  /// Must be called in the initState of any screen that uses this ViewModel
  void setPostType(PostType value) {
    _postType = value;
  }

  /// Flag indicating if the preview is from a message context
  bool _isFromMessagePreview = false;

  /// Gets whether this is from a message preview
  bool get isFromMessagePreview => _isFromMessagePreview;

  /// Sets whether this is from a message preview
  set isFromMessagePreview(bool value) {
    _isFromMessagePreview = value;
    notifyListeners();
  }

  /// Adds media files to the preview
  ///
  /// Replaces any existing media with the new list.
  ///
  /// Parameters:
  /// - [files] List of file paths to add
  /// - [isFromComment] Whether this is being added from a comment context
  void addMedia(List<String> files, {bool isFromComment = false}) {
    if (files.isEmpty) return;

    _selectedMedia = [];
    _selectedMedia.addAll(files);
    _selectedMediaIndex = 0;

    if (isFromComment) {
      isFromMessagePreview = true;
    }

    notifyListeners();
  }

  /// Removes a media file at the specified index
  ///
  /// Parameters:
  /// - [index] Index of the media to remove
  void removeMedia(int index) {
    if (index >= 0 && index < _selectedMedia.length) {
      _selectedMedia.removeAt(index);

      // Adjust selected index if needed
      if (_selectedMediaIndex >= _selectedMedia.length) {
        _selectedMediaIndex = _selectedMedia.isEmpty ? 0 : _selectedMedia.length - 1;
      }

      notifyListeners();
    }
  }

  /// Updates the caption text
  ///
  /// Parameters:
  /// - [value] New caption text
  void updateCaption(String value) {
    _caption = value;
    notifyListeners();
  }

  /// Clears all selected media and resets state
  void clearMedia() {
    _selectedMedia.clear();
    _caption = "";
    _selectedMediaIndex = 0;
    _isFromMessagePreview = false;
    notifyListeners();
  }
}

/// Specifies the context in which media is being used
///
/// This must be set in the initState of any screen that uses MediaPreviewViewModel
enum PostType {
  /// Forum post context
  forum,

  /// Chat message context
  chat,

  /// Regular post context
  posts,
}
