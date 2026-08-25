import 'package:flutter/material.dart';
import 'package:ts_parking/app/theme/app_colors.dart';

class CurvedRoad extends StatelessWidget {
  const CurvedRoad({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CurvedRoadPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _CurvedRoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPath = Path()
      ..moveTo(size.width * 0.84, 0)
      ..cubicTo(
        -size.width * 0.18,
        size.height * 0.14,
        size.width * 1.2,
        size.height * 0.26,
        size.width * 0.18,
        size.height * 0.44,
      )
      ..cubicTo(
        -size.width * 0.08,
        size.height * 0.56,
        size.width * 1.08,
        size.height * 0.68,
        size.width * 0.76,
        size.height * 0.82,
      )
      ..cubicTo(
        size.width * 0.98,
        size.height * 0.9,
        -size.width * 0.06,
        size.height * 0.96,
        size.width * 0.3,
        size.height,
      );

    final roadPaint = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(roadPath, roadPaint);

    final lanePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.92)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (final metric in roadPath.computeMetrics()) {
      var distance = 0.0;
      const dashLength = 18.0;
      const gapLength = 16.0;

      while (distance < metric.length) {
        final next = (distance + dashLength)
            .clamp(0.0, metric.length)
            .toDouble();
        canvas.drawPath(metric.extractPath(distance, next), lanePaint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
