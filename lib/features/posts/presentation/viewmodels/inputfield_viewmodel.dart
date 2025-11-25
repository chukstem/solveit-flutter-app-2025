// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

/// A ViewModel that manages the reply functionality across the app.
///
/// This is used in posts, forums, and message screens to track which
/// message or comment a user is replying to.
class InputfieldViewmodel extends ChangeNotifier {
  /// The comment or message that is currently being replied to.
  /// Null when no reply is in progress.
  ReplyingTo? _replyingTo;

  /// Getter for the current reply target
  ReplyingTo? get replyingTo => _replyingTo;

  /// Sets the current reply target
  ///
  /// [comment] The comment/message being replied to, or null to clear
  void setReply(ReplyingTo? comment) {
    _replyingTo = comment;
    notifyListeners();
  }

  /// Clears the current reply target
  void clearReply() {
    if (_replyingTo != null) {
      _replyingTo = null;
      notifyListeners();
    }
  }
}

/// Represents a comment or message that is being replied to.
class ReplyingTo {
  /// The content of the comment/message
  final String? comment;

  /// The name of the user who wrote the original comment/message
  final String name;

  /// List of media URLs attached to the original comment/message
  final List<String> type;

  /// Creates a new instance of [ReplyingTo]
  ReplyingTo({
    required this.comment,
    required this.name,
    required this.type,
  });

  @override
  String toString() => 'ReplyingTo(comment: $comment, name: $name, type: $type)';
}
