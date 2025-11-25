import 'package:flutter/material.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';

class HClickableText extends StatelessWidget {
  final String text;
  final VoidCallback onClick;
  final bool? isBoldText;
  const HClickableText({super.key, required this.text, required this.onClick, this.isBoldText = true});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          onClick();
        },
        child: Text(
          text,
          style: context.bodySmall?.copyWith(color: context.primaryColor, fontWeight: isBoldText! ? FontWeight.bold : FontWeight.w500),
        ));
  }
}
