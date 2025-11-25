import 'package:flutter/material.dart';

class SwipeToReplyWidget extends StatefulWidget {
  const SwipeToReplyWidget({
    super.key,
    required this.onReply,
    required this.child,
    this.isSender = true,
  });

  final VoidCallback onReply;
  final bool isSender;
  final Widget child;

  @override
  State<SwipeToReplyWidget> createState() => _SwipeToReplyWidgetState();
}

class _SwipeToReplyWidgetState extends State<SwipeToReplyWidget> {
  double _dragExtent = 0.0;
  final double _swipeThreshold = 40.0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.primaryDelta!;

      // Ensure the drag direction is **correct**
      if (widget.isSender) {
        _dragExtent = _dragExtent.clamp(-100, 0); // Sender swipes left
      } else {
        _dragExtent = _dragExtent.clamp(0, 100); // Receiver swipes right
      }
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bool isSwipeValid = widget.isSender
        ? _dragExtent < -_swipeThreshold // Sender swipes **left**
        : _dragExtent > _swipeThreshold; // Receiver swipes **right**

    if (isSwipeValid) {
      widget.onReply();
    }

    // Smoothly reset position
    setState(() {
      _dragExtent = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(_dragExtent, 0, 0),
        child: widget.child,
      ),
    );
  }
}
