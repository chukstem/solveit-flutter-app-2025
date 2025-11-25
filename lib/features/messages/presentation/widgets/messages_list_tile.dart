import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solveit/utils/assets/assets_manager.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

class Message1ListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isOnline;
  final int id;

  const Message1ListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.id,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    String day = id > 1 ? "days" : "day";
    String imageUrl = "https://i.pravatar.cc/300";
    return ListTile(
      title: Text(
        title,
        style: context.bodySmall?.copyWith(
          color: context.colorScheme.shadow,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subtitle.isNotEmpty ? subtitle.capitalize() : "No messages",
        style: context.bodySmall!.copyWith(
            // color: context.primaryColor,
            ),
      ),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 20.w,
            backgroundImage: NetworkImage(imageUrl),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Icon(
                Icons.circle,
                size: 10.w,
                color: isOnline ? Colors.green : Colors.grey,
              ))
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$id $day", style: context.bodySmall?.copyWith(fontSize: 9)),
          id == 5 || id == 1
              ? Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colorScheme.primary,
                  ),
                  child: Text(
                    id.toString(),
                    style: context.bodySmall!.copyWith(color: context.backgroundColor, fontSize: 10),
                  ),
                )
              : SvgPicture.asset(
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.primary,
                    BlendMode.srcIn, // Ensures the color replaces the SVG color
                  ),
                  id % 2 == 0 ? checkIcon : doubleCheckIcon,
                  width: 15.w,
                  height: 15.h,
                )
        ],
      ),
    );
  }
}
