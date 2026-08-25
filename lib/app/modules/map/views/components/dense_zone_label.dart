import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../models/floorplan_config.dart';

class DenseZoneLabel extends StatelessWidget {
  const DenseZoneLabel({
    required this.zone,
    required this.isFocused,
    required this.onTap,
    super.key,
  });

  final ParkingZoneConfig zone;
  final bool isFocused;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final labelRect = _labelRectForZone(zone);
    final isNorthZone = zone.layoutKey == 'north';
    final isWideProminentZone =
        zone.layoutKey == 'south' || zone.layoutKey == 'middle' || isNorthZone;
    final isSideProminentZone =
        zone.layoutKey == 'west' || zone.layoutKey == 'east';
    final wideZonePadding = zone.layoutKey == 'south'
        ? const EdgeInsets.only(bottom: 32, right: 32)
        : const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          );
    final titleFontSize = isWideProminentZone
        ? isNorthZone
              ? (labelRect.height * 0.68).clamp(34.0, 72.0).toDouble()
              : (labelRect.height * 0.46).clamp(54.0, 118.0).toDouble()
        : isSideProminentZone
        ? (labelRect.width * 0.84).clamp(30.0, 52.0).toDouble()
        : 16.0;
    final subtitleFontSize = isWideProminentZone || isSideProminentZone
        ? 18.0
        : 11.0;
    final textColor = isFocused ? Colors.white : const Color(0xFFF8FAFC);
    final subtitleColor = textColor.withValues(alpha: isFocused ? 0.88 : 0.76);

    return Positioned.fromRect(
      rect: labelRect,
      child: GestureDetector(
        key: ValueKey('dense_zone_label_${zone.id}'),
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: isWideProminentZone
            ? Padding(
                padding: wideZonePadding,
                child: _ProminentZoneOverlay(
                  zone: zone,
                  isFocused: isFocused,
                  titleFontSize: titleFontSize,
                  subtitleFontSize: subtitleFontSize,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                ),
              )
            : isSideProminentZone
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2,
                  vertical: AppSpacing.sm,
                ),
                child: _SideZoneOverlay(
                  zone: zone,
                  isFocused: isFocused,
                  titleFontSize: titleFontSize,
                  subtitleFontSize: subtitleFontSize,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                ),
              )
            : _CompactZoneOverlay(
                zone: zone,
                isFocused: isFocused,
                textColor: textColor,
                subtitleColor: subtitleColor,
              ),
      ),
    );
  }
}

