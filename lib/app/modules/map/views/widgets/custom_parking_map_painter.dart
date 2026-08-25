import 'package:flutter/material.dart';

import '../../models/floorplan_config.dart';

class CustomParkingMapPainter extends CustomPainter {
  const CustomParkingMapPainter({
    required this.config,
    required this.focusedZoneId,
  });

  final ParkingMapConfig config;
  final String? focusedZoneId;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF87AA68), Color(0xFF5C774F)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, backgroundPaint);
    _drawGrassTexture(canvas, size);

    final roadPaint = Paint()
      ..color = const Color(0xFF1D2126)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2;

    final curbPaint = Paint()
      ..color = const Color(0xFFCED4D1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final roadFillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4C5157), Color(0xFF23282D)],
      ).createShader(const Rect.fromLTWH(28, 150, 892, 1360));

    final outline = Path()
      ..moveTo(28, 150)
      ..lineTo(860, 150)
      ..lineTo(920, 150)
      ..lineTo(920, 980)
      ..quadraticBezierTo(905, 1100, 820, 1175)
      ..quadraticBezierTo(690, 1310, 540, 1375)
      ..quadraticBezierTo(330, 1465, 120, 1510)
      ..lineTo(28, 1510)
      ..close();

    canvas.drawShadow(outline, const Color(0x3A162014), 28, false);
    canvas.drawPath(outline, roadFillPaint);
    canvas.drawPath(outline, curbPaint);
    canvas.drawPath(outline, roadPaint);
    _drawParkingMarkings(canvas);
    _drawLaneGuides(canvas);
  }

  void _drawGrassTexture(Canvas canvas, Size size) {
    final stripePaint = Paint()
      ..color = const Color(0xFF2D4A24).withValues(alpha: 0.08)
      ..strokeWidth = 26;

    for (double x = -80; x < size.width + 80; x += 120) {
      canvas.drawLine(Offset(x, 0), Offset(x + 80, size.height), stripePaint);
    }

    final islandPaint = Paint()
      ..color = const Color(0xFF6C8E53).withValues(alpha: 0.55);
    canvas.drawCircle(const Offset(120, 140), 38, islandPaint);
    canvas.drawCircle(const Offset(882, 116), 26, islandPaint);
    canvas.drawCircle(const Offset(92, 1470), 44, islandPaint);
    canvas.drawCircle(const Offset(820, 1208), 32, islandPaint);
  }

  void _drawParkingMarkings(Canvas canvas) {
    final dashedPaint = Paint()
      ..color = const Color(0xFFF8F0B4).withValues(alpha: 0.82)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    _drawDashedLine(
      canvas,
      const Offset(220, 150),
      const Offset(812, 150),
      dashedPaint,
      dashLength: 18,
      gapLength: 14,
    );

    _drawDashedLine(
      canvas,
      const Offset(70, 250),
      const Offset(70, 1360),
      dashedPaint,
      dashLength: 20,
      gapLength: 14,
    );

    _drawDashedLine(
      canvas,
      const Offset(905, 200),
      const Offset(905, 860),
      dashedPaint,
      dashLength: 16,
      gapLength: 12,
    );
  }

  void _drawLaneGuides(Canvas canvas) {
    final laneShadowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final guidePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawRect(const Rect.fromLTWH(34, 176, 74, 1236), laneShadowPaint);
    canvas.drawRect(const Rect.fromLTWH(34, 176, 74, 1236), guidePaint);
    canvas.drawRect(const Rect.fromLTWH(848, 98, 32, 194), laneShadowPaint);
    canvas.drawRect(const Rect.fromLTWH(848, 98, 32, 194), guidePaint);
    canvas.drawLine(
      const Offset(108, 98),
      const Offset(848, 98),
      laneShadowPaint,
    );
    canvas.drawLine(const Offset(108, 98), const Offset(848, 98), guidePaint);
    canvas.drawLine(
      const Offset(108, 202),
      const Offset(848, 202),
      laneShadowPaint,
    );
    canvas.drawLine(const Offset(108, 202), const Offset(848, 202), guidePaint);
    canvas.drawRect(const Rect.fromLTWH(148, 300, 22, 146), laneShadowPaint);
    canvas.drawRect(const Rect.fromLTWH(148, 300, 22, 146), guidePaint);
    canvas.drawLine(
      const Offset(168, 300),
      const Offset(666, 300),
      laneShadowPaint,
    );
    canvas.drawLine(const Offset(168, 300), const Offset(666, 300), guidePaint);
    canvas.drawLine(
      const Offset(168, 404),
      const Offset(666, 404),
      laneShadowPaint,
    );
    canvas.drawLine(const Offset(168, 404), const Offset(666, 404), guidePaint);
    canvas.drawLine(
      const Offset(184, 602),
      const Offset(530, 602),
      laneShadowPaint,
    );
    canvas.drawLine(const Offset(184, 602), const Offset(530, 602), guidePaint);
    canvas.drawLine(
      const Offset(184, 696),
      const Offset(530, 696),
      laneShadowPaint,
    );
    canvas.drawLine(const Offset(184, 696), const Offset(530, 696), guidePaint);
    canvas.drawLine(
      const Offset(888, 124),
      const Offset(888, 870),
      laneShadowPaint,
    );
    canvas.drawLine(const Offset(888, 124), const Offset(888, 870), guidePaint);
    canvas.drawLine(
      const Offset(914, 124),
      const Offset(914, 870),
      laneShadowPaint,
    );
    canvas.drawLine(const Offset(914, 124), const Offset(914, 870), guidePaint);
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint, {
    required double dashLength,
    required double gapLength,
  }) {
    final totalLength = (end - start).distance;
    final direction = (end - start) / totalLength;
    double distance = 0;

    while (distance < totalLength) {
      final dashStart = start + (direction * distance);
      final dashEnd =
          start + (direction * (distance + dashLength).clamp(0, totalLength));
      canvas.drawLine(dashStart, dashEnd, paint);
      distance += dashLength + gapLength;
    }
  }

  @override
  bool shouldRepaint(covariant CustomParkingMapPainter oldDelegate) {
    return oldDelegate.focusedZoneId != focusedZoneId ||
        oldDelegate.config != config;
  }
}
