import 'package:flutter/material.dart';

import '../../../../domain/entities/slot_entity.dart';
import '../../../../theme/app_typography.dart';
import '../../models/floorplan_config.dart';

class PositionedSlot extends StatefulWidget {
  const PositionedSlot({
    required this.slotConfig,
    required this.slot,
    required this.fillColor,
    required this.isFocused,
    required this.isSelected,
    this.showLabel = true,
    required this.onTap,
    super.key,
  });

  final ParkingSlotConfig slotConfig;
  final SlotEntity slot;
  final Color fillColor;
  final bool isFocused;
  final bool isSelected;
  final bool showLabel;
  final VoidCallback? onTap;

  @override
  State<PositionedSlot> createState() => _PositionedSlotState();
}

class _PositionedSlotState extends State<PositionedSlot> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final labelFontSize = _labelFontSize();
    final seatInset = (widget.slotConfig.rect.shortestSide * 0.08).clamp(
      1.2,
      4.0,
    );
    final cornerRadius = (widget.slotConfig.rect.shortestSide * 0.28).clamp(
      6.0,
      16.0,
    );
    final topBarHeight = (widget.slotConfig.rect.shortestSide * 0.12).clamp(
      2.0,
      4.0,
    );
    final visual = _resolveVisualSpec();

    return Positioned.fromRect(
      rect: widget.slotConfig.rect,
      child: Transform.rotate(
        angle: widget.slotConfig.rotation,
        child: GestureDetector(
          key: ValueKey('parking_slot_${widget.slotConfig.slot.id}'),
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          onTapDown: widget.onTap == null
              ? null
              : (_) => setState(() => _pressed = true),
          onTapUp: widget.onTap == null
              ? null
              : (_) => setState(() => _pressed = false),
          onTapCancel: widget.onTap == null
              ? null
              : () => setState(() => _pressed = false),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: widget.isFocused ? 1 : 0.94,
            child: Padding(
              padding: EdgeInsets.all(seatInset.toDouble()),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutBack,
                scale: _pressed
                    ? 0.94
                    : widget.isSelected
                    ? 1.08
                    : 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    gradient: visual.gradient,
                    borderRadius: BorderRadius.circular(
                      cornerRadius.toDouble(),
                    ),
                    border: Border.all(
                      color: visual.borderColor,
                      width: visual.borderWidth,
                    ),
                    boxShadow: visual.shadows,
                  ),
                  clipBehavior: Clip.antiAlias,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withValues(alpha: 0.24),
                                Colors.white.withValues(alpha: 0.02),
                                Colors.black.withValues(alpha: 0.05),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: widget.slotConfig.rect.width * 0.48,
                          height: topBarHeight.toDouble(),
                          margin: EdgeInsets.only(
                            top: (seatInset * 0.7).toDouble(),
                          ),
                          decoration: BoxDecoration(
                            color: visual.topAccent,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      if (widget.showLabel)
                        Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: Text(
                                _slotLabel(widget.slot.slotCode),
                                style: AppTypography.bodySmallSemiBold.copyWith(
                                  color: visual.textColor,
                                  fontSize: labelFontSize,
                                ),
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _labelFontSize() {
    final rect = widget.slotConfig.rect;
    final isWideHorizontalSlot = rect.width > (rect.height * 1.5);

    if (isWideHorizontalSlot) {
      return (rect.height * (widget.isFocused ? 0.86 : 0.74)).clamp(
        8.0,
        widget.isFocused ? 10.0 : 9.0,
      );
    }

    return (rect.shortestSide * (widget.isFocused ? 0.72 : 0.58)).clamp(
      7.0,
      widget.isFocused ? 10.0 : 8.0,
    );
  }

  SlotVisualSpec _resolveVisualSpec() {
    if (widget.isSelected) {
      return const SlotVisualSpec(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E74FF), Color(0xFF1E429A)],
        ),
        borderColor: Color(0xFFE5F0FF),
        borderWidth: 1.7,
        textColor: Colors.white,
        topAccent: Color(0xE6FFFFFF),
        shadows: [
          BoxShadow(
            color: Color(0x3A2E74FF),
            blurRadius: 18,
            spreadRadius: 1,
            offset: Offset(0, 10),
          ),
        ],
      );
    }

    if (!widget.slot.isBookable && widget.slot.activeSubscriptionUser != null) {
      final accent = widget.fillColor;
      return SlotVisualSpec(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(accent, const Color(0xFF4C5158), 0.5)!,
            Color.lerp(accent, const Color(0xFF23272C), 0.7)!,
          ],
        ),
        borderColor: accent.withValues(alpha: 0.9),
        borderWidth: 1.25,
        textColor: Colors.white,
        topAccent: accent.withValues(alpha: 0.95),
        shadows: [
          BoxShadow(
            color: accent.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      );
    }

    if (!widget.slot.isBookable) {
      return const SlotVisualSpec(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF87504C), Color(0xFF5D3432)],
        ),
        borderColor: Color(0xFFC89A95),
        borderWidth: 1.1,
        textColor: Color(0xFFFCEDED),
        topAccent: Color(0xFFDBA49E),
        shadows: [
          BoxShadow(
            color: Color(0x245D3432),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      );
    }

    if (widget.slot.isVip) {
      return const SlotVisualSpec(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF8A6D1E), Color(0xFF5A4512)],
        ),
        borderColor: Color(0xFFE4C15E),
        borderWidth: 1.1,
        textColor: Color(0xFFF8EDC7),
        topAccent: Color(0xFFF0C452),
        shadows: [
          BoxShadow(
            color: Color(0x245A4512),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      );
    }

    return const SlotVisualSpec(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF50575E), Color(0xFF2B3035)],
      ),
      borderColor: Color(0xFFE7ECEF),
      borderWidth: 1,
      textColor: Color(0xFFF7F9FB),
      topAccent: Color(0xFFF3F5F6),
      shadows: [
        BoxShadow(
          color: Color(0x1F111827),
          blurRadius: 10,
          offset: Offset(0, 6),
        ),
      ],
    );
  }

  String _slotLabel(String code) => code.trim();
}

class SlotVisualSpec {
  const SlotVisualSpec({
    this.gradient,
    required this.borderColor,
    required this.borderWidth,
    required this.textColor,
    required this.topAccent,
    required this.shadows,
  });

  final Gradient? gradient;
  final Color borderColor;
  final double borderWidth;
  final Color textColor;
  final Color topAccent;
  final List<BoxShadow> shadows;
}
