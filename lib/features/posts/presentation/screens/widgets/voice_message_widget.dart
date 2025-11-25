import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/posts/presentation/screens/wave.dart';
import 'package:solveit/features/posts/presentation/viewmodels/record.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/utils/utils.dart';

class VoiceRecorderWidget extends StatelessWidget {
  final Function(File) onFinish;

  const VoiceRecorderWidget({
    super.key,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordingViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: (viewModel.recordedFilePath != null)
                      ? WaveBubble(
                          isSender: false, path: viewModel.recordedFilePath!)
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: SolveitColors.secondaryColor400),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatDuration(viewModel.recordDuration),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: AudioWaveforms(
                                  enableGesture: true,
                                  size: Size(
                                      MediaQuery.of(context).size.width / 2,
                                      50),
                                  recorderController:
                                      viewModel.recorderController,
                                  waveStyle: const WaveStyle(
                                    waveColor: SolveitColors.secondaryColor,
                                    showMiddleLine: false,
                                    extendWaveform: true,
                                  ),
                                  padding: const EdgeInsets.only(left: 18),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      viewModel.finishRecording(discard: true);
                    },
                    child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: SolveitColors.primaryColor300,
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(deleteAudioSvg)),
                  ),
                  if (viewModel.recordedFilePath == null)
                    IconButton(
                      icon: viewModel.recordingState == RecordingState.recording
                          ? SvgPicture.asset(pauseAudioSvg)
                          : Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: SolveitColors.primaryColor300,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.mic,
                                  size: 20, color: SolveitColors.primaryColor),
                            ),
                      onPressed: () {
                        if (viewModel.recordingState ==
                            RecordingState.recording) {
                          viewModel.pauseRecording();
                        }
                        if (viewModel.recordingState == RecordingState.paused) {
                          viewModel.startRecording();
                        }
                      },
                    ),
                  InkWell(
                    onTap: () {
                      if (viewModel.recordedFilePath != null) {
                        onFinish(File(viewModel.recordedFilePath!));
                        viewModel.finishRecording();
                      } else {
                        viewModel.stopRecording();
                      }
                    },
                    child: viewModel.recordingState != RecordingState.stopped
                        ? Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: SolveitColors.primaryColor300,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.stop_circle,
                                color: SolveitColors.primaryColor),
                          )
                        : SvgPicture.asset(sendAudioSvg),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
