import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/posts/presentation/viewmodels/playback.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/utils/utils.dart';

class WaveBubble extends StatefulWidget {
  final bool isSender;
  final String path;
  final double? width;
  const WaveBubble({
    super.key,
    this.width,
    this.isSender = false,
    required this.path,
  });

  @override
  State<WaveBubble> createState() => _WaveBubbleState();
}

class _WaveBubbleState extends State<WaveBubble> {
  late PlayerController controller;
  late StreamSubscription<PlayerState> playerStateSubscription;

  final playerWaveStyle = const PlayerWaveStyle(
    fixedWaveColor: Colors.grey,
    liveWaveColor: SolveitColors.secondaryColor,
    spacing: 6,
  );

  int _currentDuration = 0;
  int _maxDuration = 0;

  @override
  void initState() {
    super.initState();
    controller = PlayerController();
    _preparePlayer();
    playerStateSubscription = controller.onPlayerStateChanged.listen((state) {
      getTime();
    });
  }

  void _preparePlayer() async {
    await controller.preparePlayer(
      path: widget.path,
      shouldExtractWaveform: true,
    );

    controller
        .extractWaveformData(
          path: widget.path,
          noOfSamples: playerWaveStyle.getSamplesForWidth(widget.width ?? 300),
        )
        .then((waveformData) => debugPrint(waveformData.toString()));
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getTime();
    return Align(
      alignment: widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: FittedBox(
        child: Container(
          constraints: const BoxConstraints(
              // maxWidth: widget.width ?? context.getWidth() * 0.5,
              ),
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: SolveitColors.secondaryColor400),
          child: Row(
            spacing: 10.w,
            children: [
              InkWell(
                onTap: () async {
                  await playAndPause();
                  controller.setFinishMode(finishMode: FinishMode.pause);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: !controller.playerState.isPlaying ? SvgPicture.asset(playAudioSvg) : SvgPicture.asset(pauseAudioSvg),
              ),
              Text(
                controller.playerState.isPlaying ? formatDuration(_currentDuration) : formatDuration(_maxDuration),
                style: context.bodySmall,
              ),
              AudioFileWaveforms(
                size: Size(widget.width ?? context.getWidth() * 0.65, 40),
                playerController: controller,
                waveformType: WaveformType.fitWidth,
                playerWaveStyle: playerWaveStyle,
              ),
              if (widget.isSender) const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> playAndPause() async {
    final audioManager = context.read<AudioPlaybackManager>();

    if (audioManager.isPlaying(widget.path)) {
      await controller.pausePlayer();
      audioManager.stop();
    } else {
      audioManager.play(controller, widget.path);
      await controller.startPlayer();
    }
  }

  void getTime() async {
    final cduration = await controller.getDuration(DurationType.current);
    final mduration = await controller.getDuration(DurationType.max);
    _maxDuration = mduration ~/ 1000;
    setState(() {
      _currentDuration = cduration ~/ 1000;
    });
  }
}
