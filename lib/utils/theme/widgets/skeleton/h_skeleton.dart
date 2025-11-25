import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HSkeleton extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const HSkeleton({super.key, required this.child, required this.isLoading})
      : super();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: child,
    );
  }
}
