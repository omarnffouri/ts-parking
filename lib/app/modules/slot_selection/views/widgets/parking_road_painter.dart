import 'package:flutter/material.dart';
import 'package:ts_parking/app/theme/app_colors.dart';

class ParkingRoadPainter extends CustomPainter {
  const ParkingRoadPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.success.withValues(alpha: 0.55)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    const dash = 4.0;
    const gap = 4.0;

    double currentY = 0;
    while (currentY < size.height * 0.72) {
      canvas.drawLine(
        Offset(size.width / 2, currentY),
        Offset(size.width / 2, (currentY + dash).clamp(0, size.height * 0.72)),
        paint,
      );
      currentY += dash + gap;
    }

    double currentX = size.width / 2;
    while (currentX < size.width) {
      canvas.drawLine(
        Offset(currentX, size.height * 0.72),
        Offset((currentX + dash).clamp(0, size.width), size.height * 0.72),
        paint,
      );
      currentX += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant ParkingRoadPainter oldDelegate) => false;
}
