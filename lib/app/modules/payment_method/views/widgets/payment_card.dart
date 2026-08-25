import 'package:flutter/material.dart';

import '../../../../domain/entities/user_card_entity.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({
    super.key,
    required this.card,
    required this.index,
    this.onTap,
  });

  final UserCardEntity card;
  final int index;
  final VoidCallback? onTap;

  static const _brandColors = <String, (Color, Color)>{
    'visa': (Color(0xFF1A1F71), Color(0xFF2B4BC6)),
    'mastercard': (Color(0xFF1A1A2E), Color(0xFF16213E)),
    'amex': (Color(0xFF006FCF), Color(0xFF0091D5)),
  };

  static const _fallbackColors = [
    (Color(0xFF2D3436), Color(0xFF636E72)),
    (Color(0xFF0C2340), Color(0xFF1B4070)),
    (Color(0xFF2C3E50), Color(0xFF4A6F8A)),
  ];

  (Color, Color) get _colors {
    final colors = _brandColors[card.brand.toLowerCase()];
    if (colors != null) return colors;
    return _fallbackColors[index % _fallbackColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final (primary, secondary) = _colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primary, secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              const _CardCurves(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: AppRadius.pillRadius,
                        ),
                        child: Text(
                          card.brand.toUpperCase(),
                          style: AppTypography.bodySmallSemiBold.copyWith(
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      _buildChip(),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    card.maskedNumber,
                    style: AppTypography.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.5,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.ms),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EXPIRES',
                            style: AppTypography.overline.copyWith(
                              color: Colors.white.withValues(alpha: 0.6),
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            card.expiry,
                            style: AppTypography.bodyMediumSemiBold.copyWith(
                              color: Colors.white.withValues(alpha: 0.95),
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      if (card.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: AppRadius.pillRadius,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Text(
                            'DEFAULT',
                            style: AppTypography.overline.copyWith(
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static final _chipPainter = _ChipLinePainter();

  Widget _buildChip() {
    return Row(
      children: [
        Container(
          width: 28,
          height: 20,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE8B730), Color(0xFFD4A520)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: CustomPaint(painter: _chipPainter),
        ),
        const SizedBox(width: AppSpacing.xs),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

class _ChipLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC49B20).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Horizontal lines
    canvas.drawLine(
      Offset(0, size.height * 0.33),
      Offset(size.width, size.height * 0.33),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.66),
      Offset(size.width, size.height * 0.66),
      paint,
    );
    // Vertical line
    canvas.drawLine(
      Offset(size.width * 0.5, 0),
      Offset(size.width * 0.5, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CardCurves extends StatelessWidget {
  const _CardCurves();

  static final _painter = _CardCurvePainter();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(child: CustomPaint(painter: _painter)),
    );
  }
}

class _CardCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final pathOne = Path()
      ..moveTo(-8, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.2,
        size.height * 0.15,
        size.width * 0.45,
        size.height * 0.25,
      )
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.35,
        size.width * 0.65,
        -4,
      );

    final pathTwo = Path()
      ..moveTo(size.width * 0.4, size.height + 8)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.7,
        size.width * 0.72,
        size.height * 0.72,
      )
      ..quadraticBezierTo(
        size.width * 0.95,
        size.height * 0.68,
        size.width + 10,
        size.height * 0.45,
      );

    canvas.drawPath(pathOne, paint);
    canvas.drawPath(pathTwo, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