Rect _labelRectForZone(ParkingZoneConfig zone) {
  final contentBounds = _slotBoundsForZone(zone) ?? zone.focusBounds;
  final isNorthZone = zone.layoutKey == 'north';
  final isWideProminentZone =
      zone.layoutKey == 'south' || zone.layoutKey == 'middle' || isNorthZone;
  final isSideProminentZone =
      zone.layoutKey == 'west' || zone.layoutKey == 'east';
  if (isWideProminentZone) {
    final horizontalInset = isNorthZone
        ? math.min(8.0, zone.focusBounds.width * 0.01)
        : math.min(18.0, zone.focusBounds.width * 0.03);
    final verticalInset = isNorthZone
        ? math.min(4.0, zone.focusBounds.height * 0.03)
        : math.min(16.0, zone.focusBounds.height * 0.04);
    final availableBounds = Rect.fromLTWH(
      zone.focusBounds.left + horizontalInset,
      zone.focusBounds.top + verticalInset,
      zone.focusBounds.width - (horizontalInset * 2),
      zone.focusBounds.height - (verticalInset * 2),
    );
    if (isNorthZone) {
      return availableBounds;
    }
    final emphasizedBounds = contentBounds.inflate(
      math.max(18.0, contentBounds.shortestSide * 0.18),
    );
    final width = math
        .max(availableBounds.width * 0.92, emphasizedBounds.width)
        .clamp(availableBounds.width * 0.92, availableBounds.width);
    final height = math
        .max(availableBounds.height * 0.72, emphasizedBounds.height)
        .clamp(availableBounds.height * 0.72, availableBounds.height);

    return Rect.fromLTWH(
      availableBounds.center.dx - (width / 2),
      availableBounds.center.dy - (height / 2),
      width.toDouble(),
      height.toDouble(),
    );
  }

  if (isSideProminentZone) {
    final horizontalInset = math.min(4.0, zone.focusBounds.width * 0.03);
    final verticalInset = math.min(10.0, zone.focusBounds.height * 0.02);
    final availableBounds = Rect.fromLTWH(
      zone.focusBounds.left + horizontalInset,
      zone.focusBounds.top + verticalInset,
      zone.focusBounds.width - (horizontalInset * 2),
      zone.focusBounds.height - (verticalInset * 2),
    );
    final width = availableBounds.width;
    final height = availableBounds.height;

    return Rect.fromLTWH(
      availableBounds.center.dx - (width / 2),
      availableBounds.center.dy - (height / 2),
      width.toDouble(),
      height.toDouble(),
    );
  }

  final minWidth = zone.layoutKey == 'east' || zone.layoutKey == 'west'
      ? 88.0
      : 112.0;
  final width = math.min(
    math.max(minWidth, contentBounds.width * 0.34),
    zone.focusBounds.width - 16,
  );
  final height = 46.0;
  final left = (contentBounds.center.dx - (width / 2)).clamp(
    zone.focusBounds.left + 8,
    zone.focusBounds.right - width - 8,
  );
  final preferredTop =
      contentBounds.top + math.min(24.0, contentBounds.height * 0.1);
  final top = preferredTop.clamp(
    zone.focusBounds.top + 8,
    zone.focusBounds.bottom - height - 8,
  );

  return Rect.fromLTWH(
    (left as num).toDouble(),
    (top as num).toDouble(),
    width.toDouble(),
    height,
  );
}

Rect? _slotBoundsForZone(ParkingZoneConfig zone) {
  if (zone.slots.isEmpty) {
    return null;
  }

  var bounds = zone.slots.first.rect;
  for (final slot in zone.slots.skip(1)) {
    bounds = bounds.expandToInclude(slot.rect);
  }

  return bounds;
}

class _ProminentZoneOverlay extends StatelessWidget {
  const _ProminentZoneOverlay({
    required this.zone,
    required this.isFocused,
    required this.titleFontSize,
    required this.subtitleFontSize,
    required this.textColor,
    required this.subtitleColor,
  });

  final ParkingZoneConfig zone;
  final bool isFocused;
  final double titleFontSize;
  final double subtitleFontSize;
  final Color textColor;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    final isNorthZone = zone.layoutKey == 'north';

