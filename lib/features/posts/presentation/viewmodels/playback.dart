import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

/// Manages audio playback across the application.
///
/// Ensures only one audio clip can play at a time by tracking the active
/// player controller. Used in messages, forums, and posts for voice messages.
class AudioPlaybackManager extends ChangeNotifier {
  /// The currently active player controller
  PlayerController? _activeController;

  /// Path to the audio file that is currently playing
  String? _currentlyPlayingPath;

  /// Returns the path of the currently playing audio, if any
  String? get currentlyPlayingPath => _currentlyPlayingPath;

  /// Plays an audio file using the provided controller.
  ///
  /// If another audio is playing, it will be paused first.
  ///
  /// Parameters:
  /// - [controller] The PlayerController to use for playback
  /// - [path] The file path of the audio to play
  Future<void> play(PlayerController controller, String path) async {
    try {
      // Stop any currently playing audio if it's a different file
      if (_activeController != null && _currentlyPlayingPath != path) {
        await _activeController!.pausePlayer();
      }

      _activeController = controller;
      _currentlyPlayingPath = path;
      notifyListeners();
    } catch (e) {
      debugPrint('Error playing audio: $e');
      // Reset state in case of error
      _currentlyPlayingPath = null;
      notifyListeners();
    }
  }

  /// Stops the currently playing audio, if any.
  Future<void> stop() async {
    try {
      await _activeController?.pausePlayer();
      _currentlyPlayingPath = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping audio: $e');
      // Still update the state even if there's an error
      _currentlyPlayingPath = null;
      notifyListeners();
    }
  }

  /// Checks if a specific audio file is currently playing.
  ///
  /// Parameters:
  /// - [path] The file path to check
  ///
  /// Returns true if the specified file is playing, false otherwise.
  bool isPlaying(String path) => _currentlyPlayingPath == path;
}
