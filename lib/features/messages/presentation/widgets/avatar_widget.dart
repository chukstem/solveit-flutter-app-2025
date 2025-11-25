import 'package:flutter/material.dart';
import 'package:solveit/utils/theme/solveit_colors.dart';

class AvatarWidget extends StatelessWidget {
  final String avatarUrl;
  final bool isOnline;
  final double size;
  final double indicatorSize;

  const AvatarWidget({
    super.key,
    required this.avatarUrl,
    required this.isOnline,
    this.size = 35,
    this.indicatorSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: indicatorSize,
              height: indicatorSize,
              decoration: BoxDecoration(
                color: SolveitColors.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
