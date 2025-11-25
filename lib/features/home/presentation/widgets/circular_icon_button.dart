import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

class CircularIconButton extends StatefulWidget {
  final VoidCallback onTap;
  final String icon;
  final String isSelected;

  const CircularIconButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.isSelected,
  });

  @override
  CircularIconButtonState createState() => CircularIconButtonState();
}

class CircularIconButtonState extends State<CircularIconButton> {
  String internalSelected = '';

  void _handleTap() {
    setState(() {
      if (internalSelected == widget.isSelected) {
        internalSelected = '';
      } else {
        internalSelected = widget.isSelected;
      }
    });
    widget.onTap(); // Trigger the external onTap callback
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: CircleAvatar(
          radius: 18.w, // Adjust radius as needed
          backgroundColor:
              (internalSelected == widget.isSelected && internalSelected != '') ? context.cardColor : context.cardColor.withValues(alpha: 0.35), // Circle color
          child: SvgPicture.asset(
            widget.icon,
            width: 20.w,
            height: 20.w,
            colorFilter: ColorFilter.mode(
                (internalSelected == widget.isSelected && internalSelected != '') ? context.colorScheme.secondary : context.cardColor, BlendMode.srcIn),
          )),
    );
  }
}
