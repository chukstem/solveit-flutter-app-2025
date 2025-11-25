import 'package:flutter/material.dart';

class OnboardingBackground extends StatelessWidget {
  final Widget child;

  const OnboardingBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF390021),
            Color(0xFF9F005C),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [-0.1531, 1.0],
        ),
      ),
      child: child,
    );
  }
}