    if (isNorthZone) {
      final northTitle = zone.name.trim().toUpperCase().split('').join(' ');

      return AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: isFocused ? 0.98 : 0.92,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 2,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final northTitleSize = math
                    .min(titleFontSize, constraints.maxHeight * 0.72)
                    .clamp(34.0, 72.0);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          northTitle,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: AppTypography.h2.copyWith(
                            color: textColor.withValues(
                              alpha: isFocused ? 0.98 : 0.92,
                            ),
                            fontWeight: FontWeight.w900,
                            fontSize: northTitleSize.toDouble(),
                            letterSpacing: 0.4,
                            height: 0.95,
                            shadows: [
                              Shadow(
                                color: const Color(
                                  0xFF0F172A,
                                ).withValues(alpha: isFocused ? 0.3 : 0.22),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Tap to open',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmallSemiBold.copyWith(
                        color: subtitleColor,
                        fontSize: 20,
                        height: 1.0,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: isFocused ? 0.98 : 0.9,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.ms,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: isFocused ? 0.1 : 0.06),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF0F172A,
                      ).withValues(alpha: isFocused ? 0.18 : 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_outward_rounded,
                      size: 18,
                      color: textColor.withValues(alpha: 0.92),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Tap to open',
                      style: AppTypography.bodyMediumSemiBold.copyWith(
                        color: textColor.withValues(alpha: 0.9),
                        letterSpacing: 0.15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    zone.name.trim().toUpperCase(),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: AppTypography.h1.copyWith(
                      color: textColor.withValues(
                        alpha: isFocused ? 0.98 : 0.92,
                      ),
                      fontWeight: FontWeight.w800,
                      fontSize: titleFontSize,
                      letterSpacing: 2.2,
                      height: 0.95,
                      shadows: [
                        Shadow(
                          color: const Color(
                            0xFF0F172A,
                          ).withValues(alpha: isFocused ? 0.34 : 0.26),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${zone.slots.length} slots',
                textAlign: TextAlign.center,
                style: AppTypography.bodyLargeSemiBold.copyWith(
                  color: subtitleColor,
                  fontSize: subtitleFontSize - 1,
                  letterSpacing: 0.2,
                  shadows: [
                    Shadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.22),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideZoneOverlay extends StatelessWidget {
  const _SideZoneOverlay({
    required this.zone,
    required this.isFocused,
    required this.titleFontSize,
    required this.subtitleFontSize,
    required this.textColor,
    required this.subtitleColor,
  });

  final ParkingZoneConfig zone;
  final bool isFocused;
  final double titleFontSize;
  final double subtitleFontSize;
  final Color textColor;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    final letters = zone.name
        .trim()
        .toUpperCase()
        .split('')
        .where((char) => char.trim().isNotEmpty)
        .toList();
    final tapHintColor = textColor.withValues(alpha: isFocused ? 0.94 : 0.84);
    final titleStyle = AppTypography.h2.copyWith(
      color: textColor.withValues(alpha: isFocused ? 0.98 : 0.92),
      fontWeight: FontWeight.w900,
      fontSize: titleFontSize,
      height: 1.0,
      letterSpacing: 0.2,
      shadows: [
        Shadow(
          color: const Color(
            0xFF0F172A,
          ).withValues(alpha: isFocused ? 0.32 : 0.24),
          blurRadius: 14,
          offset: const Offset(0, 5),
        ),
      ],
    );

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: isFocused ? 0.98 : 0.92,
      child: SizedBox.expand(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.only(right: 32, top: 24),
              child: Column(
                children: [
                  Icon(
                    Icons.arrow_outward_rounded,
                    size: 16,
                    color: tapHintColor,
                  ),
                  Text(
                    'Tap to open',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmallSemiBold.copyWith(
                      color: tapHintColor,
                      fontSize: 24,
                      height: 0.9,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),

            Flexible(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final letter in letters)
                      Text(
                        letter,
                        textAlign: TextAlign.center,
                        style: titleStyle,
                      ),
                  ],
                ),
              ),
            ),
            Text(
              '${zone.slots.length}',
              textAlign: TextAlign.center,
              style: AppTypography.bodyLargeSemiBold.copyWith(
                color: subtitleColor,
                fontSize: subtitleFontSize - 1,
                height: 0.95,
              ),
            ),
            Text(
              'slots',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: subtitleColor,
                fontSize: 11,
                height: 0.9,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _CompactZoneOverlay extends StatelessWidget {
  const _CompactZoneOverlay({
    required this.zone,
    required this.isFocused,
    required this.textColor,
    required this.subtitleColor,
  });

  final ParkingZoneConfig zone;
  final bool isFocused;
  final Color textColor;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.ms,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isFocused
              ? const [Color(0xE61E3A8A), Color(0xE60F172A)]
              : const [Color(0xD9303640), Color(0xD91E232B)],
        ),
        borderRadius: AppRadius.pillRadius,
        border: Border.all(
          color: Colors.white.withValues(alpha: isFocused ? 0.9 : 0.52),
          width: isFocused ? 1.3 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF0F172A,
            ).withValues(alpha: isFocused ? 0.3 : 0.2),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                zone.name.trim(),
                maxLines: 1,
                style: AppTypography.bodyLargeSemiBold.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                ),
              ),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            '${zone.slots.length} slots',
            maxLines: 1,
            style: AppTypography.bodySmall.copyWith(
              color: subtitleColor,
              fontSize: 11,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
