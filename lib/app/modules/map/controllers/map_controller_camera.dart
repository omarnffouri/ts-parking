part of 'map_controller.dart';

extension MapControllerCameraX on MapController {
  void ensureViewport(Size viewportSize) {
    if (viewportSize.isEmpty) return;
    final overviewBounds = activeMapConfig.overviewBounds;
    if (_viewportSize == viewportSize &&
        _viewportOverviewBounds == overviewBounds) {
      return;
    }

    _viewportSize = viewportSize;
    _viewportOverviewBounds = overviewBounds;
    _overviewScale = _fitScaleForRect(
      overviewBounds,
      viewportSize,
      padding: 12,
    );
    _overviewTransform = _matrixForRect(
      overviewBounds,
      viewportSize,
      padding: 12,
    );

    if (_focusedZoneId.value == null) {
      transformationController.value = _overviewTransform.clone();
      return;
    }

    final zone = focusedZone;
    if (zone != null) {
      transformationController.value = _matrixForZone(zone, viewportSize);
    }
  }

  void focusZone(ParkingZoneConfig zone) {
    _focusedZoneId.value = zone.id;
    _selectedSlot.value = null;
    final viewport = _viewportSize;
    if (viewport == null) return;
    _animateTo(_matrixForZone(zone, viewport));
  }

  void showOverview() {
    _focusedZoneId.value = null;
    _selectedSlot.value = null;
    _animateTo(_overviewTransform);
  }

  void zoomIn() => _zoomBy(1.25);

  void zoomOut() => _zoomBy(0.8);

  void resetZoom() {
    if (focusedZone != null) {
      focusZone(focusedZone!);
      return;
    }
    showOverview();
  }

  bool canSelectSlot(ParkingZoneConfig zone) => focusedZoneId == zone.id;

  void _focusSlotRect(Rect rect) {
    final viewport = _viewportSize;
    if (viewport == null) return;

    final isTinySlot = rect.shortestSide <= 22;
    final targetRect = rect.inflate(isTinySlot ? 6 : 18);
    final currentScale = transformationController.value.getMaxScaleOnAxis();
    final desiredScale =
        _fitScaleForRect(targetRect, viewport, padding: isTinySlot ? 18 : 72) *
        (isTinySlot ? 1.18 : 1.02);
    final minimumScale = minInteractiveScale * (isTinySlot ? 7.5 : 2.8);
    final targetScale = math.max(currentScale, desiredScale);
    final clampedScale = targetScale.clamp(minimumScale, maxInteractiveScale);
    final viewportCenter = Offset(viewport.width / 2, viewport.height / 2);

    final target = Matrix4.diagonal3Values(clampedScale, clampedScale, 1)
      ..setTranslationRaw(
        viewportCenter.dx - (rect.center.dx * clampedScale),
        viewportCenter.dy - (rect.center.dy * clampedScale),
        0,
      );

    _animateTo(target);
  }

  void _zoomBy(double factor) {
    final viewport = _viewportSize;
    if (viewport == null) return;

    final current = transformationController.value;
    final currentScale = current.getMaxScaleOnAxis();
    final nextScale = (currentScale * factor).clamp(
      minInteractiveScale,
      maxInteractiveScale,
    );
    final viewportCenter = Offset(viewport.width / 2, viewport.height / 2);
    final sceneCenter = transformationController.toScene(viewportCenter);

    final target = Matrix4.diagonal3Values(nextScale, nextScale, 1)
      ..setTranslationRaw(
        viewportCenter.dx - (sceneCenter.dx * nextScale),
        viewportCenter.dy - (sceneCenter.dy * nextScale),
        0,
      );

    _animateTo(target);
  }

  void _animateTo(Matrix4 target) {
    _zoomAnimationController.stop();
    _zoomAnimation =
        Matrix4Tween(
          begin: transformationController.value.clone(),
          end: target,
        ).animate(
          CurvedAnimation(
            parent: _zoomAnimationController,
            curve: Curves.easeInOutCubic,
          ),
        );
    _zoomAnimationController.forward(from: 0);
  }

  Matrix4 _matrixForZone(ParkingZoneConfig zone, Size viewport) {
    final focusRect = _focusRectForZone(zone);
    final slotBounds = _slotBoundsForZone(zone) ?? focusRect;
    final shortestSide = math.min(slotBounds.width, slotBounds.height);
    final longestSide = math.max(slotBounds.width, slotBounds.height);
    final aspectRatio = longestSide / math.max(1.0, shortestSide);
    final padding = shortestSide <= 120
        ? 18.0
        : shortestSide <= 260
        ? 24.0
        : 32.0;
    final computedMultiplier = aspectRatio >= 4
        ? 1.18
        : aspectRatio >= 2.5
        ? 1.26
        : shortestSide <= 120
        ? 1.72
        : shortestSide <= 260
        ? 1.52
        : 1.34;

    return _matrixForRect(
      focusRect,
      viewport,
      padding: padding,
      scaleMultiplier: math.max(zone.focusScaleMultiplier, computedMultiplier),
      minimumScale: minInteractiveScale,
      maximumScale: maxInteractiveScale,
    );
  }

  Rect _focusRectForZone(ParkingZoneConfig zone) {
    final slotBounds = _slotBoundsForZone(zone);
    if (slotBounds == null) {
      return zone.focusBounds;
    }

    final shortestSide = math.min(slotBounds.width, slotBounds.height);
    final inflateBy = shortestSide <= 120
        ? 16.0
        : shortestSide <= 260
        ? 22.0
        : 30.0;

    return _clampRectToDesignSize(slotBounds.inflate(inflateBy));
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

  Rect _clampRectToDesignSize(Rect rect) {
    final designSize = activeMapConfig.designSize;

    return Rect.fromLTRB(
      rect.left.clamp(0.0, designSize.width),
      rect.top.clamp(0.0, designSize.height),
      rect.right.clamp(0.0, designSize.width),
      rect.bottom.clamp(0.0, designSize.height),
    );
  }

  Matrix4 _matrixForRect(
    Rect rect,
    Size viewport, {
    double padding = 80,
    double scaleMultiplier = 1,
    double? minimumScale,
    double? maximumScale,
  }) {
    final rawScale =
        _fitScaleForRect(rect, viewport, padding: padding) * scaleMultiplier;
    final scale = rawScale.clamp(
      minimumScale ?? rawScale,
      maximumScale ?? rawScale,
    );

    return Matrix4.diagonal3Values(scale, scale, 1)..setTranslationRaw(
      (viewport.width / 2) - (rect.center.dx * scale),
      (viewport.height / 2) - (rect.center.dy * scale),
      0,
    );
  }

  double _fitScaleForRect(Rect rect, Size viewport, {double padding = 80}) {
    final availableWidth = viewport.width - padding;
    final availableHeight = viewport.height - padding;
    final widthScale = availableWidth / rect.width;
    final heightScale = availableHeight / rect.height;
    return math.min(widthScale, heightScale);
  }
}
