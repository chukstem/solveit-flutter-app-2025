import 'package:flutter/material.dart';
import 'package:solveit/utils/extensions.dart';

/// A scrollable column, combinining a single child scollview and a column
///
class HScollableColumn extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final ScrollPhysics? physics;
  final List<Widget> children;
  final bool wrap;

  const HScollableColumn(
      {super.key,
      required this.children,
      this.wrap = false,
      this.physics,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.crossAxisAlignment = CrossAxisAlignment.stretch})
      : super();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: physics,
      padding: EdgeInsets.only(bottom: context.getBottomInsets()),
      shrinkWrap: wrap,
      children: [
        Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        )
      ],
    );
  }
}
