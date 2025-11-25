import 'package:solveit/core/injections/core_injections.dart';
import 'package:solveit/features/posts/presentation/viewmodels/inputfield_viewmodel.dart';
import 'package:solveit/features/posts/presentation/viewmodels/playback.dart';
import 'package:solveit/features/posts/presentation/viewmodels/preview.dart';
import 'package:solveit/features/posts/presentation/viewmodels/record.dart';

class MediaInjectionContainer {
  static Future<void> initialize() async {
    sl.registerFactory<MediaPreviewViewModel>(() => MediaPreviewViewModel());
    sl.registerFactory<RecordingViewModel>(() => RecordingViewModel());
    sl.registerFactory<AudioPlaybackManager>(() => AudioPlaybackManager());
    sl.registerFactory<InputfieldViewmodel>(() => InputfieldViewmodel());
  }
}
