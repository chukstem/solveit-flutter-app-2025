import 'dart:async';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

/// Represents the current state of an audio recording
enum RecordingState {
  /// No recording in progress, but not finished either
  stopped,

  /// Recording is currently in progress
  recording,

  /// Recording is temporarily paused
  paused,

  /// Recording process is complete
  finished
}

/// Manages audio recording functionality throughout the application.
///
/// Provides methods to record, pause, stop and manage audio recordings
/// for voice messages in chats, forums, and posts.
class RecordingViewModel extends ChangeNotifier {
  /// Current state of the recording
  RecordingState _recordingState = RecordingState.finished;

  /// Gets the current recording state
  RecordingState get recordingState => _recordingState;

  /// Sets the recording state and notifies listeners
  set recordingState(RecordingState value) {
    if (_recordingState != value) {
      _recordingState = value;
      notifyListeners();
    }
  }

  /// Timer used to track recording duration
  Timer? _timer;

  /// Duration of the current recording in seconds
  int _recordDuration = 0;

  /// Gets the current recording duration in seconds
  int get recordDuration => _recordDuration;

  /// Path to the recorded audio file
  String? _recordedFilePath;

  /// Gets the path to the recorded audio file
  String? get recordedFilePath => _recordedFilePath;

  /// The controller that manages the audio recording
  late final RecorderController recorderController;

  /// Creates a new instance of [RecordingViewModel]
  RecordingViewModel() {
    _initializeController();
  }

  /// Initializes the recorder controller with the appropriate settings
  void _initializeController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
  }

  @override
  void dispose() {
    _timer?.cancel();
    recorderController.dispose();
    super.dispose();
  }

  /// Starts recording audio
  ///
  /// Parameters:
  /// - [refresh] If true, any existing recording will be discarded
  ///
  /// Returns a Future that completes when recording has started
  Future<void> startRecording({bool refresh = false}) async {
    if (refresh) {
      finishRecording(discard: true);
    }

    try {
      final hasPermission = await recorderController.checkPermission();
      if (!hasPermission) {
        debugPrint("Microphone permission denied");
        return;
      }

      _recordDuration = 0;
      await recorderController.record();
      recordingState = RecordingState.recording;

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _recordDuration++;
        notifyListeners();
      });
    } catch (e) {
      debugPrint("Error starting recording: $e");
      recordingState = RecordingState.finished;
    }
  }

  /// Stops the current recording
  ///
  /// Parameters:
  /// - [discard] If true, the recording will be discarded
  ///
  /// Returns a Future that completes when recording has stopped
  Future<void> stopRecording({bool discard = false}) async {
    try {
      if (_recordingState != RecordingState.recording && _recordingState != RecordingState.paused) {
        return;
      }

      if (discard) {
        await recorderController.stop();
        _recordedFilePath = null;
      } else {
        _recordedFilePath = await recorderController.stop();
      }

      recorderController.reset();
      recordingState = RecordingState.stopped;
      _timer?.cancel();
      _timer = null;
      notifyListeners();
    } catch (e) {
      debugPrint("Error stopping recording: $e");
      // Ensure we reset state even if there's an error
      _timer?.cancel();
      _timer = null;
      recordingState = RecordingState.stopped;
      notifyListeners();
    }
  }

  /// Finalizes the recording process
  ///
  /// Parameters:
  /// - [discard] If true, the recording will be discarded
  void finishRecording({bool discard = false}) {
    _timer?.cancel();
    _timer = null;

    if (discard) {
      _recordedFilePath = null;
    }

    // Reset everything
    recorderController.reset();
    _recordDuration = 0;
    recordingState = RecordingState.finished;

    notifyListeners();
  }

  /// Pauses the current recording
  ///
  /// Returns a Future that completes when recording has been paused
  Future<void> pauseRecording() async {
    if (_recordingState != RecordingState.recording) {
      return;
    }

    try {
      await recorderController.pause();
      _timer?.cancel();
      _timer = null;
      recordingState = RecordingState.paused;
      notifyListeners();
    } catch (e) {
      debugPrint("Error pausing recording: $e");
    }
  }
}
