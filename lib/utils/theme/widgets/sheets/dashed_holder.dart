import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationDashedHolder extends StatelessWidget {
  final Widget child;
  final Positioned? positioned;
  const LocationDashedHolder({super.key, required this.child, this.positioned})
      : super();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: positioned?.top ?? 20.h,
          left: positioned?.left ?? 0.w,
          child: SizedBox(
            height: 80.h, // Adjust height as needed
            width: 48.w,
            child: CustomPaint(
              painter: _DashedLinePainter(),
            ),
          ),
        ),
        child
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double dashWidth = 5, dashSpace = 5;
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(size.width / 2, startY),
          Offset(size.width / 2, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
