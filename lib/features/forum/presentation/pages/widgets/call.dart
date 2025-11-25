import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:solveit/features/forum/presentation/viewmodels/call.dart';
import 'package:solveit/features/home/presentation/pages/home_screen.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/skeleton/h_skeleton.dart';

enum CallType {
  audio,
  video,
}

class CallParticipant {
  final String name;
  final String avatarUrl;

  CallParticipant({required this.name, required this.avatarUrl});
}

class CallBottomSheet extends StatelessWidget {
  final CallType type;

  const CallBottomSheet({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GroupCallViewModel>();

    final int participantCount = vm.participants.length;
    const double baseHeight = 200;
    const double perRowHeight = 120;
    final int rows = (participantCount / 3).ceil();
    final double maxHeight = MediaQuery.of(context).size.height * 0.9;

    final double targetHeight = (baseHeight + rows * perRowHeight).clamp(300, maxHeight);

    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        height: targetHeight,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _dragHandle(),
            const SizedBox(height: 12),
            _header(context, vm),
            const SizedBox(height: 16),
            Expanded(child: _body(context, vm)),
            const SizedBox(height: 16),
            _footerControls(context),
          ],
        ),
      ),
    );
  }

  Widget _dragHandle() => Center(
        child: Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );

  Widget _header(BuildContext context, GroupCallViewModel vm) {
    final callLabel = type == CallType.audio ? "Audio call" : "Video call";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(audioCallSvg),
            const SizedBox(width: 8),
            Text(
              callLabel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
            ),
          ],
        ),
        if (vm.callState == CallState.connected)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _formatDuration(vm.callDuration),
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        else
          vm.callState == CallState.connecting ? const Text('Connecting...') : const Text('Call Failed'),
        const SizedBox(width: 8),
        SvgPicture.asset(pictureInPictureSvg),
      ],
    );
  }

  Widget _body(BuildContext context, GroupCallViewModel vm) {
    if (vm.callState == CallState.connecting) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: HSkeleton(
                  isLoading: true,
                  child: AvatarWidget(
                    avatarUrl: 'https://i.pravatar.cc/150?img=1',
                    radius: 30.sp,
                    hasOnline: false,
                  ))),
          Text(
            'Computer Science',
            style: context.bodyLarge,
          )
        ],
      );
    }

    if (vm.callState == CallState.failed) {
      return const Center(child: Text("Call failed ❌"));
    }

    if (vm.callState == CallState.ended) {
      return const SizedBox.shrink();
    }

    // Connected
    final participants = vm.participants;

    return GridView.builder(
      itemCount: participants.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) {
        final p = participants[i];
        return Column(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundImage: NetworkImage(p.avatarUrl),
            ),
            const SizedBox(height: 6),
            Text(
              p.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            )
          ],
        );
      },
    );
  }

  Widget _footerControls(BuildContext context) {
    final vm = context.read<GroupCallViewModel>();

    final iconSet = vm.callState == CallState.connecting
        ? [muteSvg, videoBoarderSvg, recordVNSvg, endCallSvg]
        : vm.callState == CallState.failed
            ? [endCallSvg, callAgainSvg]
            : [speakerFilledSvg, videoBoarderSvg, recordVNSvg, endCallSvg];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: iconSet.map((icon) {
        final isEnd = icon == endCallSvg;
        return GestureDetector(
          onTap: () {
            if (isEnd) {
              context.read<GroupCallViewModel>().endCallWithDelay();
              Navigator.of(context).maybePop();
            }
          },
          child: SvgPicture.asset(
            icon,
          ),
        );
      }).toList(),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }
}
